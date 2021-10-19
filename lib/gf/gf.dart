import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toko_online/gf/add_product.dart';
import 'package:toko_online/gf/edit_product.dart';
import 'package:getwidget/getwidget.dart';
import 'package:toko_online/gf/product_detail.dart';

class GfPage extends StatefulWidget {
  const GfPage({
    Key key,
  }) : super(key: key);

  @override
  _GfPageState createState() => _GfPageState();
}

class _GfPageState extends State<GfPage> {
  final String url = 'http://10.0.2.2:8000/api/products';

  Future getProducts() async
  {
    var response = await http.get(Uri.parse(url));
    print(json.decode(response.body));
    return json.decode(response.body);
  }

  Future deleteProduct(String productId) async
  {
    String url = 'http://10.0.2.2:8000/api/products/' + productId;

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
        title: Text('GF Unit Testing'),
      ),
      body: FutureBuilder(
        future: getProducts(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return ListView.builder(itemCount: snapshot.data['data'].length, itemBuilder: (context, index){
              return Container(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.arrow_drop_down_circle),
                        title: Text(snapshot.data['data'][index]['name']),
                        subtitle: Text('Price : Rp.' + snapshot.data['data'][index]['price'],
                          style: TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child:
                          Text(snapshot.data['data'][index]['description'],
                            style: TextStyle(color: Colors.black.withOpacity(0.6))
                          ),
                      ),
                      GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(5), height: 250, width: 250,
                          child:
                            Image.network(snapshot.data['data'][index]['image_url']),
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: (){

                            },
                            child: Text('Edit')
                          ),
                          ElevatedButton(
                            onPressed: (){

                            },
                            child: Text('Delete')
                          ),
                        ],
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
      )
    );
  }
}