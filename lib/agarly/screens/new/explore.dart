import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/agarly/screens/new/HomeDrawer.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

import 'rate and review/reviews_screen.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<List<Map<String, dynamic>>> _dataFuture;
  late List<bool> _isFavorite;

  @override
  void initState() {
    super.initState();
    _dataFuture = getDataFromMongoDB();
    _isFavorite = [];
  }

  Future<List<Map<String, dynamic>>> getDataFromMongoDB() async {
    M.Db db = await M.Db.create(
        "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
    await db.open();

    M.DbCollection collection = db.collection("home_page");
    List<Map<String, dynamic>> data = await collection.find().toList();
    await db.close();

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      body: Column(
        children: [
          // _buildSearchBar(),
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
                } else {
                  List<Map<String, dynamic>> data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReviewsScreens(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _buildImageWidget(
                                      item, context), // Show dynamic photo
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Location: ${item['location']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        Text('Price: ${item['price']}'),
                                        const SizedBox(height: 8),
                                        Text('Features: ${item['features']}'),
                                        const SizedBox(height: 8),
                                        Text('area: ${item['area']}'),
                                        const SizedBox(height: 8),
                                        Text('bedrooms: ${item['bedrooms']}'),
                                        const SizedBox(height: 8),
                                        Text('bathrooms: ${item['bathrooms']}'),
                                        const SizedBox(height: 8),
                                        Text('level: ${item['level']}'),

                                        // const SizedBox(height: 8),

                                        // Text(
                                        //     'More Details: ${item['moreDetails']}'),
                                      ],
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: _isFavorite.isNotEmpty &&
                                                  _isFavorite[index]
                                              ? const Icon(Icons.favorite,
                                                  color: Colors.red)
                                              : const Icon(
                                                  Icons.favorite_border),
                                          onPressed: () {
                                            setState(() {
                                              if (_isFavorite.isEmpty) {
                                                _isFavorite = List.generate(
                                                    data.length, (_) => false);
                                              }
                                              _isFavorite[index] =
                                                  !_isFavorite[index];
                                              if (_isFavorite[index] == true) {
                                                pushWishListDB(
                                                    '${item['_id']}');
                                              } else {
                                                deleteWishListDB(
                                                    '${item['_id']}');
                                              }
                                            });
                                          },
                                        ),
                                        // TextButton(
                                        //   onPressed: () {},
                                        //   child: Text('reserve'),
                                        // ),
                                        // IconButton(
                                        //     icon: _isFavorite.isNotEmpty &&
                                        //             _isFavorite[index]
                                        //         ? const Icon(
                                        //             Icons.accessible_outlined,
                                        //             color: Colors.red)
                                        //         : const Icon(
                                        //             Icons.accessible_outlined),
                                        //     onPressed: () {}),
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        ),
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

  // Widget _buildSearchBar() {
  //   return SizedBox(
  //     width: MediaQuery.of(context).size.width,
  //     child: Align(
  //       alignment: Alignment.topCenter,
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 10),
  //         child: Material(
  //           borderRadius: BorderRadius.circular(32.0),
  //           color: Colors.transparent,
  //           child: InkWell(
  //             borderRadius: BorderRadius.circular(32.0),
  //             onTap: () {
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => Search()),
  //               );
  //               // Handle search action
  //             },
  //             child: Container(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 16.0,
  //                 vertical: 8.0,
  //               ),
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 border: Border.all(
  //                   color: Colors.grey,
  //                   width: 0.5,
  //                 ),
  //                 borderRadius: BorderRadius.circular(32.0),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: Colors.grey.withOpacity(0.5),
  //                     blurRadius: 8.0,
  //                     spreadRadius: 8.0,
  //                     offset: const Offset(0.0, 4.0),
  //                   ),
  //                 ],
  //               ),
  //               child: const Row(
  //                 children: [
  //                   Icon(Icons.search),
  //                   SizedBox(width: 8.0),
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'Where to?',
  //                         style: TextStyle(fontWeight: FontWeight.bold),
  //                       ),
  //                       Text(
  //                         'Anywhere • Any week • Add guest',
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildImageWidget(Map<String, dynamic> item, BuildContext context) {
    final imageBase64 = item['image'];
    if (imageBase64 != null) {
      final imageBytes = base64Decode(imageBase64);
      return SizedBox(
        width: MediaQuery.of(context).size.width, // Ensure finite width
        child: Image.memory(
          imageBytes,
          fit: BoxFit.cover,
          height: 200,
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
}

pushWishListDB(String id) async {
  M.Db db = await M.Db.create(
      "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
  await db.open();

  M.DbCollection collection = db.collection("favorite_locations");
  final data = WhishlistDbModel(
    id: id,
  );

  await collection.insert(data.toJson());

  await db.close();
}

class WhishlistDbModel {
  final String id;

  WhishlistDbModel({
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}

deleteWishListDB(id) async {
  M.Db db = await M.Db.create(
      "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
  await db.open();

  M.DbCollection collection = db.collection("favorite_locations");

  await collection.deleteOne({"id": id});
  await db.close();
}
