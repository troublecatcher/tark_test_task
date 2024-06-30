import 'package:json_annotation/json_annotation.dart';

part 'github_profile.g.dart';

@JsonSerializable(createToJson: false)
class GithubProfile {
  final String login;
  @JsonKey(name: 'avatar_url')
  final String avatarUrl;
  late final int? followers;
  late final int? following;

  GithubProfile({required this.login, required this.avatarUrl});

  factory GithubProfile.fromJson(Map<String, dynamic> json) =>
      _$GithubProfileFromJson(json);
}
