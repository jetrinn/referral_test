import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:referral_test/src/data/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('userProfileProvider successfully joins membership', () async {
    // Arrange
    SharedPreferences.setMockInitialValues({'is_member': false});
    final prefs = await SharedPreferences.getInstance();

    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );

    // Initial state is loading
    expect(container.read(userProfileProvider).isLoading, true);

    // Wait for the async load to complete
    await Future.delayed(const Duration(milliseconds: 600));

    // Check initial state after load
    final initialUserState = container.read(userProfileProvider).value;
    expect(initialUserState, isNotNull);
    expect(initialUserState!.isMember, false);
    expect(initialUserState.membershipLevel, 'Guest');

    // Act - Join membership
    await container.read(userProfileProvider.notifier).joinMembership();

    // Assert
    final updatedUserState = container.read(userProfileProvider).value;
    expect(updatedUserState, isNotNull);
    expect(updatedUserState!.isMember, true);
    expect(updatedUserState.membershipLevel, 'Gold Member');
    expect(prefs.getBool('is_member'), true);
  });
}
