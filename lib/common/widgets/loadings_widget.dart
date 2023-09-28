import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _Constants {
  static final double loadingSize = 60.h;
}

class LoadingWidget extends StatelessWidget {
  final double? size;

  const LoadingWidget({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size ?? _Constants.loadingSize,
      height: size ?? _Constants.loadingSize,
      alignment: Alignment.center,
      child: Platform.isIOS
          ? const CupertinoActivityIndicator()
          : const CircularProgressIndicator(),
    );
  }
}
