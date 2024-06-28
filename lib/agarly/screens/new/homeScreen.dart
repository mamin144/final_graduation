import 'package:flutter/material.dart';
import 'package:flutter_application_1/agarly/screens/new/Search.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

import 'HomeDrawer.dart';
import 'details_screen.dart';

class HomeScren extends StatefulWidget {
  @override
  _HomeScrenState createState() => _HomeScrenState();
}

class _HomeScrenState extends State<HomeScren> {
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
          _buildSearchBar(),
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
                              builder: (context) => DetailsScreen(
                                item,
                                image:
                                    'lib/pics/7d1e9881988591.5d107cb99ccd5.jpg', // Pass your image data here
                                des: '', // Pass your description data here
                                place: 'cairo', // Pass your place data here
                                price: '1000', // Pass your price data here
                                title: 'hello', // Pass your title data here
                              ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            // Your card content here

                            color: index % 2 == 0
                                ? Colors.grey[200]
                                : Colors
                                    .grey[300], // Alternate background colors
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _buildImageWidget(), // Show static photo
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Location: ${item['location']}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('Price: ${item['price']}'),
                                      Text('City: ${item['city']}'),
                                      Text(
                                          'Number of Rooms: ${item['numberOfRooms']}'),
                                      Text('Features: ${item['features']}'),
                                      Text(
                                          'More Details: ${item['moreDetails']}'),
                                      // Add more widgets to display other data fields as needed
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
                                          : const Icon(Icons.favorite_border),
                                      onPressed: () {
                                        setState(() {
                                          if (_isFavorite.isEmpty) {
                                            _isFavorite = List.generate(
                                                data.length, (_) => false);
                                          }
                                          _isFavorite[index] =
                                              !_isFavorite[index];
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
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

  Widget _buildSearchBar() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Material(
            borderRadius: BorderRadius.circular(32.0),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(32.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Search()),
                );
                // Handle search action
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(32.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 8.0,
                      spreadRadius: 8.0,
                      offset: const Offset(0.0, 4.0),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 8.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Where to?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Anywhere • Any week • Add guest',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    return Image.asset(
      'lib/pics/7d1e9881988591.5d107cb99ccd5.jpg', // Replace with your image path
      fit: BoxFit.cover,
      height: 200,
    );
  }
}
