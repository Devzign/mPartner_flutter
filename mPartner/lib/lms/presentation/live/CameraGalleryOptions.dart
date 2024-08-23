



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'OnFileChoose.dart';

class CameraGalleryOptions{

  late ImagePickerResponse imagePickerResponse;
  CameraGalleryOptions(this. imagePickerResponse);
   openOptions(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) =>
          CupertinoActionSheet(
            actions: <CupertinoActionSheetAction>[
              CupertinoActionSheetAction(

                /// This parameter indicates the action would be a default
                /// default behavior, turns the action's text to bold text.
                isDefaultAction: true,
                onPressed: () async {
                  Navigator.pop(context);
                  ImagePicker _picker=ImagePicker();
                  XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if(image!=null){
                    imagePickerResponse.onPicker(file: image);
                  }

                },
                child: const Text('Camera'),
              ),
              CupertinoActionSheetAction(

                /// This parameter indicates the action would perform
                /// a destructive action such as delete or exit and turns
                /// the action's text color to red.
                isDestructiveAction: true,
                onPressed: () async {
                  Navigator.pop(context);
                  ImagePicker _picker=ImagePicker();
                  XFile? image = await _picker.pickImage(source: ImageSource.camera);
                  if(image!=null){
                    imagePickerResponse.onPicker(file: image);
                  }
                },
                child: const Text('Gallery'),
              ),


            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.of(context).pop;
              },
              child: Text('Cancel'),
            ),
          ),
    );
  }

}