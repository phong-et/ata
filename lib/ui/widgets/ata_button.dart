import 'package:flutter/material.dart';

class AtaButton extends StatefulWidget {
  final Function onPressed;
  final String label;
  final Color color;
  final Icon icon;

  AtaButton({
    @required this.onPressed,
    this.label = '',
    this.color,
    this.icon,
  });

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
      color: widget.color == null ? Theme.of(context).primaryColor : widget.color,
      textColor: Colors.white,
      icon: _isLoading
          ? SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            )
          : widget.icon == null ? Icon(Icons.refresh) : widget.icon,
      label: Text(
        widget.label,
      ),
      onPressed: _isLoading ? null : invokeHandler,
    );
  }
}
