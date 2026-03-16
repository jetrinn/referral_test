import 'package:equatable/equatable.dart';

class Campaign extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String tag;
  final String ctaText;

  const Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.tag,
    required this.ctaText,
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl, tag, ctaText];
}
