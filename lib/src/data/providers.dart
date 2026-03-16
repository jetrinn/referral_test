import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:referral_test/src/data/mock_loyalty_repository.dart';
import 'package:referral_test/src/domain/campaign.dart';
import 'package:referral_test/src/domain/user.dart';
import 'package:referral_test/src/domain/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

final loyaltyRepositoryProvider = Provider<MockLoyaltyRepository>((ref) {
  return MockLoyaltyRepository();
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile>>((ref) {
  final repo = ref.watch(loyaltyRepositoryProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return UserProfileNotifier(repo, prefs);
});

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile>> {
  final MockLoyaltyRepository repo;
  final SharedPreferences prefs;

  UserProfileNotifier(this.repo, this.prefs) : super(const AsyncValue.loading()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await repo.getUserProfile();
      final isMember = prefs.getBool('is_member') ?? false;
      final savedPoints = prefs.getInt('user_points');
      state = AsyncValue.data(user.copyWith(
        isMember: isMember, 
        membershipLevel: isMember ? 'Gold Member' : 'Guest',
        points: savedPoints ?? user.points,
      ));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> joinMembership() async {
    state = const AsyncValue.loading();
    try {
      final user = await repo.joinMembership();
      await prefs.setBool('is_member', true);
      state = AsyncValue.data(user.copyWith(isMember: true));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addPoints(int pointsToAdd) {
    state.whenData((currentUser) {
      final newPoints = currentUser.points + pointsToAdd;
      prefs.setInt('user_points', newPoints);
      state = AsyncValue.data(currentUser.copyWith(points: newPoints));
    });
  }
}

// Add search query state
final searchQueryProvider = StateProvider<String>((ref) => '');

// Manage joined campaigns via SharedPreferences
final joinedCampaignsProvider = StateNotifierProvider<JoinedCampaignsNotifier, List<String>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return JoinedCampaignsNotifier(prefs);
});

class JoinedCampaignsNotifier extends StateNotifier<List<String>> {
  final SharedPreferences prefs;
  static const _key = 'joined_campaigns';

  JoinedCampaignsNotifier(this.prefs) : super(prefs.getStringList(_key) ?? []);

  void joinCampaign(String campaignId) {
    if (!state.contains(campaignId)) {
      state = [...state, campaignId];
      prefs.setStringList(_key, state);
    }
  }
}

// Update campaigns provider to filter by search query and exclude joined campaigns
final campaignsProvider = FutureProvider<List<Campaign>>((ref) async {
  final repo = ref.watch(loyaltyRepositoryProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  final joinedIds = ref.watch(joinedCampaignsProvider);
  
  final allCampaigns = await repo.getCampaigns();
  
  return allCampaigns.where((c) {
    bool matchesSearch = c.title.toLowerCase().contains(query) || c.description.toLowerCase().contains(query);
    bool notJoined = !joinedIds.contains(c.id);
    return matchesSearch && notJoined;
  }).toList();
});

// Update transactions provider to save/load from SharedPreferences
final transactionsProvider = StateNotifierProvider<TransactionsNotifier, AsyncValue<List<PointTransaction>>>((ref) {
  final repo = ref.watch(loyaltyRepositoryProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return TransactionsNotifier(repo, prefs);
});

class TransactionsNotifier extends StateNotifier<AsyncValue<List<PointTransaction>>> {
  final MockLoyaltyRepository repo;
  final SharedPreferences prefs;
  static const _key = 'transactions_history';

  TransactionsNotifier(this.repo, this.prefs) : super(const AsyncValue.loading()) {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final jsonString = prefs.getString(_key);
      if (jsonString != null) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        final transactions = jsonList.map((json) => PointTransaction.fromJson(json)).toList();
        state = AsyncValue.data(transactions);
      } else {
        // Fallback to initial mock data and save it
        final initial = await repo.getTransactions();
        _saveToPrefs(initial);
        state = AsyncValue.data(initial);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void addTransaction(PointTransaction transaction) {
    state.whenData((transactions) {
      final updated = [transaction, ...transactions];
      _saveToPrefs(updated);
      state = AsyncValue.data(updated);
    });
  }

  void _saveToPrefs(List<PointTransaction> transactions) {
    final jsonString = jsonEncode(transactions.map((t) => t.toJson()).toList());
    prefs.setString(_key, jsonString);
  }
}
