import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart' as M;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Property Search App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Search(),
    );
  }
}

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController priceController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void dispose() {
    priceController.dispose();
    areaController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Property Search',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 5, 7, 87),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/pics/apartment2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Card(
              margin: EdgeInsets.all(20.0),
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: locationController,
                      decoration: InputDecoration(
                        labelText: 'Location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: areaController,
                      decoration: InputDecoration(
                        labelText: 'Area',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        performSearchAndRecommend();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 5, 7, 87),
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: Text(
                        'Search and Recommend',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> performSearchAndRecommend() async {
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            color: Color.fromARGB(255, 202, 188, 188),
            padding: EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    String price = priceController.text;
    String area = areaController.text;
    String location = locationController.text;
    int beedroom = 3;
    // Call Flask endpoint
    var url = Uri.parse('http://192.168.1.4:5000/recommend');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'price': price, 'area': area, 'bedrooms': beedroom}),
    );

    // Dismiss loading indicator
    Navigator.pop(context);

    print('Flask Response status: ${response.statusCode}');
    print('Flask Response body: ${response.body}');

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        // Tag the Flask property with a unique key
        data[0]['fromFlask'] = true;

        String objectId = data[0]['_id'];
        print('Object ID from Flask: $objectId');

        // Fetch data from MongoDB using the object ID and location
        List<Map<String, dynamic>> mongoData =
            await getSearchData(location, price);

        // Combine Flask and MongoDB data
        List<Map<String, dynamic>> combinedData = [...data, ...mongoData];

        // Navigate to the results page with combined data
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultPage(data: combinedData),
          ),
        );
      } else {
        // Handle no data returned
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('No Results'),
              content: Text('No properties found matching your criteria.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // Handle failed request
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Failed to fetch data from Flask (${response.statusCode}).'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<List<Map<String, dynamic>>> getSearchData(
      String location, String price) async {
    M.Db db = await M.Db.create(
        "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
    await db.open();
    var coll = db.collection('home_page');
    List<Map<String, dynamic>> result =
        await coll.find({'location': location, 'price': price}).toList();

    await db.close();
    return result;
  }
}

class SearchResultPage extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const SearchResultPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: ListView.builder(
        itemCount: data.length + 1, // +1 for the "Recommended" text
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Recommended',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          var property = data[index - 1];

          String imageBase64 = property['image'] ?? '';
          Uint8List? imageBytes;

          if (imageBase64.isNotEmpty) {
            imageBytes = base64Decode(imageBase64);
          }

          // Determine if property is from Flask
          bool isFromFlask = property.containsKey('fromFlask') &&
              property['fromFlask'] == true;
          return Card(
            color: isFromFlask ? Colors.green : Colors.white,
            margin: const EdgeInsets.all(10.0),
            elevation: 5.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFromFlask ? 'Recommended for you' : '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    _buildImageWidget(property, context),
                    SizedBox(height: 10.0),
                    Text(
                      'Location: ${property['location'] ?? 'Location not available'}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      'Area: ${property['area'] ?? 'Area not available'}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'Price: ${property['price'] ?? 'Price not available'}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'Bathrooms: ${property['bathrooms'] ?? 'Bathrooms not available'}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'Bedrooms: ${property['bedrooms'] ?? 'Bedrooms not available'}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'Levels: ${property['level'] ?? 'Level not available'}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'More details: ${property['features'] ?? 'Features not available'}',
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageWidget(Map<String, dynamic> item, BuildContext context) {
    final imageBase64 = item['image'] ?? '';
    if (imageBase64.isEmpty) {
      return Container(
        height: 200,
        color: Colors.grey,
        child: Center(child: Text('No Image Available')),
      );
    }

    final Uint8List imageBytes = base64Decode(imageBase64);
    return Image.memory(imageBytes, height: 200, fit: BoxFit.cover);
  }
}
