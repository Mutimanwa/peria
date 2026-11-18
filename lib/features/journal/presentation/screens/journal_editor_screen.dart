import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_text.dart';
import 'package:peria_app/features/journal/data/models/mood.dart';
import 'package:peria_app/features/journal/presentation/mood_localization.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:peria_app/features/journal/presentation/widgets/journal_attachment_view.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class JournalEditorScreen extends ConsumerStatefulWidget {
  const JournalEditorScreen({super.key, this.entryId});

  final String? entryId;

  @override
  ConsumerState<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends ConsumerState<JournalEditorScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  /// Le bouton « puce » ou « case à cocher » écrit dans le corps de la note :
  /// sans nœud de focus, la barre d'outils fermait le clavier au lieu de le
  /// ramener sur le texte.
  final _contentFocus = FocusNode();

  String _moodId = 'calm';
  JournalEntry? _existing;
  bool _isSaving = false;
  final List<String> _attachments = [];

  /// Vrai une fois que la sortie de l'écran a été confirmée : le `PopScope`
  /// laisse alors passer le retour.
  bool _allowPop = false;

  @override
  void initState() {
    super.initState();
    _loadExistingEntry();
  }

  @override
  void dispose() {
    // FIX : Libération impérative de la mémoire pour éviter les leaks
    _titleController.dispose();
    _contentController.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  // ── Sortie de l'écran ────────────────────────────────────────────────────

  /// Le texte a-t-il changé depuis l'ouverture de l'écran ?
  bool get _hasUnsavedChanges {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final existing = _existing;
    if (existing == null) {
      return title.isNotEmpty ||
          content.isNotEmpty ||
          _attachments.isNotEmpty ||
          _moodId != 'calm';
    }
    return title != existing.title.trim() ||
        content != existing.content.trim() ||
        _moodId != existing.mood ||
        !listEquals(_attachments, existing.attachments);
  }

  Future<void> _requestClose() async {
    if (_isSaving) return;
    if (!_hasUnsavedChanges) {
      _leaveScreen();
      return;
    }

    final l10n = AppLocalizations.of(context);
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.journalDiscardTitle),
        content: Text(l10n.journalDiscardBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.journalKeepWriting),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              l10n.journalDiscard,
              style: const TextStyle(color: AppColors.error700),
            ),
          ),
        ],
      ),
    );

    if (discard == true && mounted) _leaveScreen();
  }

  void _leaveScreen() {
    _allowPop = true;
    safeRouterBack(context, fallbackRoute: '/journal');
  }

  void _loadExistingEntry() {
    final entries = ref.read(journalProvider).value ?? const <JournalEntry>[];
    if (widget.entryId != null) {
      _existing = entries.cast<JournalEntry?>().firstWhere(
            (item) => item?.id == widget.entryId,
            orElse: () => null,
          );
      if (_existing != null) {
        _titleController.text = _existing!.title;
        _contentController.text = _existing!.content;
        _moodId = _existing!.mood;
        _attachments
          ..clear()
          ..addAll(_existing!.attachments);
      }
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final cleanTitle = _titleController.text.trim();
    final cleanContent = _contentController.text.trim();

    // On n'enregistre pas une note totalement vide
    if (cleanTitle.isEmpty && cleanContent.isEmpty && _attachments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.journalEntryEmpty)),
      );
      return;
    }

    setState(() => _isSaving = true);
    final now = DateTime.now();

    // FIX : Récriture propre de la logique de création/mise à jour
    final entry = _existing != null
        ? _existing!.copyWith(
            updatedAt: now,
            title: cleanTitle,
            content: cleanContent,
            mood: _moodId,
            attachments: List<String>.from(_attachments),
          )
        : JournalEntry(
            id: 'entry_${now.millisecondsSinceEpoch}', // Préfixe propre pour l'identifiant
            createdAt: now,
            updatedAt: now,
            title: cleanTitle,
            content: cleanContent,
            mood: _moodId,
            attachments: List<String>.from(_attachments),
          );

    try {
      await ref.read(journalProvider.notifier).upsert(entry);
      if (mounted) {
        _allowPop = true;
        safeRouterBack(context, fallbackRoute: '/journal');
      }
    } catch (e) {
      // Sécurité en cas d'échec de la base de données locale
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.journalSaveError)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: (didPop, result) {
        // Retour système : on passe par la même confirmation que le bouton.
        if (!didPop) _requestClose();
      },
      child: _buildEditor(context),
    );
  }

  Widget _buildEditor(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Fallback automatique si la locale 'fr' n'est pas encore chargée globalement
    final entryDate = _existing?.createdAt ?? DateTime.now();
    final locale = Localizations.localeOf(context).toString();
    final dateStr = DateFormat('d MMM yyyy', locale).format(entryDate);
    final timeStr = DateFormat('HH:mm').format(entryDate);

    return PageScaffold(
      showBack: true,
      onBack: _requestClose,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Center( // Alignement vertical propre du bouton dans la barre d'actions
            child: ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary500,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary500.withOpacity(0.6),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)), // Plus moderne et arrondi
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(l10n.save,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ),
      ],
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70), // Réduit l'espace géant du haut
                  // Section Date et Heure
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.grey500),
                      const SizedBox(width: 8),
                      Text(dateStr,
                          style: AppText.body.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.grey900)),
                      const SizedBox(width: 8),
                      Text(timeStr,
                          style: AppText.body.copyWith(color: AppColors.textSecondary)),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 14),
                  
                  // Input Titre
                  TextField(
                    controller: _titleController,
                    style: AppText.h3.copyWith(fontWeight: FontWeight.w800, fontSize: 24),
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _contentFocus.requestFocus(),
                    decoration: InputDecoration(
                      hintText: l10n.myDairy,
                      hintStyle: AppText.h3.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: AppColors.textSecondary,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_attachments.isNotEmpty) ...[
                    SizedBox(
                      height: 88,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _attachments.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final path = _attachments[index];
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: journalAttachmentView(path),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () => setState(
                                    () => _attachments.removeAt(index),
                                  ),
                                  child: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.black54,
                                    child: Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  
                  // Input Contenu
                  TextField(
                    controller: _contentController,
                    focusNode: _contentFocus,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    style: AppText.body.copyWith(
                        fontSize: 17, height: 1.6, color: AppColors.grey800),
                    decoration: InputDecoration(
                      hintText: l10n.aboutYourDay,
                      hintStyle: AppText.body.copyWith(
                        fontSize: 17,
                        height: 1.6,
                        color: AppColors.textSecondary,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Barre d'outils flottante en bas
          _buildBottomToolbar(),
        ],
      ),
    );
  }

Widget _buildBottomToolbar() {
    final l10n = AppLocalizations.of(context);
    final currentMood = Mood.fromId(_moodId);
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 12, top: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.grey200, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. Ajouter une Image
          _ToolbarIcon(
            icon: Icons.image_outlined,
            semanticLabel: l10n.journalPhotoGallery,
            onPressed: _insertImage,
          ),
          // 2. Liste à puces
          _ToolbarIcon(
            icon: Icons.format_list_bulleted,
            semanticLabel: l10n.journalBulletAction,
            onPressed: () => _insertSnippet('• '),
          ),
          // 3. To-Do List / Case à cocher
          _ToolbarIcon(
            icon: Icons.check_box_outlined,
            semanticLabel: l10n.journalChecklistAction,
            onPressed: () => _insertSnippet('[ ] '),
          ),
          // 4. Changer la casse de la sélection
          _ToolbarIcon(
            icon: Icons.text_fields,
            semanticLabel: l10n.journalCaseAction,
            onPressed: _toggleCase,
          ),

          // Bouton Humeur
          Semantics(
            button: true,
            label: l10n.journalMoodQuestion,
            child: ExcludeSemantics(
              child: InkWell(
                onTap: _showMoodPicker,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    currentMood.icon,
                    color: currentMood.accent,
                    size: 26,
                  ),
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  // --- LOGIQUE DES ACTIONS DE LA TOOLBAR ---

  // Insère un fragment (puce, case à cocher) là où se trouve le curseur.
  void _insertSnippet(String snippet) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    final hasCursor = selection.isValid && selection.start >= 0;

    if (!hasCursor) {
      // Curseur jamais posé : on ajoute à la fin, sur une nouvelle ligne.
      final needsNewLine = text.isNotEmpty && !text.endsWith('\n');
      final insertion = '${needsNewLine ? '\n' : ''}$snippet';
      _contentController.value = TextEditingValue(
        text: '$text$insertion',
        selection:
            TextSelection.collapsed(offset: text.length + insertion.length),
      );
    } else {
      final beforeCursor = text.substring(0, selection.start);
      final needsNewLine =
          beforeCursor.isNotEmpty && !beforeCursor.endsWith('\n');
      final insertion = '${needsNewLine ? '\n' : ''}$snippet';
      final newText =
          text.replaceRange(selection.start, selection.end, insertion);
      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + insertion.length,
        ),
      );
    }

    _contentFocus.requestFocus();
  }

  // Action Image : propose la galerie ou l'appareil photo.
  Future<void> _insertImage() async {
    final l10n = AppLocalizations.of(context);
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: AppColors.primary500,
              ),
              title: Text(l10n.journalPhotoGallery),
              onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.primary500,
              ),
              title: Text(l10n.journalTakePhoto),
              onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    try {
      final picked = await ImagePicker().pickImage(
        source: source,
        imageQuality: 70, // compresse pour économiser la RAM et le stockage
      );
      if (picked == null || !mounted) return;
      await _addAttachment(picked);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.journalImageError)),
      );
    }
  }

  /// `image_picker` écrit dans le cache : une photo non copiée disparaît dès
  /// qu'Android nettoie ce dossier. On la déplace dans les documents de
  /// l'application pour que le souvenir reste lisible des mois plus tard.
  Future<void> _addAttachment(XFile file) async {
    final l10n = AppLocalizations.of(context);
    final path = await _persistImage(file.path);
    if (!mounted) return;
    if (path == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.journalImageError)),
      );
      return;
    }

    setState(() => _attachments.add(path));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.journalImageAdded),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<String?> _persistImage(String sourcePath) async {
    try {
      final documents = await getApplicationDocumentsDirectory();
      final folder = Directory('${documents.path}/journal_images');
      if (!folder.existsSync()) folder.createSync(recursive: true);
      final fileName = sourcePath.split(Platform.pathSeparator).last;
      final target =
          '${folder.path}/${DateTime.now().microsecondsSinceEpoch}_$fileName';
      await File(sourcePath).copy(target);
      return target;
    } catch (_) {
      return null;
    }
  }

  // Change la casse de la sélection, ou du mot sous le curseur.
  void _toggleCase() {
    final l10n = AppLocalizations.of(context);
    final text = _contentController.text;
    final selection = _contentController.selection;
    final hasSelection = selection.isValid &&
        !selection.isCollapsed &&
        selection.start >= 0 &&
        selection.end <= text.length;

    var start = selection.isValid ? selection.start : text.length;
    var end = hasSelection ? selection.end : start;

    if (!hasSelection) {
      // Pas de sélection : on prend le mot autour du curseur.
      while (start > 0 && !_isWordBoundary(text[start - 1])) {
        start--;
      }
      end = selection.isValid ? selection.start : text.length;
      while (end < text.length && !_isWordBoundary(text[end])) {
        end++;
      }
    }

    if (start >= end) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.journalToggleCaseHint)),
      );
      return;
    }

    final target = text.substring(start, end);
    final isUpperCase = target == target.toUpperCase();
    final transformed =
        isUpperCase ? target.toLowerCase() : target.toUpperCase();

    _contentController.value = TextEditingValue(
      text: text.replaceRange(start, end, transformed),
      selection: TextSelection(
        baseOffset: start,
        extentOffset: start + transformed.length,
      ),
    );
    _contentFocus.requestFocus();
  }

  bool _isWordBoundary(String char) =>
      RegExp(r'''[\s.,;:!?«»"()\[\]•]''').hasMatch(char);

  void _showMoodPicker() {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      // Les six humeurs dépassent la moitié de l'écran sur un petit
      // téléphone : la feuille doit pouvoir défiler.
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(l10n.journalMoodQuestion, style: AppText.h4),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: Mood.all.map((m) {
                  final isSelected = _moodId == m.id;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _moodId = m.id);
                      Navigator.pop(context);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected ? m.accent.withOpacity(0.1) : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            m.icon,
                            size: 36,
                            color: isSelected ? m.accent : AppColors.grey300,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          m.localizedLabel(l10n),
                          style: TextStyle(
                            color: isSelected ? m.accent : AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onPressed;

  const _ToolbarIcon({
    required this.icon,
    required this.semanticLabel,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: ExcludeSemantics(
        child: IconButton(
          tooltip: semanticLabel,
          icon: Icon(icon, color: AppColors.grey500, size: 24),
          onPressed: onPressed,
        ),
      ),
    );
  }
}