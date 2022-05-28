import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:projeto_sti/components/popupMessage.dart';


bool hasInternet(BuildContext context, ConnectivityResult connectivity) {
    if (connectivity == ConnectivityResult.none) {
      showPopupMessage(
          context,
          "error",
          "Oops! No Internet connection!\nCheck your internet settings!",
          false);
      return false;
    }
    return true;
  }