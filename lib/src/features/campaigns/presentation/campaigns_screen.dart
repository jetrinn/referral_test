import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:referral_test/src/data/providers.dart';
import 'package:referral_test/src/features/campaigns/presentation/widgets/campaign_card.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

class CampaignsScreen extends ConsumerWidget {
  const CampaignsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaignsAsyncValue = ref.watch(campaignsProvider);
    final userProfileAsyncValue = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(campaignsProvider);
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome back,',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              userProfileAsyncValue.when(
                                data: (user) => Text(
                                  user.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
                                ),
                                loading: () => const SizedBox(
                                  height: 26,
                                  width: 150,
                                  child: LinearProgressIndicator(color: Color(0xFFE0E0E0)),
                                ),
                                error: (_, __) => Text(
                                  'Guest',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 22),
                                ),
                              ),
                            ],
                          ),
                          const CircleAvatar(
                            backgroundColor: Color(0xFF14C699),
                            foregroundColor: Colors.white,
                            radius: 20,
                            child: Text('AJ', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            icon: Icon(PhosphorIcons.magnifying_glass, color: Colors.grey),
                            border: InputBorder.none,
                            hintText: 'Search rewards or campaigns...',
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Active Campaigns',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18),
                          ),
                          Text(
                            'View All',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              campaignsAsyncValue.when(
                data: (campaigns) {
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return CampaignCard(
                            campaign: campaigns[index],
                            onJoin: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Joined ${campaigns[index].title}')),
                              );
                            },
                          );
                        },
                        childCount: campaigns.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => SliverFillRemaining(
                  child: Center(child: Text('Error: $error')),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }
}
