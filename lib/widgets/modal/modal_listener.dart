import 'package:bloc/bloc.dart';

class ModalListener extends Cubit<int> {
  ModalListener() : super(0);

  void isOpen({required int instances}) => emit(instances);
}
