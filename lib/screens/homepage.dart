import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toko_online/screens/add_product.dart';
import 'package:toko_online/screens/edit_product.dart';
import 'package:toko_online/screens/product_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String url = 'https://toko-flutter-test.herokuapp.com/api/products';

  Future getProducts() async
  {
    var response = await http.get(Uri.parse(url));
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  Future deleteProduct(String productId) async
  {
    String url = 'https://toko-flutter-test.herokuapp.com/api/products/' + productId;

    var response = await http.delete(Uri.parse(url));
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddProduct()));
        },
        child: Icon(Icons.add),
        ),
      appBar: AppBar(
        title: Text('Laravel + Flutter API'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
            setState((){});
        },
        child: FutureBuilder(
          future: getProducts(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(itemCount: snapshot.data['data'].length, itemBuilder: (context, index){
                return Container(
                  height: 185,
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    elevation: 5,
                    child: Row(
                      children: [
                        GestureDetector(onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(product: snapshot.data['data'][index],)));
                        },
                        child:
                          Container(padding: EdgeInsets.all(5),height: 120, width: 120,
                            child: Image.network(snapshot.data['data'][index]['image_url'])
                          )
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(alignment: Alignment.topLeft,
                                  child:
                                    Text(snapshot.data['data'][index]['name'], style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),)),
                                    SizedBox(height: 3),
                                Align(alignment: Alignment.topLeft,
                                  child:
                                    Text('Rp.' + snapshot.data['data'][index]['price'], style: TextStyle(fontSize: 17),)),
                                    SizedBox(height: 3),
                                Align(alignment: Alignment.topLeft,
                                  child:
                                    Text(snapshot.data['data'][index]['description'], style: TextStyle(fontSize: 17, color: Colors.grey[400]),)),
                                    SizedBox(height: 13),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        OutlineButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          onPressed: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProduct(product: snapshot.data['data'][index],)));
                                          },
                                          child:
                                            Text("Edit", style: TextStyle(),),
                                        ),
                                        Container(width: 10),
                                        OutlineButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          onPressed: () {
                                            deleteProduct(snapshot.data['data'][index]['id'].toString()).then((value){
                                              setState(() {});
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Delete product success"),));
                                            });
                                          },
                                          child: Text("Delete", style: TextStyle(),),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            }
            else{
              return Text('Data error');
            }
          },
        ),
      )
    );
  }
}