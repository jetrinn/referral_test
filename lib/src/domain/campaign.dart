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

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      tag: json['tag'],
      ctaText: json['ctaText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'tag': tag,
      'ctaText': ctaText,
    };
  }

  @override
  List<Object?> get props => [id, title, description, imageUrl, tag, ctaText];
}
