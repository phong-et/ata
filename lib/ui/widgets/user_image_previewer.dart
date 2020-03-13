import 'package:ata/core/notifiers/user_image_previewer_notifier.dart';
import 'package:ata/ui/widgets/base_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserImagePreviewer extends StatefulWidget {
  final String photoUrl;
  final bool loadingState;
  final Function onUpdateUrl;
  UserImagePreviewer({
    @required this.photoUrl,
    @required this.loadingState,
    this.onUpdateUrl,
  });

  @override
  _UserImagePreviewerState createState() => _UserImagePreviewerState();
}

class _UserImagePreviewerState extends State<UserImagePreviewer> {
  final photoUrlFocusNode = FocusNode();
  final photoUrlController = TextEditingController();
  Function unFocusHandler;

  void _updateUrl(String url) {
    if (widget.onUpdateUrl != null) widget.onUpdateUrl(url);
  }

  @override
  void initState() {
    super.initState();
    photoUrlFocusNode.addListener(() {
      if (!photoUrlFocusNode.hasFocus) {
        _updateUrl(photoUrlController.text);
        unFocusHandler();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    photoUrlFocusNode.dispose();
    photoUrlController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    photoUrlController.text = widget.photoUrl;
    return BaseWidget<UserImagePreviewerNotifier>(
        notifier: UserImagePreviewerNotifier(),
        builder: (context, notifier, child) {
          unFocusHandler = () {
            notifier.updatePhotoUrl(photoUrlController.text);
          };

          return Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Photo Url'),
                keyboardType: TextInputType.url,
                focusNode: photoUrlFocusNode,
                controller: photoUrlController,
                style: TextStyle(color: widget.loadingState || notifier.busy ? Colors.grey : Colors.black),
                onChanged: (url) {
                  _updateUrl(url);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 120,
                height: 120,
                child:
                    widget.loadingState || notifier.busy ? _imageLoading : _userImagePreviewer(photoUrlController.text),
              ),
            ],
          );
        });
  }
}

Widget _userImagePreviewer(String url) {
  return ClipOval(
    child: CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Image(
        fit: BoxFit.cover,
        image: imageProvider,
      ),
      placeholder: (context, url) => _imageLoading,
      errorWidget: (context, url, error) => Icon(Icons.error),
    ),
  );
}

Widget get _imageLoading {
  return Center(
    child: SizedBox(
      width: 20.0,
      height: 20.0,
      child: CircularProgressIndicator(),
    ),
  );
}
