import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tark_test_task/src/domain/state_management/user_details/user_details_cubit.dart';
import 'package:tark_test_task/src/domain/state_management/user_details/user_details_state.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_bloc.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_state.dart';
import 'package:tark_test_task/src/presentation/control/list_pattern.dart';
import 'package:tark_test_task/src/presentation/control/query_cubit.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BlocBuilder<UserDetailsCubit, UserDetailsState>(
        builder: (context, userDetailsState) {
          return BlocBuilder<UsersBloc, UsersState>(
            builder: (context, usersState) {
              if (active) {
                return TextField(
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) => context.read<QueryCubit>().set(value),
                );
              } else {
                return AnimatedSwitcher(
                  duration: Durations.medium1,
                  child: usersState is UsersLoading
                      ? const Text('Loading users...')
                      : const Text('Github Users'),
                );
              }
            },
          );
        },
      ),
      centerTitle: true,
      actions: [
        active
            ? IconButton(
                onPressed: () => setState(() {
                  active = false;
                  context.read<QueryCubit>().reset();
                }),
                icon: const Icon(Icons.close),
              )
            : IconButton(
                onPressed: () => setState(() => active = true),
                icon: const Icon(Icons.search),
              )
      ],
      bottom: TabBar(
        tabs: ListPattern.patterns
            .map((e) => Tab(text: '${e.from}-${e.to}'))
            .toList(),
      ),
    );
  }
}
