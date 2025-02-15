import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? id;
  String category;
  String title;
  String description;
  int quantity;
  String saleType; // "Auction" or "Buy Now"
  double? startingBid;
  double? price;
  bool selfDestruct;
  bool liveOnly;
  String? streamer;
  String? delivery;
  List<String>? images;

  Product({
    this.id,
    required this.category,
    required this.title,
    required this.description,
    this.quantity = 1,
    required this.saleType,
    this.startingBid,
    this.price,
    this.selfDestruct = false,
    this.liveOnly = false,
    this.streamer,
    this.delivery,
    this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"],
      category: json["category"] ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      quantity: json["quantity"] ?? 1,
      saleType: json["saleType"] ?? "Auction",
      startingBid: json["startingBid"]?.toDouble(),
       price: json["startingBid"]?.toDouble(),
      selfDestruct: json["price"] ?? false,
      liveOnly: json["liveOnly"] ?? false,
      streamer: json["streamer"],
      delivery: json["delivery"],
      images: json["images"] != null ? List<String>.from(json["images"]) : [],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "category": category,
      "title": title,
      "description": description,
      "quantity": quantity,
      "saleType": saleType,
      "startingBid": startingBid,
      "selfDestruct": selfDestruct,
      "liveOnly": liveOnly,
      "streamer": streamer,
      "delivery": delivery,
      "images": images,
    };
  }
  static CollectionReference<Product> collection() {
    return FirebaseFirestore.instance.collection('products').withConverter(
          fromFirestore: (snapshot, _) =>
              Product.fromJson(snapshot.data()!),
          toFirestore: (product, _) => product.toJson(),
        );
  }
}
