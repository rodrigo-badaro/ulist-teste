import 'package:bloc/bloc.dart';

class AnimatedButtonCubit extends Cubit<bool> {
  AnimatedButtonCubit() : super(false);

  void animate({required bool loading}) => emit(loading);
}
