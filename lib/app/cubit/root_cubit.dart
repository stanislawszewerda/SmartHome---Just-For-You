import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'root_state.dart';

class RootCubit extends Cubit<RootState> {
  RootCubit()
      : super(
          const RootState(user: null, isLoading: false, errorMessage: ''),
        );

  // StreamSubscription? _streamSubscription;

  Future<void> start() async {
    emit(const RootState(user: null, isLoading: true, errorMessage: ''));

    //_streamSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      emit(const RootState(user: null, isLoading: false, errorMessage: ''));
    });
  }
}
