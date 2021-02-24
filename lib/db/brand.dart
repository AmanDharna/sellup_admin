import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class BrandService {
  final CollectionReference _brandsCollection = Firestore.instance.collection(
      "brands");

  void createBrand(String name) {
    var id = Uuid();
    String brandId = id.v1();

    _brandsCollection.document(brandId).setData({'brand': name});
  }

  Future<List<DocumentSnapshot>> getBrands() =>
      _brandsCollection.getDocuments().then((snaps) {
        return snaps.documents;
      });

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
      _brandsCollection.where('brand', isEqualTo: suggestion).getDocuments().then((snap){
        return snap.documents;
      });


}
