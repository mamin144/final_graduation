





import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCard extends StatefulWidget {
   const AddCard({super.key});

   @override
   State<AddCard> createState() => _AddCardState();
 }

   XFile? pickedImageXFile;
   XFile? pickedImageXFile2;
   XFile? pickedImageXFile3;
 class _AddCardState extends State<AddCard> {



   final ImagePicker _picker = ImagePicker();

//  final ImagePicker _picker2 = ImagePicker();
//   final ImagePicker _picker3 = ImagePicker();


   pickImage() async {

  pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(()  {
  });
     
   }
   pickImage2() async {
 pickedImageXFile2 = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
     
   });
     
    
   }

   pickImage3() async {
 pickedImageXFile3 = await _picker.pickImage(source: ImageSource.gallery);
   setState(()  {
     
   });
    
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body:Padding(
         padding: const EdgeInsets.all(8.0),
         child: ListView(children: [
           const SizedBox(height: 20,),
           const Text('اضف صورة البطاقة الامامية',
             style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
           const SizedBox(height: 10,),
           (pickedImageXFile != null)?Image.file(
             File(pickedImageXFile!.path),
             height: 200,
             width: 200,
           ):
           InkWell(
             child:const CircleAvatar(
               radius:71,
               child: Icon(Icons.image),
             ),
             onTap:(){
              pickImage();
              // setState(() {
                
              // });
              
              
             },
           ),
           const SizedBox(height:20,),
           const Text('اضف صورة البطاقة الخلفية ',
             style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
           const SizedBox(height: 10,),
           (pickedImageXFile2 != null)?Image.file(
             File(pickedImageXFile2!.path),
             height: 200,
             width: 200,
           ):
           InkWell(
             child:const CircleAvatar(
               radius:71,
               child: Icon(Icons.image),
             ),
             onTap:(){
               pickImage2();
             },
           ),
           const SizedBox(height:20,),
           const Text('اضف صورة عقد الشقة ',
             style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
           const SizedBox(height: 10,),
           (pickedImageXFile3 != null)?Image.file(
             File(pickedImageXFile3!.path),
             height: 200,
             width: 200,
           ):
           InkWell(
             child:const CircleAvatar(
               radius:71,
               child: Icon(Icons.image),
             ),
             onTap:(){
               pickImage3();
             },
           ),









         ],),
       ),
     );
   }
 }
