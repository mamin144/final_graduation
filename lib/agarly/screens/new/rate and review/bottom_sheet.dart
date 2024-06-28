import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;



var db, rate_review_collection;

class RateREviewMongoDbModel {
  
  final double rate;
  final String review;
  

  RateREviewMongoDbModel({
    required this.rate,
    required this.review,
   
  });

  Map<String, dynamic> toJson() {
    return {
      'rate': rate,
      'review': review,
    };
  }
}



class RatingBusinessBottomSheet extends StatefulWidget {
  const RatingBusinessBottomSheet({Key? key}) : super(key: key);


  @override
  State<RatingBusinessBottomSheet> createState() => _RatingBusinessBottomSheetState();
}

class _RatingBusinessBottomSheetState extends State<RatingBusinessBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  double? ratingValue;

  final TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("What is you rate ?",style: TextStyle(fontWeight: FontWeight.bold,fontSize:22 )),
            const SizedBox(height: 12,),
            RatingBar(
              minRating: 1,
              glow: true,
              allowHalfRating: true,
              ratingWidget: RatingWidget(
                  full: const Icon(Icons.star, color: Colors.amber),
                  half: const Icon(Icons.star_half, color: Colors.amber),
                  empty: const Icon(Icons.star_border, color: Colors.grey)),
              onRatingUpdate: (double value) {
                ratingValue = value;
              },
            ),
            const SizedBox(height: 25,),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Text("Please Share your opinion about the product ?",
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize:22,),textAlign: TextAlign.center),
            ),
            const SizedBox(height: 40,),
            Form(
              key: _formKey,
              child: TextFormField(
                style: const TextStyle(fontSize: 14),
                controller: reviewController,
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
                  hintText: "Enter your review ",
                  fillColor: Colors.grey[300],
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.black)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.red)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.grey)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Colors.grey)),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Review cannot be empty ! ';
                  }
                  postRateReviewData(ratingValue!,value);
                  print("-------------------------------------");
                  print(ratingValue);
                  print(value);
                  print("-------------------------------------");

                  return 'Successful';
                },
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) {
                  _onSubmitButtonPressed(context);
                  print("asdfadsfasfasdfasdfasdfadsf");
                  
                  // _formKey.currentState!.validate();
                },
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(onPressed: (){
              _onSubmitButtonPressed(context);
            },style:  ButtonStyle(backgroundColor: const MaterialStatePropertyAll(Color(0xFFD5354C)),
                minimumSize: MaterialStateProperty.all(Size(MediaQuery.sizeOf(context).width, 48))),
              child: const Text("SEND REVIEW",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
          ],
        ),
      ),
    );
  }

  void _onSubmitButtonPressed(BuildContext context) {

    if(_formKey.currentState!.validate()){
      

    }
    else{

    }
  }
}

Future<void> postRateReviewData(
    double rate,
    String review,
   
  ) async {
    // Your code to post homepage data to MongoDB
    db = await M.Db.create(
        "mongodb+srv://mohamed:ZZc4ZCN3hKYm6c8d@cluster0.md6blws.mongodb.net/booking_app");
    await db.open();
    inspect(db);

    rate_review_collection = db.collection("rate_review");
    final data = RateREviewMongoDbModel(
      rate: rate,
      review: review,
      
    );
    await rate_review_collection.insert(data.toJson());
  }
