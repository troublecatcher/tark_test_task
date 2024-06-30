import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tark_test_task/src/domain/bloc/github_bloc.dart';
import 'package:tark_test_task/src/domain/bloc/github_event.dart';
import 'package:tark_test_task/src/domain/bloc/github_state.dart';
import 'package:tark_test_task/src/presentation/list_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context
          .read<GithubUserBloc>()
          .add(LoadMoreGithubUsers(pattern: ListPattern.ah));
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
    return DefaultTabController(
      length: ListPattern.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Github Users'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search),
            ),
          ],
          bottom: TabBar(
            tabs: ListPattern.values.map((e) => Tab(text: e.pattern)).toList(),
          ),
        ),
        body: BlocBuilder<GithubUserBloc, GithubUserState>(
          builder: (context, state) {
            if (state is GithubUserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GithubUserLoaded) {
              return TabBarView(
                children: List.generate(
                  ListPattern.values.length,
                  (index) => ListPage(
                    key: ValueKey(index),
                    pattern: ListPattern.values[index],
                    allUsers: state.users,
                  ),
                ),
              );
            } else if (state is GithubUserError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const Center(child: Text('Select a range to fetch users'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context
              .read<GithubUserBloc>()
              .add(LoadMoreGithubUsers(pattern: ListPattern.ah)),
          child: const Icon(Icons.save_alt_sharp),
        ),
      ),
    );
  }
}
