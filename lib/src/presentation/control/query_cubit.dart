import 'package:bloc/bloc.dart';

class QueryCubit extends Cubit<String> {
  QueryCubit() : super('');
  set(String query) => emit(query);
  reset() => emit('');
}
