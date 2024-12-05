import 'dart:developer';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:tradingapp/ApiServices/apiservices.dart';

import 'package:tradingapp/Profile/CustomerSupport/Model/catagory_fetch_model.dart';
import 'package:tradingapp/Profile/CustomerSupport/Model/create_ticket_model.dart';
import 'package:tradingapp/Utils/const.dart/app_colors_const.dart';
import 'package:tradingapp/Utils/const.dart/custom_textformfield.dart';

class HelpDeskScreen extends StatefulWidget {
  const HelpDeskScreen({super.key});

  @override
  State<HelpDeskScreen> createState() => _HelpDeskScreenState();
}

class _HelpDeskScreenState extends State<HelpDeskScreen> {
  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'webp', 'mov', 'heic'],
    );

    if (result != null) {
      List<PlatformFile> files = result.files;
      for (var file in files) {
        log('Picked file: ${file.name}, Size: ${file.size}, Path: ${file.path}');
        if (file.path != null) {
          selectedImages.add(File(file.path!));
        }
      }
      setState(() {}); // Update the UI to display the selected images
    } else {
      log('User canceled the picker');
    }
  }

  List<File> selectedImages = [];

  List<String> problemCategoryList = [];
  List<String> subjectList = [];
  String problemCategory = '';
  String categoryID = "";
  String subcategoriesID = "";
  TicketData result = TicketData();
  TextEditingController titleController= TextEditingController();
  TextEditingController descriptionController= TextEditingController();
  
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        result = await ApiService.createTicketApiService() as TicketData;
        log('widget result :: $result');
        setState(() {
          print('result :: ${result.toJson()}');
          result.toJson().forEach(
            (key, value) {
              print('key :: $key , value :: $value');
              problemCategoryList.add(key);
            },
          );
        });
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        Column(
          children: [
            CustomButton(
              isLoading: false,
              onPressed: () {
                print("======================${problemCategoryList.toString()}");
            
                final createTicketModel = CreateTicketModel(
                  categoryId: categoryID.toString(),
                  subcategory_id: subcategoriesID.toString(),
                  title:titleController.text
                      , // Assuming you have a TextEditingController for title
                  description:
                      descriptionController.text, // Assuming you have a TextEditingController for description
                  clientId: 'A0031',
                  clientEmail: 'yash@gmail.com',
                );
            
                ApiService().CreateSupportTicket(createTicketModel);
              },
              text: 'Create Ticket',
            ),
            SizedBox(
              height: 10,
            ),
          ],
        )
      ],
      appBar: buildAppBar(),
      body: KeyboardDismisser(
        gestures: [
          GestureType.onTap,
          GestureType.onPanUpdateDownDirection,
        ],
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Problem Category',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                DropdownButtonFormField(
                  padding: EdgeInsets.all(5),
                  icon: const SizedBox(),
                  hint: const Text('Select Problem Category'),
                  items: problemCategoryList.map((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      problemCategory = "";
                      problemCategory = value ?? '';

                      var data = result.toJson();
                      subjectList.clear();
                      categoryID = data[value]['categoryId'].toString();
                      for (var element in data[value]['subcategories']) {
                        log('element :: $element');
                        subjectList.add(element['subcategoryName'] ?? '');
                      }
                    });
                    log('Selected Problem ID  Category: $value and ID  $categoryID');
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  'Select Subcatagory',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButtonFormField(
                  icon: const SizedBox(),
                  hint: const Text('Write Subcatagory'),
                  items: problemCategory.isEmpty
                      ? []
                      : subjectList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      var selectedSubcategory = result
                          .toJson()[problemCategory]['subcategories']
                          .firstWhere(
                              (element) => element['subcategoryName'] == value);
                      setState(() {
                        subcategoriesID =
                            selectedSubcategory['subcategoryId'].toString();
                      });
                      log('Selected Subject: $value, ID: ${selectedSubcategory['subcategoryId']}');
                    }
                  },
                ),
                SizedBox(height: 10),
                Text("Title"),
                SizedBox(height: 10),
                TextFormField(
                  focusNode: FocusNode(),
          controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Write Title',
                    
                  ),
                ),
                const SizedBox(height: 10),
                Text("Description"),
                SizedBox(height: 10),
                TextFormField(controller: descriptionController,
                  focusNode: FocusNode(),
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Write Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Upload Image',
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    pickFiles();
                  },
                  child: DottedBorder(
                    color: AppColors.primaryColorDark2,
                    strokeWidth: 1,
                    borderType: BorderType.RRect,
                    radius: Radius.circular(5),
                    dashPattern: [6, 3],
                    child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedAttachment01,
                            color: AppColors.primaryColorDark2,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Pick Files",
                            style:
                                TextStyle(color: AppColors.primaryColorDark2),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                GridView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          child: Image.file(
                            selectedImages[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedImages.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.green),
                              // color: Colors.black54,
                              child: Icon(
                                HugeIcons.strokeRoundedMultiplicationSignCircle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Help Desk'),
    );
  }
}
