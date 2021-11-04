import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toko_online/screens/homepage.dart';
import 'package:http/http.dart' as http;

class EditProduct extends StatelessWidget {
  final Map product;
  EditProduct({@required this.product});

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _imageUrlController = TextEditingController();

  Future editProduct() async
  {
    final response = await http.put(Uri.parse("https://toko-flutter-test.herokuapp.com/api/products/" + product['id'].toString()), body: {
      "name": _nameController.text,
      "description": _descriptionController.text,
      "price": _priceController.text,
      "image_url": _imageUrlController.text,
    });
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController..text = product['name'],
                  decoration: InputDecoration(labelText: "Name"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Fill out product name";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController..text = product['description'],
                  decoration: InputDecoration(labelText: "Description"),
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return "Fill out product description";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController..text = product['price'],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Price"),
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return "Fill out product price";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _imageUrlController..text = product['image_url'],
                  decoration: InputDecoration(labelText: "Image URL"),
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return "Fill out product image url";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: (){
                  if (_formKey.currentState.validate()) {
                    editProduct().then((value) {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (Route<dynamic> route) => false,);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Update Success"),));
                    });
                  }
                  else{

                  }
                }, child: Text('Update'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}