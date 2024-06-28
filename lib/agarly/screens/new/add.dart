import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

var db, homepage_collection;

class HomepageMongoDbModel {
  final String location;
  final String price;
  final String numberOfRooms;
  final String features;
  final String moreDetails;
  final String area;
  final String bathrooms;
  final String bedrooms;
  final String level;
  final String? image;

  HomepageMongoDbModel({
    required this.location,
    required this.price,
    required this.numberOfRooms,
    required this.features,
    required this.moreDetails,
    required this.area,
    required this.bathrooms,
    required this.bedrooms,
    required this.level,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'price': price,
      'numberOfRooms': numberOfRooms,
      'features': features,
      'moreDetails': moreDetails,
      'area': area,
      'bathrooms': bathrooms,
      'bedrooms': bedrooms,
      'level': level,
      'image': image,
    };
  }
}

class UploadDataPage extends StatefulWidget {
  const UploadDataPage({super.key});

  @override
  _UploadDataPageState createState() => _UploadDataPageState();
}

class _UploadDataPageState extends State<UploadDataPage> {
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController numberOfRoomsController = TextEditingController();
  final TextEditingController featuresController = TextEditingController();
  final TextEditingController moreDetailsController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController bathroomsController = TextEditingController();
  final TextEditingController bedroomsController = TextEditingController();
  final TextEditingController levelController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  String? _validateLocation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Location is required';
    }
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }
    if (double.tryParse(value) == null) {
      return 'Invalid price';
    }
    return null;
  }

  String? _validateNumberOfRooms(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of rooms is required';
    }
    if (int.tryParse(value) == null) {
      return 'Invalid number of rooms';
    }
    return null;
  }

  String? _validateFeatures(String? value) {
    if (value == null || value.isEmpty) {
      return 'Features are required';
    }
    return null;
  }

  String? _validateMoreDetails(String? value) {
    if (value == null || value.isEmpty) {
      return 'More details are required';
    }
    return null;
  }

  String? _validateArea(String? value) {
    if (value == null || value.isEmpty) {
      return 'Area is required';
    }
    if (double.tryParse(value) == null) {
      return 'Invalid area';
    }
    return null;
  }

  String? _validateBathrooms(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of bathrooms is required';
    }
    if (int.tryParse(value) == null) {
      return 'Invalid number of bathrooms';
    }
    return null;
  }

  String? _validateBedrooms(String? value) {
    if (value == null || value.isEmpty) {
      return 'Number of bedrooms is required';
    }
    if (int.tryParse(value) == null) {
      return 'Invalid number of bedrooms';
    }
    return null;
  }

  String? _validateLevel(String? value) {
    if (value == null || value.isEmpty) {
      return 'Level is required';
    }
    return null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _saveData() async {
    if (_formKey.currentState!.validate()) {
      String? base64Image;
      if (_image != null) {
        List<int> imageBytes = await _image!.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      await postHomepageData(
        locationController.text,
        priceController.text,
        numberOfRoomsController.text,
        featuresController.text,
        moreDetailsController.text,
        areaController.text,
        bathroomsController.text,
        bedroomsController.text,
        levelController.text,
        base64Image,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data saved successfully'),
        ),
      );
    }
  }

  Future<void> postHomepageData(
    String location,
    String price,
    String numberOfRooms,
    String features,
    String moreDetails,
    String area,
    String bathrooms,
    String bedrooms,
    String level,
    String? image,
  ) async {
    db = await M.Db.create(
        "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
    await db.open();
    inspect(db);

    homepage_collection = db.collection("home_page");
    final data = HomepageMongoDbModel(
      location: location,
      price: price,
      numberOfRooms: numberOfRooms,
      features: features,
      moreDetails: moreDetails,
      area: area,
      bathrooms: bathrooms,
      bedrooms: bedrooms,
      level: level,
      image: image,
    );
    await homepage_collection.insert(data.toJson());
    print(
        "Data updated: {location: $location, price: $price,  numberOfRooms: $numberOfRooms, features: $features, moreDetails: $moreDetails, area: $area, bathrooms: $bathrooms, bedrooms: $bedrooms, level: $level, image: $image}");
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: _pickImage,
                  child: _image == null
                      ? Icon(Icons.add_a_photo, size: 50)
                      : Image.file(
                          _image!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateLocation,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validatePrice,
                ),
                const SizedBox(height: 20.0),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: numberOfRoomsController,
                  decoration: const InputDecoration(
                    labelText: 'Number of Rooms',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                  validator: _validateNumberOfRooms,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: featuresController,
                  decoration: const InputDecoration(
                    labelText: 'Features',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: _validateFeatures,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: moreDetailsController,
                  decoration: const InputDecoration(
                    labelText: 'More Details',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: _validateMoreDetails,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: areaController,
                  decoration: const InputDecoration(
                    labelText: 'Area',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validateArea,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: bathroomsController,
                  decoration: const InputDecoration(
                    labelText: 'Bathrooms',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validateBathrooms,
                ),
                TextFormField(
                  controller: bathroomsController,
                  decoration: const InputDecoration(
                    labelText: 'samir',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: bedroomsController,
                  decoration: const InputDecoration(
                    labelText: 'Bedrooms',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validateBedrooms,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: levelController,
                  decoration: const InputDecoration(
                    labelText: 'Level',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validateLevel,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: _saveData,
                  child: const Text('Save Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
