import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_bloc.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_event.dart';
import 'package:tark_test_task/src/domain/state_management/user_details/user_details_cubit.dart';
import 'package:tark_test_task/src/domain/model/profile.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_state.dart';
import 'package:tark_test_task/src/presentation/control/list_pattern.dart';
import 'package:tark_test_task/src/presentation/control/query_cubit.dart';
import 'package:tark_test_task/src/presentation/view/widget/error_user_image.dart';
import 'package:tark_test_task/src/presentation/view/widget/user_image_placeholder.dart';
import 'package:tark_test_task/src/presentation/view/widget/user_subtitle_placeholder.dart';

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
        context.read<UsersBloc>().add(LoadMoreUsers(perPage: 100));
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
    final RegExp regExp = RegExp(
      '^[${widget.pattern.from}-${widget.pattern.to}]',
      caseSensitive: false,
    );
    final filteredUsers = widget.allUsers
        .where((user) => regExp.hasMatch(user.login[0]))
        .toList();
    return BlocListener<UsersBloc, UsersState>(
      listener: (context, state) {
        if (state is UsersLoaded || state is UsersError) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      },
      child: Scrollbar(
        controller: _scrollController,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, index) {
                  if (index >= filteredUsers.length) {
                    return BlocBuilder<QueryCubit, String>(
                      builder: (context, state) {
                        if (state.isNotEmpty) {
                          return const SizedBox.shrink();
                        }
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                    );
                  }
                  final user = filteredUsers[index];
                  if (user.followers == null) {
                    context
                        .read<UserDetailsCubit>()
                        .fetchUserDetails(user.login);
                  }
                  return ListTile(
                    key: ValueKey(user.login),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        imageUrl: user.avatarUrl,
                        width: 50,
                        height: 50,
                        placeholder: (context, url) =>
                            const UserImagePlaceholder(),
                        errorWidget: (context, url, error) =>
                            const ErrorUserImage(),
                      ),
                    ),
                    title: Text(user.login),
                    subtitle: user.followers != null
                        ? Text(
                            '${user.followers} followers / ${user.following} following')
                        : const UserSubtitlePlaceholder(),
                  );
                },
                childCount: filteredUsers.length + 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
