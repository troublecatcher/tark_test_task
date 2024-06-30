import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tark_test_task/src/domain/bloc/github_bloc.dart';
import 'package:tark_test_task/src/domain/bloc/github_event.dart';
import 'package:tark_test_task/src/domain/bloc/github_state.dart';
import 'package:tark_test_task/src/domain/model/github_profile.dart';

class ListPage extends StatefulWidget {
  final ListPattern pattern;
  const ListPage({super.key, required this.pattern});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage>
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
        context
            .read<GithubUserBloc>()
            .add(LoadMoreGithubUsers(pattern: widget.pattern));
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
    return BlocBuilder<GithubUserBloc, GithubUserState>(
      builder: (context, state) {
        if (state is GithubUserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GithubUserLoaded) {
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
          final sortedUsers = state.filteredUsers.values
              .where((user) => regex.hasMatch(user.login[0]))
              .toList();

          _isLoadingMore = state.isLoadingMore;

          return Scrollbar(
            controller: _scrollController,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: sortedUsers.length + (state.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= sortedUsers.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                final user = sortedUsers[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: sortedUsers[index].avatarUrl,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  title: Text(user.login),
                  subtitle: user.followers == null || user.following == null
                      ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            width: 100,
                            height: 16,
                            color: Colors.grey[300],
                          ),
                        )
                      : Text('${user.followers}/${user.following}'),
                );
              },
            ),
          );
        } else if (state is GithubUserError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('Select a range to fetch users'));
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
