import 'package:base_bloc_3/common/utils/snack_bar/snack_bar_helper.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/index.dart';

abstract class BaseState<W extends StatefulWidget, E, S extends BaseBlocState,
    B extends BaseBloc<E, S>> extends State<W> {
  late B bloc;

  @override
  void initState() {
    bloc = getIt<B>();
    /*
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      if (!mounted) return;
      context.pushNamed(
        Routes.forgotPasswordDynamicLink,
        params: {
          RouterParamConstants.deepLink: dynamicLinkData.link.toString()
        },
      );
    }).onError((error) {
      //DO NOTHING
      injector<LogUtils>().logD(error.toString());
    });
    */
    super.initState();
  }

  void showMessage(String message, {type = SnackBarType.success}) {
    final SnackBarHelper helper = getIt<SnackBarHelper>();
    switch (type) {
      case SnackBarType.error:
        helper.showError(context, message);
        break;
      case SnackBarType.info:
        helper.showInfo(context, message);
        break;
      default:
        helper.showSuccess(context, message);
        break;
    }
  }

  @required
  Widget renderUI(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: BlocListener<B, S>(
        listenWhen: (S previous, S current) {
          return previous != current || previous.message != current.message;
        },
        listener: (BuildContext context, S state) {
          if (state.status == BaseStateStatus.failed) {
            showMessage(state.message ?? "");
          }
        },
        child: renderUI(context),
      ),
    );
  }
}
