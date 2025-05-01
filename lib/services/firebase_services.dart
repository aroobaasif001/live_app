import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:live_app/entities/product_entity.dart';


class FirebaseService {
  static Future<List<String>> uploadImages(List<File> images) async {
    List<String> imageUrls = [];
    for (var image in images) {
      String fileName = "product_${DateTime.now().millisecondsSinceEpoch}.jpg";
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("product_images/$fileName")
          .putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageUrls.add(downloadUrl);
    }
    return imageUrls;
  }
  static Future<void> saveProduct(ProductEntity product) async {
    await ProductEntity.collection().add(product);
  }
}