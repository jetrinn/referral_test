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

final campaignsProvider = FutureProvider<List<Campaign>>((ref) async {
  final repo = ref.watch(loyaltyRepositoryProvider);
  return repo.getCampaigns();
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
      state = AsyncValue.data(user.copyWith(isMember: isMember, membershipLevel: isMember ? 'Gold Member' : 'Guest'));
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
}

final transactionsProvider = FutureProvider<List<PointTransaction>>((ref) async {
  final repo = ref.watch(loyaltyRepositoryProvider);
  return repo.getTransactions();
});
