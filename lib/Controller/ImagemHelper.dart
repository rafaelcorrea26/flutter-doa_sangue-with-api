import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

var CaminhoImagem = "assets/pictures/profile-picture.jpg";
File? arquivo;
File? imageTemp;

String? verificarCaminhoImagem() {
  if (arquivo == null) {
    return "";
  } else {
    return arquivo?.path;
  }
}

Future mostraDialogoEscolha(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Escolha uma opção",
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Divider(
                  height: 1,
                  color: Colors.blue,
                ),
                ListTile(
                  onTap: () {
                    abreGaleria(context);
                  },
                  title: Text("Galeria"),
                  leading: Icon(
                    Icons.account_box,
                    color: Colors.blue,
                  ),
                ),
                Divider(
                  height: 1,
                  color: Colors.blue,
                ),
                ListTile(
                  onTap: () {
                    abreCamera(context);
                  },
                  title: Text("Câmera"),
                  leading: Icon(
                    Icons.camera,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

cropImage(filePath, BuildContext context) async {
  File? croppedImage = await ImageCropper().cropImage(
    sourcePath: filePath,
    maxWidth: 150,
    maxHeight: 150,
    aspectRatio: CropAspectRatio(ratioX: 9, ratioY: 9),
    cropStyle: CropStyle.rectangle,
    androidUiSettings: androidUiSettings(),
    iosUiSettings: iosUiSettings(),
  );
  if (croppedImage != null) {
    imageTemp = croppedImage;
  }
}

IOSUiSettings iosUiSettings() => IOSUiSettings(
      aspectRatioLockEnabled: false,
    );

AndroidUiSettings androidUiSettings() => AndroidUiSettings(
      toolbarTitle: 'Ajuste a Imagem',
      toolbarColor: Colors.red,
      toolbarWidgetColor: Colors.white,
      lockAspectRatio: false,
    );

Future abreCamera(BuildContext context) async {
  try {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return;

    cropImage(image.path, context);
  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
  }
}

Future abreGaleria(BuildContext context) async {
  try {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    cropImage(image.path, context);
  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
  }
}
