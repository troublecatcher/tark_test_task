import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_bloc.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_event.dart';
import 'package:tark_test_task/src/domain/state_management/user_details/user_details_bloc.dart';
import 'package:tark_test_task/src/domain/state_management/user_details/user_details_event.dart';
import 'package:tark_test_task/src/domain/model/profile.dart';
import 'package:tark_test_task/src/presentation/list_pattern.dart';

class UserList extends StatefulWidget {
  final ListPattern pattern;
  final List<Profile> allUsers;
  const UserList({super.key, required this.pattern, required this.allUsers});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore) {
        _isLoadingMore = true;
        context.read<UsersBloc>().add(LoadMoreUsers(pattern: widget.pattern));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    late RegExp regex;
    switch (widget.pattern) {
      case ListPattern.ah:
        regex = RegExp(r'^[A-H]', caseSensitive: false);
        break;
      case ListPattern.ip:
        regex = RegExp(r'^[I-P]', caseSensitive: false);
        break;
      case ListPattern.qz:
        regex = RegExp(r'^[Q-Z]', caseSensitive: false);
        break;
    }

    final filteredUsers =
        widget.allUsers.where((user) => regex.hasMatch(user.login[0])).toList();

    return Scrollbar(
      controller: _scrollController,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, index) {
                if (index >= filteredUsers.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final user = filteredUsers[index];
                if (user.followers == null) {
                  context
                      .read<UserDetailsCubit>()
                      .add(FetchUserDetails(username: user.login));
                }
                return ListTile(
                  key: ValueKey<String>(user.login),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: user.avatarUrl,
                      width: 50,
                      height: 50,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[300],
                        ),
                      ),
                      errorWidget: (context, url, error) => CachedNetworkImage(
                        imageUrl: 'https://source.unsplash.com/random/50x50',
                        placeholder: (context, url) => Container(
                          width: 50,
                          height: 50,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                  title: Text(user.login),
                  subtitle: user.followers != null
                      ? Text(
                          '${user.followers} followers / ${user.following} following')
                      : Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 100,
                            height: 16,
                            color: Colors.grey[300],
                          ),
                        ),
                );
              },
              childCount: filteredUsers.length + 1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
