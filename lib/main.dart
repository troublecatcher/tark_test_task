import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tark_test_task/src/data/github_repository.dart';
import 'package:tark_test_task/src/data/github_repository_impl.dart';
import 'package:tark_test_task/src/domain/bloc/github_bloc.dart';
import 'package:tark_test_task/src/presentation/home_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GithubRepository githubRepository =
        GithubRepositoryImpl(authToken: dotenv.env['key']!);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => GithubUserBloc(githubRepository: githubRepository),
        child: const HomeScreen(),
      ),
    );
  }
}
