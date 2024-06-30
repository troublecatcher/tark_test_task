import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tark_test_task/src/domain/model/profile.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_bloc.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_state.dart';
import 'package:tark_test_task/src/presentation/control/query_cubit.dart';
import 'package:tark_test_task/src/presentation/view/layout/custom_app_bar.dart';
import 'package:tark_test_task/src/presentation/view/layout/user_list.dart';
import 'package:tark_test_task/src/presentation/control/list_pattern.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ListPattern.patterns.length,
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: BlocBuilder<UsersBloc, UsersState>(
          builder: (context, state) {
            switch (state) {
              case UsersInitial _:
                return const SizedBox.shrink();
              case UsersLoading _:
                return const Center(child: CircularProgressIndicator());

              case UsersLoaded _:
                return TabBarView(
                  children: List.generate(
                    ListPattern.patterns.length,
                    (index) => BlocBuilder<QueryCubit, String>(
                      builder: (context, query) {
                        List<Profile> users = state.users;
                        if (query.isNotEmpty) {
                          users = users
                              .where((user) => user.login.contains(query))
                              .toList();
                        }
                        return UserList(
                          pattern: ListPattern.patterns[index],
                          allUsers: users,
                        );
                      },
                    ),
                  ),
                );
              case UsersError _:
                return Center(child: Text('Error: ${state.message}'));
            }
          },
        ),
      ),
    );
  }
}
