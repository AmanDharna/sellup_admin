import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sellupadmin/db/brand.dart';
import 'package:sellupadmin/db/category.dart';
import 'package:sellupadmin/db/product.dart';
import 'package:sellupadmin/providers/product_provider.dart';
import 'package:sellupadmin/shared/loading.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService _productService = ProductService();

  File _image1, _image2, _image3;
  bool loading = false;

  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<String> selectedSizes = <String>[];
  List<String> colors = <String>[];
  
  List<DropdownMenuItem<String>> categoriesDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];

  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];

  String _currentCategory, _currentBrand;
  bool onSale = false, featured = false;

  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = HexColor("#ef728d");

  @override
  void initState() {
    _getCategories();
    _getBrands();
  }

  List<DropdownMenuItem<String>> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> items = new List();
    for(int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(0, DropdownMenuItem(child: Text(categories[i].data()["category"]),
          value: categories[i].data()["category"],
        ));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getBrandsDropdown() {
    List<DropdownMenuItem<String>> items = new List();
    for(int i=0; i<brands.length; i++) {
      setState(() {
        items.insert(0, DropdownMenuItem(child: Text(brands[i].data()["brand"]),
        value: brands[i].data()["brand"],
        ));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    categories.forEach((category) {
        print("cat" + category.data()["category"]);
    });

    brands.forEach((brand) {
      print("brands" + brand.data()["brand"]);
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
              leading: Container(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                  color: Colors.black,
                  splashColor: HexColor("#ef728d"),
                  alignment: Alignment.center,
                  onPressed: () => Navigator.of(context).pop(null),
                ),
              ),
//            leading: Icon(
//            Icons.arrow_back,
//            color: black,
//        ),
        title: Text(
          "Add Product",
          style: TextStyle(color: black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: loading ? Loading() : Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                      child: OutlineButton(
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5),
                          width: 2.5,
                        ),
                        onPressed: () {
                          _selectImage(ImagePicker.pickImage(source: ImageSource.gallery));
                        },
                        child: _displayChild1(),
                      ),
                    ),
                  ),

//                  Expanded(
//                    child: Padding(
//                      padding: const EdgeInsets.all(6.0),
//                      child: OutlineButton(
//                        borderSide: BorderSide(
//                          color: Colors.grey.withOpacity(0.5),
//                          width: 2.5,
//                        ),
//                        onPressed: () {
//                          _selectImage(ImagePicker.pickImage(source: ImageSource.gallery), 2);
//                        },
//                        child: _displayChild2(),
//                      ),
//                    ),
//                  ),

//                  Expanded(
//                    child: Padding(
//                      padding: const EdgeInsets.all(6.0),
//                      child: OutlineButton(
//                        borderSide: BorderSide(
//                          color: Colors.grey.withOpacity(0.5),
//                          width: 2.5,
//                        ),
//                        onPressed: () {
//                          _selectImage(ImagePicker.pickImage(source: ImageSource.gallery), 3);
//                        },
//                        child: _displayChild3(),
//                      ),
//                    ),
//                  ),

                ],
              ),

//              Padding(
//                padding: const EdgeInsets.all(12.0),
//                child: Text(
//                  "Enter Product Name",
//                  textAlign: TextAlign.center,
//                  style: TextStyle(
//                    color: HexColor("#ef728d"),
//                    fontSize: 16,
//                  ),
//                ),
//              ),

              Text("Available Colors",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        if(productProvider.selectedColors.contains("red")){
                          productProvider.removeColors("red");
                        } else {
                          productProvider.addColors("red");
                        }

                        setState(() {
                          colors = productProvider.selectedColors;
                        });
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: productProvider.selectedColors.contains("red") ? Colors.blue : grey,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            backgroundColor: HexColor("#ef728d"),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        if(productProvider.selectedColors.contains('yellow')){
                          productProvider.removeColors('yellow');
                        }else{
                          productProvider.addColors('yellow');

                        }
                        setState(() {
                          colors = productProvider.selectedColors;
                        });
                      },
                      child: Container(width: 24, height: 24, decoration: BoxDecoration(
                          color: productProvider.selectedColors.contains('yellow') ? red : grey,
                          borderRadius: BorderRadius.circular(15)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            backgroundColor: Colors.yellow,
                          ),
                        ),),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        if(productProvider.selectedColors.contains('blue')){
                          productProvider.removeColors('blue');
                        }else{
                          productProvider.addColors('blue');

                        }
                        setState(() {
                          colors = productProvider.selectedColors;
                        });
                      },
                      child: Container(width: 24, height: 24, decoration: BoxDecoration(
                          color: productProvider.selectedColors.contains('blue') ? red : grey,
                          borderRadius: BorderRadius.circular(15)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            backgroundColor: Colors.blue,
                          ),
                        ),),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        if(productProvider.selectedColors.contains('green')){
                          productProvider.removeColors('green');
                        }else{
                          productProvider.addColors('green');

                        }
                        setState(() {
                          colors = productProvider.selectedColors;
                        });
                      },
                      child: Container(width: 24, height: 24, decoration: BoxDecoration(
                          color: productProvider.selectedColors.contains('green') ? red : grey,
                          borderRadius: BorderRadius.circular(15)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                          ),
                        ),),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        if(productProvider.selectedColors.contains('white')){
                          productProvider.removeColors('white');
                        }else{
                          productProvider.addColors('white');

                        }
                        setState(() {
                          colors = productProvider.selectedColors;
                        });
                      },
                      child: Container(width: 24, height: 24, decoration: BoxDecoration(
                          color: productProvider.selectedColors.contains('white') ? red : grey,
                          borderRadius: BorderRadius.circular(15)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            backgroundColor: white,
                          ),
                        ),),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: (){
                        if(productProvider.selectedColors.contains('black')){
                          productProvider.removeColors('black');
                        }else{
                          productProvider.addColors('black');

                        }
                        setState(() {
                          colors = productProvider.selectedColors;
                        });
                      },
                      child: Container(width: 24, height: 24, decoration: BoxDecoration(
                          color: productProvider.selectedColors.contains('black') ? red : grey,
                          borderRadius: BorderRadius.circular(15)
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            backgroundColor: black,
                          ),
                        ),),
                    ),
                  ),


                ],
              ),

              Text("Available Sizes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),

              Row(
                children: <Widget>[
                  Checkbox(value: selectedSizes.contains("XS"), onChanged: (value) => changeSelectedSize("XS")),
                  Text("XS"),

                  Checkbox(value: selectedSizes.contains("S"), onChanged: (value) => changeSelectedSize("S")),
                  Text("S"),

                  Checkbox(value: selectedSizes.contains("M"), onChanged: (value) => changeSelectedSize("M")),
                  Text("M"),

                  Checkbox(value: selectedSizes.contains("L"), onChanged: (value) => changeSelectedSize("L")),
                  Text("L"),

                  Checkbox(value: selectedSizes.contains("XL"), onChanged: (value) => changeSelectedSize("XL")),
                  Text("XL"),

                  Checkbox(value: selectedSizes.contains("XXL"), onChanged: (value) => changeSelectedSize("XXL")),
                  Text("XXL"),
                ],
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Sale'),
                      SizedBox(width: 10,),
                      Switch(value: onSale, onChanged: (value){
                        setState(() {
                          onSale = value;
                        });
                      }),
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      Text('Featured'),
                      SizedBox(width: 10,),
                      Switch(value: featured, onChanged: (value){
                        setState(() {
                          featured = value;
                        });
                      }),
                    ],
                  ),

                ],
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                    controller: productNameController,
                    decoration: InputDecoration(
                        hintText: "Product Name"
                    ),
                    validator: (value) {
                      if(value.isEmpty) {
                        return "You must enter the product name";
                      } else if(value.length > 20) {
                        return "Product name cannot have more than 10 letters";
                      }
                    }
                ),
              ),

              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Category", style: TextStyle(color: Colors.black),),
                  ),
                  DropdownButton(
                    items: categoriesDropDown,
                    onChanged: changeSelectedCategory,
                    value: _currentCategory,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Brand", style: TextStyle(color: Colors.black),),
                  ),
                  DropdownButton(
                    items: brandsDropDown,
                    onChanged: changeSelectedBrand,
                    value: _currentBrand,
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Quantity",
                  ),
                  validator: (value) => value.isEmpty ? "You must enter the quantity" : null,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Price",
                  ),
                  validator: (value) => value.isEmpty ? "You must enter the price" : null,
                ),
              ),

              FlatButton(
                color: Colors.black,
                textColor: Colors.white,
                child: Text("Add Product"),
                onPressed: (){
                  validateAndUpload();
                },
              )

            ],
          ),
        ),
      ),
    );
  }

