import 'package:flutter/material.dart';

class AtaButton extends StatefulWidget {
  final Function onPressed;
  final String label;

  AtaButton({@required this.onPressed, this.label = ''});

  @override
  _AtaButtonState createState() => _AtaButtonState();
}

class _AtaButtonState extends State<AtaButton> {
  bool _isLoading = false;

  Function get invokeHandler {
    if (widget.onPressed == null)
      return null;
    else
      return () async {
        setState(() {
          _isLoading = true;
        });
        await widget.onPressed();
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      };
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
      disabledColor: Theme.of(context).primaryColor.withOpacity(0.5),
      disabledTextColor: Colors.white,
      color: Theme.of(context).accentColor,
      textColor: Colors.white,
      icon: _isLoading
          ? SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
          : Icon(Icons.refresh),
      label: Text(
        widget.label,
      ),
      onPressed: _isLoading ? null : invokeHandler,
    );
  }
}
