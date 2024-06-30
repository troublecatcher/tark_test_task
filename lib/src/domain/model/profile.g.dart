// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) => Profile(
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
    )
      ..followers = (json['followers'] as num?)?.toInt()
      ..following = (json['following'] as num?)?.toInt();
