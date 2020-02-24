import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ata/widgets/ata_text_field.dart';
import 'package:ata/widgets/ata_button.dart';
import 'package:ata/providers/office_notifier.dart';
import 'package:ata/util.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  OfficeNotifier _officeNotifier;

  final ipAddressController = TextEditingController();
  final lonController = TextEditingController();
  final latController = TextEditingController();
  final authRangeController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    ipAddressController.dispose();
    lonController.dispose();
    latController.dispose();
    authRangeController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _officeNotifier = Provider.of<OfficeNotifier>(context);
  }

  Widget buildOfficeSettingsForm() {
    final state = _officeNotifier.state;
    final office = _officeNotifier.office;

    // return office.fold(
    //   (failure) => Center(
    //     child: Text(failure.toString()),
    //   ),
    //   (office) {
    //     switch (state) {
    //       case NotifierState.INIT:
    //         return null;
    //       case NotifierState.LOADING:
    //         return Center(child: CircularProgressIndicator());
    //       case NotifierState.ERROR:
    //         return Center(child: Text(office.error));
    //       case NotifierState.LOADED:
    //         ipAddressController.text = office.ipAddress;
    //         lonController.text = office.lon.toString();
    //         latController.text = office.lat.toString();
    //         authRangeController.text = office.authRange.toString();
    //         return Column(
    //           children: <Widget>[
    //             AtaTextField(
    //               label: 'Office IP Address',
    //               type: TextInputType.number,
    //               controller: ipAddressController,
    //             ),
    //             AtaTextField(
    //               label: 'Office Location\'s Longitude',
    //               type: TextInputType.number,
    //               controller: lonController,
    //             ),
    //             AtaTextField(
    //               label: 'Office Location\'s Lattitude',
    //               type: TextInputType.number,
    //               controller: latController,
    //             ),
    //             AtaTextField(
    //               label: 'Authentication Range',
    //               type: TextInputType.number,
    //               controller: authRangeController,
    //             ),
    //             SizedBox(
    //               height: 30,
    //             ),
    //             AtaButton(
    //               label: 'Update',
    //               handler: () async {
    //                 await _officeNotifier.updateOfficeSettings(
    //                   ipAddressController.text,
    //                   lonController.text,
    //                   latController.text,
    //                   authRangeController.text,
    //                 );
    //               },
    //             )
    //           ],
    //         );
    //       default:
    //         return null;
    //     }
    //   },
    // );

    switch (state) {
      case NotifierState.LOADING:
        return Center(child: CircularProgressIndicator());
      case NotifierState.ERROR:
        return null;
      case NotifierState.LOADED:
        return office.fold(
          (failure) => Center(
            child: Text(failure.toString()),
          ),
          (office) {
            ipAddressController.text = office.ipAddress;
            lonController.text = office.lon.toString();
            latController.text = office.lat.toString();
            authRangeController.text = office.authRange.toString();
            return Column(
              children: <Widget>[
                AtaTextField(
                  label: 'Office IP Address',
                  type: TextInputType.number,
                  controller: ipAddressController,
                ),
                AtaTextField(
                  label: 'Office Location\'s Longitude',
                  type: TextInputType.number,
                  controller: lonController,
                ),
                AtaTextField(
                  label: 'Office Location\'s Lattitude',
                  type: TextInputType.number,
                  controller: latController,
                ),
                AtaTextField(
                  label: 'Authentication Range',
                  type: TextInputType.number,
                  controller: authRangeController,
                ),
                SizedBox(
                  height: 30,
                ),
                AtaButton(
                  label: 'Update',
                  handler: () async {
                    await _officeNotifier.updateOfficeSettings(
                      ipAddressController.text,
                      lonController.text,
                      latController.text,
                      authRangeController.text,
                    );
                  },
                )
              ],
            );
          },
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 8.0,
      child: Container(
        height: 380,
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: buildOfficeSettingsForm(),
      ),
    );
  }
}
