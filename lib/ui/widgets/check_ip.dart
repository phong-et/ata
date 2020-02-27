import 'package:ata/core/notifiers/check_ip_notifier.dart';
import 'package:ata/ui/widgets/ata_text_field.dart';
import 'package:ata/ui/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckIP extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseWidget<CheckIpNotifier>(
      notifier: CheckIpNotifier(Provider.of(context)),
      onNotifierReady: (notifier) => notifier.getIpAddress(),
      builder: (context, notifier, child) {
        return Row(
          children: <Widget>[
            Expanded(
              child: AtaTextField(
                label: 'Current IP Address:',
                initialValue: notifier.busy ? 'Loading ...' : notifier.ipAddress,
              ),
            ),
            IconButton(
              onPressed: () => notifier.getIpAddress(),
              icon: Icon(Icons.refresh),
            )
          ],
        );
      },
    );

    // Row(
    //   children: <Widget>[
    //     Expanded(
    //       child: AtaTextField(
    //         label: 'Current IP Address:',
    //       ),
    //     ),
    //     IconButton(
    //       onPressed: () {},
    //       icon: Icon(Icons.refresh),
    //     )
    //   ],
    // );

    // Center(
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
    // );
  }
}
