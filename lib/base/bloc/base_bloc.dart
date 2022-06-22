import 'package:base_bloc_3/common/local_data/shared_pref.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_bloc_state.dart';

abstract class BaseBloc<E, S extends BaseBlocState> extends Bloc<E, S> {
  BaseBloc(super.initialState);
  final localPref = getIt<LocalStorage>();
  // final connectivity = Connectivity().onConnectivityChanged;

}
