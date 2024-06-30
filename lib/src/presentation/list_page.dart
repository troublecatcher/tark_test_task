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
  final List<GithubProfile> allUsers;
  const ListPage({super.key, required this.pattern, required this.allUsers});

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
    super.build(context);
    return Scrollbar(
      controller: _scrollController,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= filteredUsers.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final user = filteredUsers[index];
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
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
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
                      : Text(
                          '${user.followers} followers / ${user.following} following'),
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
