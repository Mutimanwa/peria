import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/core/theme/app_text.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class JournalSyncSettingsScreen extends ConsumerStatefulWidget {
  const JournalSyncSettingsScreen({super.key});

  @override
  ConsumerState<JournalSyncSettingsScreen> createState() =>
      _JournalSyncSettingsScreenState();
}

class _JournalSyncSettingsScreenState
    extends ConsumerState<JournalSyncSettingsScreen> {
  static const _syncTimeout = Duration(seconds: 20);

  bool _isLoading = true;
  bool _isBusy = false;
  bool _isEnabled = false;
  bool _lastAttemptFailed = false;
  DateTime? _lastSyncedAt;
  String? _errorMessage;
  String? _feedbackMessage;

  @override
  void initState() {
    super.initState();
    _refreshPreferences();
  }

  Future<void> _refreshPreferences({bool showLoading = false}) async {
    if (showLoading && mounted) setState(() => _isLoading = true);
    try {
      final repository = ref.read(journalRepositoryProvider);
      final enabled = await repository.isCloudSyncEnabled();
      final lastSyncedAt = await repository.lastSyncedAt();
      final lastAttemptFailed = await repository.lastSyncAttemptFailed();
      if (!mounted) return;
      setState(() {
        _isEnabled = enabled;
        _lastSyncedAt = lastSyncedAt;
        _lastAttemptFailed = lastAttemptFailed;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = AppLocalizations.of(context).journalSyncSettingsError;
      });
    }
  }

  Future<void> _onSyncChanged(bool enabled) async {
    if (enabled) {
      await _enableSync();
    } else {
      await _disableSync();
    }
  }

  Future<void> _enableSync() async {
    final accepted = await _showEnableConsent();
    if (!accepted || !mounted) return;

    setState(() {
      _isBusy = true;
      _errorMessage = null;
      _feedbackMessage = null;
    });

    try {
      // The consent flag is saved locally before the first Firestore request.
      await ref.read(journalRepositoryProvider).enableCloudSync();
      if (mounted) setState(() => _isEnabled = true);

      await ref
          .read(journalProvider.notifier)
          .syncWithCloud()
          .timeout(_syncTimeout);
      await _refreshPreferences();
      if (mounted) {
        setState(() => _feedbackMessage =
            AppLocalizations.of(context).journalSyncCompleted);
      }
    } catch (_) {
      await _refreshPreferences();
      if (mounted) {
        setState(() => _errorMessage =
            AppLocalizations.of(context).journalSyncError);
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _disableSync() async {
    final confirmed = await _showDisableConfirmation();
    if (!confirmed || !mounted) return;

    setState(() {
      _isBusy = true;
      _errorMessage = null;
      _feedbackMessage = null;
    });
    try {
      await ref.read(journalSyncPreferencesProvider).disable();
      if (mounted) setState(() => _isEnabled = false);
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage =
            AppLocalizations.of(context).journalSyncSettingsError);
      }
      await _refreshPreferences();
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _syncNow() async {
    if (!_isEnabled || _isBusy) return;
    setState(() {
      _isBusy = true;
      _errorMessage = null;
      _feedbackMessage = null;
    });
    try {
      await ref
          .read(journalProvider.notifier)
          .syncWithCloud()
          .timeout(_syncTimeout);
      await _refreshPreferences();
      if (mounted) {
        setState(() => _feedbackMessage =
            AppLocalizations.of(context).journalSyncCompleted);
      }
    } catch (_) {
      await _refreshPreferences();
      if (mounted) {
        setState(() => _errorMessage =
            AppLocalizations.of(context).journalSyncError);
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _deleteCloudCopy() async {
    final confirmed = await _showDeleteConfirmation();
    if (!confirmed || !mounted) return;

    setState(() {
      _isBusy = true;
      _errorMessage = null;
      _feedbackMessage = null;
    });
    try {
      // Revoke sync first. A failed network deletion leaves sync disabled so
      // no new entries are uploaded while the user retries.
      await ref.read(journalSyncPreferencesProvider).disable();
      if (mounted) setState(() => _isEnabled = false);
      await ref.read(journalRepositoryProvider).deleteCloudEntries();
      await _refreshPreferences();
      if (mounted) {
        setState(() => _feedbackMessage =
            AppLocalizations.of(context).journalCloudDeleteSuccess);
      }
    } catch (_) {
      await _refreshPreferences();
      if (mounted) {
        setState(() => _errorMessage =
            AppLocalizations.of(context).journalCloudDeleteError);
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<bool> _showEnableConsent() async {
    final l10n = AppLocalizations.of(context);
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: AppColors.white,
            title: Text(l10n.journalSyncConsentTitle),
            content: SingleChildScrollView(
              child: Text(l10n.journalSyncConsentBody),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l10n.enableAndSync),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _showDisableConfirmation() async {
    final l10n = AppLocalizations.of(context);
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: AppColors.white,
            title: Text(l10n.journalSyncDisableTitle),
            content: Text(l10n.journalSyncDisableBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l10n.turnOffSync),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _showDeleteConfirmation() async {
    final l10n = AppLocalizations.of(context);
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            backgroundColor: AppColors.white,
            title: Text(l10n.journalCloudDeleteTitle),
            content: Text(l10n.journalCloudDeleteBody),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: AppColors.white,
                ),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l10n.deleteCloudCopy),
              ),
            ],
          ),
        ) ??
        false;
  }

  String _statusText(AppLocalizations l10n) {
    if (!_isEnabled) return l10n.journalSyncLocalOnly;
    if (_lastAttemptFailed) return l10n.journalSyncFailed;
    if (_lastSyncedAt == null) return l10n.journalSyncNotYet;

    try {
      final formatted = DateFormat.yMMMd(l10n.localeName)
          .add_Hm()
          .format(_lastSyncedAt!.toLocal());
      return l10n.journalSyncLastSynced(formatted);
    } catch (_) {
      return l10n.journalSyncLastSynced(
        DateFormat('yyyy-MM-dd HH:mm').format(_lastSyncedAt!.toLocal()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SimplePage(
      title: l10n.journalCloudSync,
      fallbackRoute: '/profile/settings',
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.secondary100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.privacy_tip_outlined,
                        color: AppColors.secondary600,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          l10n.journalSyncDescription,
                          style: AppText.body.copyWith(
                            color: AppColors.grey800,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SwitchListTile.adaptive(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      l10n.journalCloudSync,
                      style: AppText.body.copyWith(
                        color: AppColors.grey900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _isEnabled
                            ? l10n.journalSyncEnabledDescription
                            : l10n.journalSyncDisabledDescription,
                        style: AppText.caption.copyWith(
                          color: AppColors.grey600,
                          height: 1.4,
                        ),
                      ),
                    ),
                    value: _isEnabled,
                    onChanged: _isBusy ? null : _onSyncChanged,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        _isEnabled
                            ? (_lastAttemptFailed
                                ? Icons.cloud_off_outlined
                                : Icons.cloud_done_outlined)
                            : Icons.smartphone,
                        color: _lastAttemptFailed
                            ? AppColors.error
                            : AppColors.grey700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _statusText(l10n),
                          style: AppText.body.copyWith(
                            color: AppColors.grey800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isBusy) ...[
                  const SizedBox(height: 14),
                  const LinearProgressIndicator(),
                ],
                if (_errorMessage != null) ...[
                  const SizedBox(height: 14),
                  _MessageCard(
                    text: _errorMessage!,
                    color: AppColors.error,
                    icon: Icons.error_outline,
                  ),
                ],
                if (_feedbackMessage != null) ...[
                  const SizedBox(height: 14),
                  _MessageCard(
                    text: _feedbackMessage!,
                    color: AppColors.success,
                    icon: Icons.check_circle_outline,
                  ),
                ],
                if (_isEnabled) ...[
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isBusy ? null : _syncNow,
                      icon: const Icon(Icons.sync_rounded),
                      label: Text(l10n.syncNow),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  l10n.journalCloudLegacyCopyNotice,
                  style: AppText.caption.copyWith(
                    color: AppColors.grey600,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _isBusy ? null : _deleteCloudCopy,
                    icon: const Icon(Icons.delete_outline_rounded),
                    label: Text(l10n.deleteCloudCopy),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.text,
    required this.color,
    required this.icon,
  });

  final String text;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppText.caption.copyWith(color: AppColors.grey800),
            ),
          ),
        ],
      ),
    );
  }
}
