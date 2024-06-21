import 'dart:io';
import 'dart:typed_data';

class Media {
  File? photo;
  bool? isPhoto;
  Uint8List? previewPhoto;

  Media({
    this.photo,
    this.isPhoto,
    this.previewPhoto,
  });
}
