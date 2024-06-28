import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class WishlistScreen extends StatefulWidget {
  @override
  _WhishlistScreenState createState() => _WhishlistScreenState();
}

class _WhishlistScreenState extends State<WishlistScreen> {
  late Future<List<Map<String, dynamic>>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = wishListData();
  }

  Future<List<Map<String, dynamic>>> getWishListDB() async {
    M.Db db = await M.Db.create(
        "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
    await db.open();

    M.DbCollection collection = db.collection("favorite_locations");
    List<Map<String, dynamic>> data = await collection.find().toList();
    await db.close();

    return data;
  }

  Future<List<Map<String, dynamic>>> wishListData() async {
    List<Map<String, dynamic>> wishList = await getWishListDB();
    List<Map<String, dynamic>> allData = [];
    M.Db db = await M.Db.create(
        "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
    await db.open();

    M.DbCollection homeCollection = db.collection("home_page");

    for (var item in wishList) {
      var objectIdStr = item["id"].toString();
      if (objectIdStr.startsWith('ObjectId("') && objectIdStr.endsWith('")')) {
        objectIdStr = objectIdStr.substring(10, 34); // Extract the hex string
      }

      if (objectIdStr.length == 24) {
        try {
          var objectId = M.ObjectId.fromHexString(objectIdStr);
          var query = M.where.eq('_id', objectId);
          List<Map<String, dynamic>> data =
              await homeCollection.find(query).toList();
          allData.addAll(data);
        } catch (e) {
          print("Invalid ObjectId format: $objectIdStr");
          continue; // Skip this item if ObjectId is invalid
        }
      } else {
        print("Invalid ObjectId format: $objectIdStr");
        continue; // Skip this item if ObjectId is invalid
      }
    }
    await db.close();

    print(allData);
    return allData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 20), // Adjust spacing as needed
          Expanded(
            child: FutureBuilder(
              future: _dataFuture,
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('No apartments available.'),
                  );
                } else {
                  List<Map<String, dynamic>> data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildCard(item),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildImageWidget(item, context), // Show dynamic photo
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location: ${item['location']}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Price: ${item['price']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Features: ${item['features']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'More Details: ${item['moreDetails']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red, // Default color is red
                      size: 30,
                    ),
                    onPressed: () {
                      _deleteItem('${item['_id']}');
                      setState(() {
                        _dataFuture = wishListData(); // Refresh data future
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageWidget(Map<String, dynamic> item, BuildContext context) {
    final imageBase64 = item['image'];
    if (imageBase64 != null) {
      final imageBytes = base64Decode(imageBase64);
      return SizedBox(
        height: 200,
        child: Image.memory(
          imageBytes,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Container(
        height: 200,
        color: Colors.grey,
        child: Icon(
          Icons.image,
          size: 100,
          color: Colors.white,
        ),
      );
    }
  }

  _deleteItem(id) async {
    M.Db db = await M.Db.create(
        "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
    await db.open();

    M.DbCollection collection = db.collection("favorite_locations");

    await collection.deleteOne({"id": id});
    await db.close();
  }
}
