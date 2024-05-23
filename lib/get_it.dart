// ignore: depend_on_referenced_packages
import 'package:get_it/get_it.dart';
import 'package:ulist/screens/listas/bloc/listas_bloc.dart';
import 'package:ulist/widgets/modal/modal_listener.dart';

GetIt getIt = GetIt.instance;

setupProviders() {
  getIt.registerLazySingleton<ModalListener>(() => ModalListener());
  getIt.registerLazySingleton<ListasBloc>(() => ListasBloc());
}

resetProviders() async {
  getIt.resetLazySingleton<ModalListener>();
  getIt.resetLazySingleton<ListasBloc>();
}
