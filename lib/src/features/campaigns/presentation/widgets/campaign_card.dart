import 'package:flutter/material.dart';
import 'package:referral_test/src/domain/campaign.dart';

class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback onJoin;

  const CampaignCard({
    super.key,
    required this.campaign,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Image.network(
                campaign.imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.image_not_supported, color: Colors.grey, size: 40)),
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    campaign.tag,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  campaign.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  campaign.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onJoin,
                    child: Text(campaign.ctaText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
