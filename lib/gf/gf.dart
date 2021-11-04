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
                  child: Expanded(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.arrow_drop_down_circle),
                          title: Text(snapshot.data['data'][index]['name']),
                          subtitle: Text('Price : Rp.' + snapshot.data['data'][index]['price'],
                            style: TextStyle(color: Colors.black.withOpacity(0.6)),
                          ),
                        ),
                        Divider(color: Colors.black,),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child:
                            Text(snapshot.data['data'][index]['description'],
                              style: TextStyle(color: Colors.black.withOpacity(0.6))
                            ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(product: snapshot.data['data'][index],)));
                          },
                          child: Container(
                            padding: EdgeInsets.all(5), height: 250, width: 250,
                            child:
                              Image.network(snapshot.data['data'][index]['image_url']),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditProduct(product: snapshot.data['data'][index])));
                              },
                              child: Icon(Icons.edit),
                            ),
                            SizedBox(width: 20,),
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
                        SizedBox(height: 20,)
                      ],
                    ),
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