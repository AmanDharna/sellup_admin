import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService{
  final CollectionReference _categoriesCollection = Firestore.instance.collection("categories");

  void createCategory(String name){
    var id = Uuid();
    String categoryId = id.v1();

    _categoriesCollection.document(categoryId).setData({'category': name});
  }

  Future<List<DocumentSnapshot>> getCategories() =>
      _categoriesCollection.getDocuments().then((value) {
      return value.documents;
    });

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
      _categoriesCollection.where('category', isEqualTo: suggestion).getDocuments().then((snap){
        return snap.documents;
      });
}