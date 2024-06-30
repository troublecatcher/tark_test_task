// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GithubProfile _$GithubProfileFromJson(Map<String, dynamic> json) =>
    GithubProfile(
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
    )
      ..followers = (json['followers'] as num?)?.toInt()
      ..following = (json['following'] as num?)?.toInt();
