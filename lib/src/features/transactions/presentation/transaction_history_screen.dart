import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:referral_test/src/data/providers.dart';
import 'package:referral_test/src/domain/transaction.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';

enum TransactionSortOption { newest, oldest, highPoints, lowPoints }

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  TransactionSortOption _selectedSort = TransactionSortOption.newest;
  DateTimeRange? _selectedDateRange;

  List<PointTransaction> _applyFilters(List<PointTransaction> transactions) {
    var filtered = List<PointTransaction>.from(transactions);

    // Filter by date range
    if (_selectedDateRange != null) {
      filtered = filtered.where((t) {
        return t.date.isAfter(
              _selectedDateRange!.start.subtract(const Duration(seconds: 1)),
            ) &&
            t.date.isBefore(
              _selectedDateRange!.end.add(const Duration(days: 1)),
            );
      }).toList();
    }

    // Sort
    switch (_selectedSort) {
      case TransactionSortOption.newest:
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case TransactionSortOption.oldest:
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case TransactionSortOption.highPoints:
        filtered.sort((a, b) => b.points.compareTo(a.points));
        break;
      case TransactionSortOption.lowPoints:
        filtered.sort((a, b) => a.points.compareTo(b.points));
        break;
    }

    return filtered;
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF14C699),
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDateRange = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionsState = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          _buildFilterBar(context),
          const Divider(height: 1),
          Expanded(
            child: transactionsState.when(
              data: (transactions) {
                final filtered = _applyFilters(transactions);
                if (filtered.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          PhosphorIcons.receipt,
                          size: 48,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No transactions found',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  color: const Color(0xFF14C699),
                  onRefresh: () async {
                    ref.invalidate(transactionsProvider);
                    await Future.delayed(const Duration(milliseconds: 800));
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) =>
                        _buildTransactionItem(context, filtered[index]),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) =>
                  Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sort chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _sortChip('Newest', TransactionSortOption.newest,
                    PhosphorIcons.sort_descending),
                const SizedBox(width: 8),
                _sortChip('Oldest', TransactionSortOption.oldest,
                    PhosphorIcons.sort_ascending),
                const SizedBox(width: 8),
                _sortChip('High Points', TransactionSortOption.highPoints,
                    PhosphorIcons.arrow_up),
                const SizedBox(width: 8),
                _sortChip('Low Points', TransactionSortOption.lowPoints,
                    PhosphorIcons.arrow_down),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Date range row
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _pickDateRange,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: _selectedDateRange != null
                          ? const Color(0xFFE5FAF4)
                          : const Color(0xFFF5F6F8),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _selectedDateRange != null
                            ? const Color(0xFF14C699)
                            : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          PhosphorIcons.calendar,
                          size: 18,
                          color: _selectedDateRange != null
                              ? const Color(0xFF14C699)
                              : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedDateRange == null
                              ? 'Filter by date range'
                              : '${DateFormat('MMM d').format(_selectedDateRange!.start)} – ${DateFormat('MMM d, yyyy').format(_selectedDateRange!.end)}',
                          style: TextStyle(
                            color: _selectedDateRange != null
                                ? const Color(0xFF14C699)
                                : Colors.grey,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_selectedDateRange != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _selectedDateRange = null),
                  child: const CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xFFF5F6F8),
                    child: Icon(PhosphorIcons.x, size: 14, color: Colors.grey),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _sortChip(
      String label, TransactionSortOption option, IconData icon) {
    final isSelected = _selectedSort == option;
    return GestureDetector(
      onTap: () => setState(() => _selectedSort = option),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF14C699)
              : const Color(0xFFF5F6F8),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 14,
                color: isSelected ? Colors.white : Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
      BuildContext context, PointTransaction transaction) {
    IconData icon;
    if (transaction.title.contains('Referral')) {
      icon = PhosphorIcons.user_plus;
    } else if (transaction.title.contains('Joined') ||
        transaction.title.contains('Campaign')) {
      icon = PhosphorIcons.megaphone;
    } else {
      icon = PhosphorIcons.check_circle;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFE5FAF4),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF14C699), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM d, yyyy • hh:mm a').format(transaction.date),
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Text(
            '+${transaction.points} pts',
            style: const TextStyle(
              color: Color(0xFF14C699),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
