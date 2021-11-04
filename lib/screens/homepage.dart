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
                  height: 180,
                  child: Card(
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
                            padding: EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Align(alignment: Alignment.topLeft,
                                  child:
                                    Text(snapshot.data['data'][index]['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                                Align(alignment: Alignment.topLeft,
                                  child:
                                    Text(snapshot.data['data'][index]['description'], )),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProduct(product: snapshot.data['data'][index],)));
                                          },
                                          child: Icon(Icons.edit)
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            deleteProduct(snapshot.data['data'][index]['id'].toString()).then((value){
                                              setState(() {});
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Delete product success"),));
                                            });
                                          },
                                          child: Icon(Icons.delete)
                                        ),
                                      ],
                                    ),
                                    Text('Rp.' + snapshot.data['data'][index]['price'], style: TextStyle(fontSize: 17),),
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