import 'package:referral_test/src/domain/campaign.dart';
import 'package:referral_test/src/domain/user.dart';
import 'package:referral_test/src/domain/transaction.dart';

class MockLoyaltyRepository {
  UserProfile _currentUser = const UserProfile(
    id: 'user_123',
    name: 'Alex Thompson',
    referralCode: 'JEN0123',
    points: 1250,
    isMember: false,
  );

  final List<PointTransaction> _transactions = [
    PointTransaction(
      id: 'tx_1',
      title: 'Referral',
      date: DateTime.now().subtract(const Duration(days: 1)),
      points: 100,
    ),
    PointTransaction(
      id: 'tx_2',
      title: 'Joined Campaign',
      date: DateTime.now().subtract(const Duration(days: 2)),
      points: 50,
    ),
    PointTransaction(
      id: 'tx_3',
      title: 'Daily Check-in',
      date: DateTime.now().subtract(const Duration(days: 3)),
      points: 10,
    ),
  ];

  final List<Campaign> _campaigns = const [
    Campaign(
      id: 'c1',
      title: 'Morning Ritual Rewards',
      description:
          'Start your day right. Earn double points on all specialty coffee purchases until noon.',
      imageUrl:
          'https://images.unsplash.com/photo-1541167760496-1628856ab772?q=80&w=800&auto=format&fit=crop',
      tag: 'LIMITED TIME',
      ctaText: 'Join Now',
    ),
    Campaign(
      id: 'c2',
      title: 'Tech Upgrade 2024',
      description:
          'Redeem your accumulated points for the latest smart devices and wearables.',
      imageUrl:
          'https://images.unsplash.com/photo-1526406915894-7bcd65f60845?q=80&w=800&auto=format&fit=crop',
      tag: 'PREMIUM',
      ctaText: 'Join Now',
    ),
    Campaign(
      id: 'c3',
      title: 'Summer Rewards Escape',
      description:
          'Book your dream vacation and earn up to 5,000 bonus points on hotel stays.',
      imageUrl:
          'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?q=80&w=800&auto=format&fit=crop',
      tag: 'HOT DEAL',
      ctaText: 'Join Now',
    ),
    Campaign(
      id: 'c4',
      title: 'Fitness Milestones',
      description:
          'Connect your health app and earn points for every kilometer you run this month.',
      imageUrl:
          'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=800&auto=format&fit=crop',
      tag: 'HEALTH',
      ctaText: 'Join Now',
    ),
    Campaign(
      id: 'c9',
      title: 'Fitness Milestones',
      description:
          'Connect your health app and earn points for every kilometer you run this month.',
      imageUrl:
          'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=800&auto=format&fit=crop',
      tag: 'HEALTH',
      ctaText: 'Join Now',
    ),
    Campaign(
      id: 'c8',
      title: 'Fitness Milestones',
      description:
          'Connect your health app and earn points for every kilometer you run this month.',
      imageUrl:
          'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=800&auto=format&fit=crop',
      tag: 'HEALTH',
      ctaText: 'Join Now',
    ),
    Campaign(
      id: 'c5',
      title: 'Fitness Milestones',
      description:
          'Connect your health app and earn points for every kilometer you run this month.',
      imageUrl:
          'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=800&auto=format&fit=crop',
      tag: 'HEALTH',
      ctaText: 'Join Now',
    ),
  ];

  Future<List<Campaign>> getCampaigns() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return _campaigns;
  }

  Future<UserProfile> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _currentUser;
  }

  Future<List<PointTransaction>> getTransactions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _transactions;
  }

  Future<UserProfile> joinMembership() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _currentUser = _currentUser.copyWith(
      isMember: true,
      membershipLevel: 'Gold Member',
    );
    return _currentUser;
  }
}
