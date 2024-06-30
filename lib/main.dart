import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tark_test_task/src/data/remote_repository.dart';
import 'package:tark_test_task/src/domain/state_management/user_details/user_details_cubit.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_bloc.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_event.dart';
import 'package:tark_test_task/src/presentation/view/screen/home_screen.dart';
import 'package:tark_test_task/src/presentation/control/query_cubit.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final RemoteRepository repository =
        RemoteRepository(authToken: dotenv.env['key']);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UsersBloc(repository: repository)
              ..add(FetchUsers(since: 0, perPage: 100)),
          ),
          BlocProvider(
            create: (context) => UserDetailsCubit(
              remoteRepository: repository,
              usersBloc: context.read<UsersBloc>(),
            ),
          ),
          BlocProvider(
            create: (context) => QueryCubit(),
          ),
        ],
        child: const HomeScreen(),
      ),
    );
  }
}
