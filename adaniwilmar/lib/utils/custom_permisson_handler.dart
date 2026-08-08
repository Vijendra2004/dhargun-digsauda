import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: constant_identifier_names
enum Permissions { PHONE, STORAGE, LOCATION, CAMERA }

class CustomPermissionHandler {
  CustomPermissionHandler();

  final PermissionStatus _permissionStatus = PermissionStatus.restricted;

  Future<bool> getPermissionStatus(which) async {
    switch (which) {
      case Permissions.PHONE:
        return await checkServiceStatus(Permission.phone);
      case Permissions.STORAGE:
        return await checkServiceStatus(Permission.storage);
      case Permissions.LOCATION:
        return await checkServiceStatus(Permission.location);
    }
    return false;
  }

  Future<bool> checkServiceStatus(Permission _permissionGroup) async {
    bool rstatus = false;
    PermissionStatus status = await _permissionGroup.request();
    if (status == PermissionStatus.granted) {
      rstatus = true;
    } else if (status == PermissionStatus.denied) {
      rstatus = false;
    } else if (status == PermissionStatus.permanentlyDenied) {
      rstatus = false;
    }

    // _permissionGroup.re
    //     .then((ServiceStatus serviceStatus) {
    //   final SnackBar snackBar =
    //       SnackBar(content: Text(serviceStatus.toString()));
    //   Scaffold.of(_context).showSnackBar(snackBar);
    //
    //   switch (serviceStatus) {
    //     case ServiceStatus.enabled:
    //       status = true;
    //       break;
    //     case ServiceStatus.disabled:
    //       status = false;
    //       break;
    //     case ServiceStatus.notApplicable:
    //       status = false;
    //       break;
    //     default:
    //       status = false;
    //       break;
    //   }
    // });

    return rstatus;
  }

  // Future<void> requestPermission(Permission _permissionGroup) async {
  //   final List<Permission> permissions = <Permission>[
  //     _permissionGroup
  //   ];
  //   final Map<Permission, PermissionStatus> permissionRequestResult =
  //       await PermissionHandler().requestPermissions(permissions);
  //   _permissionStatus = permissionRequestResult[_permissionGroup];
  // }
}
