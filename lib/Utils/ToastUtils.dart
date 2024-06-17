import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:delivery_radharani/Utils/Utils.dart';

class ToastUtils {
  static Timer toastTimer;
  static OverlayEntry _overlayEntry;

  static void showCustomToast(
      BuildContext context, String message, String type) {
    if (toastTimer == null || !toastTimer.isActive) {
      _overlayEntry = createOverlayEntry(context, message, type);
      Overlay.of(context).insert(_overlayEntry);
      toastTimer = Timer(Duration(seconds: 3), () {
        if (_overlayEntry != null) {
          _overlayEntry.remove();
        }
      });
    }
  }

  static OverlayEntry createOverlayEntry(
      BuildContext context, String message, String type) {
    return OverlayEntry(
      builder: (context) => Align(
        alignment: Alignment.topCenter,
        child: Container(
          margin: EdgeInsets.only(top: 75.0, left: 25.0, right: 25.0),
          padding:
              EdgeInsets.only(left: 10.0, right: 25.0, top: 7.0, bottom: 7.0),
          decoration: BoxDecoration(
              boxShadow: [Utils.boxShadow()],
              color: Color(
                  (type == 'warning') ? Utils.warning : Utils.accentColor),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                (type == 'warning') ? Icons.cancel : Icons.check_circle,
                color: Colors.white,
                size: 28.0,
              ),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  maxLines: null,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 12,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
