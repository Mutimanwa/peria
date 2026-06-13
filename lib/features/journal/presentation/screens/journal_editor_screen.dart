import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_text.dart';
import 'package:peria_app/features/journal/data/models/mood.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';
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
  String _moodId = 'calm';
  JournalEntry? _existing;
  bool _isSaving = false;

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
    super.dispose();
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
      }
    }
  }

  Future<void> _save() async {
    final cleanTitle = _titleController.text.trim();
    final cleanContent = _contentController.text.trim();

    // On n'enregistre pas une note totalement vide
    if (cleanTitle.isEmpty && cleanContent.isEmpty) {
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
          )
        : JournalEntry(
            id: 'entry_${now.millisecondsSinceEpoch}', // Préfixe propre pour l'identifiant
            createdAt: now,
            updatedAt: now,
            title: cleanTitle,
            content: cleanContent,
            mood: _moodId,
          );

    try {
      await ref.read(journalProvider.notifier).upsert(entry);
      if (mounted) {
        context.go('/journal');
      }
    } catch (e) {
      // Sécurité en cas d'échec de la base de données locale
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur lors de l'enregistrement : $e")),
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
    final l10n = AppLocalizations.of(context);
    
    // Fallback automatique si la locale 'fr' n'est pas encore chargée globalement
    final entryDate = _existing?.createdAt ?? DateTime.now();
    String dateStr;
    try {
      dateStr = DateFormat('d MMM yyyy', 'fr').format(entryDate);
    } catch (_) {
      dateStr = DateFormat('d MMM yyyy').format(entryDate);
    }
    final timeStr = DateFormat('HH:mm').format(entryDate);

    return PageScaffold(
      showBack: true,
      onBack: () => context.go('/journal'),
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
                          style: AppText.body.copyWith(color: AppColors.grey400)),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 14),
                  
                  // Input Titre
                  TextField(
                    controller: _titleController,
                    style: AppText.h3.copyWith(fontWeight: FontWeight.w800, fontSize: 24),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: l10n.myDairy,
                      hintStyle: const TextStyle(color: AppColors.grey300),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Input Contenu
                  TextField(
                    controller: _contentController,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.multiline,
                    style: AppText.body.copyWith(
                        fontSize: 17, height: 1.6, color: AppColors.grey800),
                    decoration: InputDecoration(
                      hintText: l10n.aboutYourDay,
                      hintStyle: const TextStyle(color: AppColors.grey300),
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
            onPressed: _insertImage,
          ),
          // 2. Liste à puces
          _ToolbarIcon(
            icon: Icons.format_list_bulleted,
            onPressed: () => _insertTextAtCursor("• "),
          ),
          // 3. To-Do List / Case à cocher
          _ToolbarIcon(
            icon: Icons.check_box_outlined,
            onPressed: () => _insertTextAtCursor("[ ] "),
          ),
          // 4. Majuscules / Raccourci texte rapide
          _ToolbarIcon(
            icon: Icons.text_fields,
            onPressed: _toggleCase,
          ),
          
          // Bouton Humeur (Déjà fonctionnel)
          InkWell(
            onTap: _showMoodPicker,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(currentMood.icon, color: currentMood.accent, size: 26),
            ),
          ),
          
          // 5. Audio / Micro
          _ToolbarIcon(
            icon: Icons.mic_none,
            onPressed: _startVoiceTyping,
          ),
        ],
      ),
    );
  }

  // --- LOGIQUE DES ACTIONS DE LA TOOLBAR ---

  // Fonction universelle pour insérer du texte là où se trouve le curseur de l'utilisatrice
  void _insertTextAtCursor(String textToInsert) {
    final text = _contentController.text;
    final selection = _contentController.selection;
    
    // Si le curseur n'est pas positionné, on ajoute à la fin
    if (!selection.isValid) {
      _contentController.text = text + textToInsert;
      return;
    }

    final newText = text.replaceRange(selection.start, selection.end, textToInsert);
    final newSelectionIndex = selection.start + textToInsert.length;

    _contentController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
    
    // Force le focus sur le champ de texte pour faire réapparaître le clavier
    FocusScope.of(context).requestFocus();
  }

  // Action Image : Ouvre la galerie du téléphone
Future<void> _insertImage() async {
    final ImagePicker picker = ImagePicker();
    
    // On propose le choix de la source à l'utilisatrice
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.grey200, borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary500),
              title: const Text("Choisir depuis la galerie"),
              onTap: () async {
                Navigator.pop(bottomSheetContext);
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 70, // Compresse à 70% pour économiser la RAM et le stockage
                );
                if (image != null) {
                  _handleSelectedImage(image.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary500),
              title: const Text("Prendre une photo"),
              onTap: () async {
                Navigator.pop(bottomSheetContext);
                final XFile? image = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 70,
                );
                if (image != null) {
                  _handleSelectedImage(image.path);
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _handleSelectedImage(String path) {
    // Pour l'instant, on insère le tag du chemin local dans le texte de l'éditeur.
    // Plus tard, dans ton modèle JournalEntry, tu pourras ajouter un champ List<String> imagePaths
    // et faire un affichage sous forme de grille d'images dans l'UI.
    _insertTextAtCursor("\n🖼️ [image:$path] \n");
    
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Image ajoutée avec succès au journal !"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Action Raccourci Texte : Alterne la sélection en MAJUSCULES / minuscules
  void _toggleCase() {
    final selection = _contentController.selection;
    if (!selection.isValid || selection.isCollapsed) {
      _insertTextAtCursor("✨ "); // Si rien n'est sélectionné, on insère un emoji de style
      return;
    }

    final text = _contentController.text;
    final selectedText = text.substring(selection.start, selection.end);
    
    // Si c'est déjà en majuscule, on met en minuscule, sinon l'inverse
    final isUpperCase = selectedText == selectedText.toUpperCase();
    final transformedText = isUpperCase ? selectedText.toLowerCase() : selectedText.toUpperCase();

    _contentController.value = TextEditingValue(
      text: text.replaceRange(selection.start, selection.end, transformedText),
      selection: selection,
    );
  }

  // Action Micro : Note vocale ou dictée
  void _startVoiceTyping() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Enregistrement audio bientôt disponible..."), duration: Duration(seconds: 1)),
    );
  }

  void _showMoodPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: Padding(
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
              const Text("Comment te sens-tu ?", style: AppText.h4),
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
                          m.label,
                          style: TextStyle(
                            color: isSelected ? m.accent : AppColors.grey500,
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
  final VoidCallback? onPressed; 
  
  const _ToolbarIcon({
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: AppColors.grey400, size: 24),
      onPressed: onPressed, 
    );
  }
}