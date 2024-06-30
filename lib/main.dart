import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tark_test_task/src/data/repository.dart';
import 'package:tark_test_task/src/data/repository_impl.dart';
import 'package:tark_test_task/src/domain/state_management/user_details/user_details_bloc.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_bloc.dart';
import 'package:tark_test_task/src/domain/state_management/users/users_event.dart';
import 'package:tark_test_task/src/presentation/home_screen.dart';
import 'package:tark_test_task/src/presentation/list_pattern.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final Repository repository = RepositoryImpl(authToken: dotenv.env['key']!);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UsersBloc(repository: repository)
              ..add(FetchUsers(pattern: ListPattern.ah)),
          ),
          BlocProvider(
            create: (context) => UserDetailsCubit(
              repository: repository,
              usersBloc: context.read<UsersBloc>(),
            ),
          ),
        ],
        child: const HomeScreen(),
      ),
    );
  }
}
