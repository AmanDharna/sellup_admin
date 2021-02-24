import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService{
  final CollectionReference productsCollection = Firestore.instance.collection("products");

  void uploadProduct(Map<String, dynamic> data){
    var id = Uuid();
    String productId = id.v1();
    data["id"] = productId;

    productsCollection.document(data["id"]).setData(data);
  }

}