//  void _selectImage(Future<File> pickImage, int imageNumber) async{
//    File tempImg = await pickImage;
//    switch(imageNumber){
//      case 1: setState(() => _image1 = tempImg);
//      break;
//      case 2: setState(() => _image2 = tempImg);
//      break;
//      case 3: setState(() => _image3 = tempImg);
//      break;
//    }
//  }

  void _selectImage(Future<File> pickImage) async {
    File tempImg = await pickImage;
    setState(() => _image1 = tempImg);
  }

  Widget _displayChild1() {
    if(_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(Icons.add, color: HexColor("#ef728d"),),
      );
    } else {
      return Image.file(_image1, fit: BoxFit.fill, width: double.infinity,);
    }
  }

//  Widget _displayChild2() {
//    if(_image2 == null){
//      return Padding(
//        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
//        child: new Icon(Icons.add, color: Colors.grey,),
//      );
//    }else{
//      return Image.file(_image2, fit: BoxFit.fill, width: double.infinity,);
//    }
//  }
//
//  Widget _displayChild3() {
//    if(_image3 == null){
//      return Padding(
//        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
//        child: new Icon(Icons.add, color: Colors.grey,),
//      );
//    }else{
//      return Image.file(_image3, fit: BoxFit.fill, width: double.infinity,);
//    }
//  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print(data.length);
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropdown();
      _currentCategory = categories[0].data()["category"];
    });
  }

  _getBrands() async{
    List<DocumentSnapshot> data = await _brandService.getBrands();
    print(data.length);
    setState(() {
      brands = data;
      brandsDropDown = getBrandsDropdown();
      _currentBrand = brands[0].data()["brand"];
    });
  }

  changeSelectedCategory(String selectedCategory){
    setState(() {
      _currentCategory = selectedCategory;
    });
  }

  changeSelectedBrand(String selectedBrand){
    setState(() {
      _currentBrand = selectedBrand;
    });
  }

  void changeSelectedSize(String size){
    if(selectedSizes.contains(size)){
      setState(() {
        selectedSizes.remove(size);
      });
    } else {
      setState(() {
        selectedSizes.insert(0, size);
      });
    }
  }

  void validateAndUpload() async {
    if(_formKey.currentState.validate()){
      setState(() => loading = true);
      if(_image1 != null){
        if(selectedSizes.isNotEmpty){
          String imageUrl_1;
//          String imageUrl_2;
//          String imageUrl_3;

          final FirebaseStorage storage = FirebaseStorage.instance;

          final String picture_1 = "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          UploadTask uploadTask_1 = storage.ref().child(picture_1).putFile(_image1);
          //UploadTask uploadTask_1 = reference_1.putFile(_image1);

//          uploadTask_1.then((response)  {
//            response.ref.getDownloadURL();
//          });

//          final String picture_2 = "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
//          storage.ref().child(picture_2).putFile(_image2);
//          UploadTask uploadTask_2 = storage.ref().child(picture_2).putFile(_image2);
//          //UploadTask uploadTask_2 = reference_2.putFile(_image2);
//
//          final String picture_3 = "${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
//          storage.ref().child(picture_3).putFile(_image3);
//          UploadTask uploadTask_3 = storage.ref().child(picture_3).putFile(_image3);
          //UploadTask uploadTask_3 = reference_3.putFile(_image3);

          TaskSnapshot snapshot_1 = await uploadTask_1.then((snapshot) => snapshot);
//          TaskSnapshot snapshot_2 = await uploadTask_2.then((snapshot) => snapshot);
//          TaskSnapshot snapshot_3 = await uploadTask_3.then((snapshot) => snapshot);

          uploadTask_1.then((response) async {
            imageUrl_1 = await snapshot_1.ref.getDownloadURL();
            //imageUrl_2 = await snapshot_2.ref.getDownloadURL();
            //imageUrl_3 = await snapshot_3.ref.getDownloadURL();

            print("url1"  + imageUrl_1);
//            print("url2"  + imageUrl_2);
//            print("url3"  + imageUrl_3);

            //List<String> imageList = [imageUrl_1];
            _productService.uploadProduct({
              "name": productNameController.text,
              "price": double.parse(priceController.text),
              "sizes": selectedSizes,
              "colors": colors,
              "picture": imageUrl_1,
              "quantity": int.parse(quantityController.text),
              "brand": _currentBrand,
              "category": _currentCategory,
              'sale': onSale,
              'featured': featured
            });
            _formKey.currentState.reset();
            setState(() => loading = false);
            Fluttertoast.showToast(msg: "Product Added");
          });

        } else {
          setState(() => loading = false);
          Fluttertoast.showToast(msg: "Select alteast one size");
        }
      } else {
        setState(() => loading = false);
        Fluttertoast.showToast(msg: "All the images must be provided");
      }
    }
  }
}
