import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:referral_test/src/data/providers.dart';

class MembershipScreen extends ConsumerWidget {
  const MembershipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Membership'),
        backgroundColor: Colors.white,
      ),
      body: userState.when(
        data: (user) {
          if (!user.isMember) {
            return _buildNonMemberView(context, ref);
          }
          return _buildMemberView(context, user.name, user.membershipLevel);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildNonMemberView(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(PhosphorIcons.crown, size: 80, color: Color(0xFFF09E38)),
          const SizedBox(height: 24),
          Text(
            'Join Jenosize Rewards',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 16),
          Text(
            'Unlock exclusive benefits, earn points, and get premium rewards by becoming a member today.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              ref.read(userProfileProvider.notifier).joinMembership();
            },
            child: const Text('Join Membership Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberView(BuildContext context, String name, String level) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildMembershipCard(context, name, level),
          const SizedBox(height: 32),
          Text(
            'Welcome, ${name.split(' ').first}!',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 24),
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 16),
              children: [
                const TextSpan(text: 'You are a '),
                TextSpan(
                  text: level,
                  style: const TextStyle(
                    color: Color(0xFFE5A91A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Your Benefits',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: 16),
          _buildBenefitItem(
            context,
            icon: PhosphorIcons.coin,
            iconColor: const Color(0xFFE5A91A),
            iconBg: const Color(0xFFFFF6E5),
            title: '2x Points on All Purchases',
            subtitle: 'Earn faster every time you shop',
          ),
          _buildBenefitItem(
            context,
            icon: PhosphorIcons.check,
            iconColor: const Color(0xFF14C699),
            iconBg: const Color(0xFFE5FAF4),
            title: 'Free Express Shipping',
            subtitle: 'Exclusive for Gold members',
          ),
          _buildBenefitItem(
            context,
            icon: PhosphorIcons.bell,
            iconColor: const Color(0xFF8A2BE2),
            iconBg: const Color(0xFFF3E5FA),
            title: 'Early Access Sales',
            subtitle: 'Be the first to shop new arrivals',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Join Premium Membership'),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Terms and conditions apply',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipCard(BuildContext context, String name, String level) {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFF4B63C), Color(0xFFD67300)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD67300).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'JENOSIZE REWARDS',
                    style: TextStyle(color: Colors.white70, letterSpacing: 1.5, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    level,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(PhosphorIcons.sparkle_fill, color: Colors.white, size: 24),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'CARD HOLDER',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(PhosphorIcons.qr_code, size: 36, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
