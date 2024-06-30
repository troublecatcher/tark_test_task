import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tark_test_task/src/domain/bloc/github_bloc.dart';
import 'package:tark_test_task/src/domain/bloc/github_event.dart';
import 'package:tark_test_task/src/presentation/list_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context
        .read<GithubUserBloc>()
        .add(FetchGithubUsers(pattern: ListPattern.ah));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return DefaultTabController(
  //     length: 3,
  //     child: Scaffold(
  //       appBar: AppBar(
  //         actions: [
  //           IconButton(
  //             onPressed: () {},
  //             icon: const Icon(Icons.search),
  //           ),
  //         ],
  //         bottom: TabBar(
  //           tabs: ListPattern.values.map((e) => Tab(text: e.pattern)).toList(),
  //         ),
  //       ),
  //       body: TabBarView(
  //         children: List.generate(
  //           ListPattern.values.length,
  //           (index) => ListPage(pattern: ListPattern.values[index]),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: ListPage(pattern: ListPattern.values.first),
    );
  }
}
