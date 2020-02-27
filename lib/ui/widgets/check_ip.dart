import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ata/util.dart';
import 'package:ata/core/services/ip_info_service.dart';

class CheckIP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        // child: Column(
        //   children: <Widget>[
        //     Consumer<IpInfoService>(
        //       builder: (_, notifier, __) {
        //         switch (notifier.state) {
        //           case NotifierState.INIT:
        //             return Text('Read to load device IP');
        //           case NotifierState.LOADING:
        //             return CircularProgressIndicator();
        //           case NotifierState.LOADED:
        //             return notifier.ipInfo.fold(
        //               (failure) => Text(failure.toString()),
        //               (ipInfo) => Text(ipInfo.ipAddress),
        //             );
        //           case NotifierState.ERROR:
        //             return Text('Something\'s wrong!');
        //           default:
        //             return null;
        //         }
        //       },
        //     ),
        //     RaisedButton.icon(
        //       label: Text('Get IP Address'),
        //       icon: Icon(Icons.refresh),
        //       onPressed: () => Provider.of<IpInfoService>(
        //         context,
        //         listen: false,
        //       ).fetchDeviceIpInfo(),
        //     )
        //   ],
        // ),
        );
  }
}
