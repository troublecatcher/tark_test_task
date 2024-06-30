import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable(createToJson: false)
class Profile {
  final String login;
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;
  late final int? followers;
  late final int? following;

  Profile({required this.login, required this.avatarUrl});

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
