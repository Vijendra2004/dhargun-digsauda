import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:adaniwilmar/authentication/authentication.dart';
import 'package:adaniwilmar/repo/user_repository.dart';
import 'package:adaniwilmar/utils/constant.dart';
import 'package:flutter/foundation.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationUninitialized()) {
    on<CheckLoggedIn>((event, emit) => _getLoggedIn(emit));
  }

  AuthenticationState get initialState => AuthenticationUninitialized();

  Future<void> _getLoggedIn(Emitter<AuthenticationState> emit) async {
    try {
      UserRepository userRepository = UserRepository();
      await userRepository.getUserDetail();
      if (Constants.AUTH_TOKEN == "") {
        emit(const CheckLoggedInState(loggedIn: false));
      } else {
        emit(const CheckLoggedInState(loggedIn: true));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
