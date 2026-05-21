import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:peria_app/core/theme/theme.dart';
import 'package:peria_app/features/journal/data/models/journal_entry.dart';
import 'package:peria_app/features/journal/data/models/mood.dart';
import 'package:peria_app/features/journal/presentation/providers/journal_provider.dart';
import 'package:peria_app/shared/widgets/common_widgets.dart';

class JournalSearchScreen extends ConsumerStatefulWidget {
  const JournalSearchScreen({super.key});

  @override
  ConsumerState<JournalSearchScreen> createState() =>
      _JournalSearchScreenState();
}

class _JournalSearchScreenState extends ConsumerState<JournalSearchScreen> {
  final _searchController = TextEditingController();
  String _selectedMood = 'all';
  bool _onlyFavorites = false;
  DateTimeRange? _dateRange;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(journalProvider);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildFilterBar(),
              Expanded(
                child: entriesAsync.when(
                  data: (entries) {
                    final filtered = _filterEntries(entries);
                    if (filtered.isEmpty) {
                      return _buildEmptyState();
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) =>
                          _SearchResultCard(entry: filtered[index]),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text("Error: $e")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          BackIconButton(onPressed: () => context.go('/journal')),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 10)
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: const InputDecoration(
                  hintText: "Rechercher des notes...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: AppColors.grey400),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          _FilterChip(
            label: "All Moods",
            isSelected: _selectedMood == 'all',
            onSelected: () => _showMoodPicker(),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: "Favorites",
            isSelected: _onlyFavorites,
            onSelected: () => setState(() => _onlyFavorites = !_onlyFavorites),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: _getDateRangeLabel(),
            isSelected: _dateRange != null,
            onSelected: () => _selectDateRange(),
          ),
        ],
      ),
    );
  }

  String _getDateRangeLabel() {
    if (_dateRange == null) return "Date";
    final start = DateFormat('d MMM').format(_dateRange!.start);
    final end = DateFormat('d MMM').format(_dateRange!.end);
    return "$start - $end";
  }

  List<JournalEntry> _filterEntries(List<JournalEntry> entries) {
    final query = _searchController.text.toLowerCase();
    return entries.where((e) {
      final matchesQuery = e.title.toLowerCase().contains(query) ||
          e.content.toLowerCase().contains(query);
      final matchesMood = _selectedMood == 'all' || e.mood == _selectedMood;
      final matchesFavorite = !_onlyFavorites || e.isFavorite;
      final matchesDate = _dateRange == null ||
          (e.createdAt.isAfter(_dateRange!.start) &&
              e.createdAt
                  .isBefore(_dateRange!.end.add(const Duration(days: 1))));
      return matchesQuery && matchesMood && matchesFavorite && matchesDate;
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off_rounded,
              size: 64, color: AppColors.grey200),
          const SizedBox(height: 16),
          Text("No results found",
              style: AppText.h5.copyWith(color: AppColors.grey400)),
        ],
      ),
    );
  }

  Future<void> _showMoodPicker() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Filter by Mood", style: AppText.h4),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MoodPickerItem(
                    label: "All",
                    icon: Icons.bubble_chart_rounded,
                    isSelected: _selectedMood == 'all',
                    onTap: () => Navigator.pop(context, 'all')),
                ...Mood.all.map((m) => _MoodPickerItem(
                      label: m.label,
                      icon: m.icon,
                      isSelected: _selectedMood == m.id,
                      onTap: () => Navigator.pop(context, m.id),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
    if (result != null) setState(() => _selectedMood = result);
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      confirmText: "SELECT",
      saveText: "SAVE",
      helpText: "SELECT RANGE",
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary500,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AppColors.grey900,
            secondary: AppColors.primary500,
          ),
          dialogBackgroundColor: Colors.white,
          datePickerTheme: DatePickerThemeData(
            headerBackgroundColor: AppColors.primary500,
            headerForegroundColor: Colors.white,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            dayStyle: AppText.body,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary500,
              textStyle: AppText.label.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dateRange = picked);
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _FilterChip(
      {required this.label,
      required this.isSelected,
      required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.grey900 : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppColors.grey900 : AppColors.grey200),
        ),
        child: Text(
          label,
          style: AppText.label.copyWith(
              color: isSelected ? Colors.white : AppColors.grey700,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _MoodPickerItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodPickerItem(
      {required this.label,
      required this.icon,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary50 : AppColors.grey50,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.primary500, width: 2)
                  : null,
            ),
            child: Center(
                child: Icon(icon,
                    size: 28,
                    color:
                        isSelected ? AppColors.primary500 : AppColors.grey400)),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: AppText.caption.copyWith(
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final JournalEntry entry;
  const _SearchResultCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final mood = Mood.fromId(entry.mood);
    return GestureDetector(
      onTap: () => context.go('/journal/detail/${entry.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.grey100),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                  color: mood.color.withOpacity(0.3), shape: BoxShape.circle),
              child:
                  Center(child: Icon(mood.icon, color: mood.accent, size: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.title.isNotEmpty ? entry.title : "Untitled",
                    style: AppText.label.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DateFormat('d MMM • HH:mm').format(entry.createdAt),
                    style: AppText.caption.copyWith(color: AppColors.grey400),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.grey300),
          ],
        ),
      ),
    );
  }
}
