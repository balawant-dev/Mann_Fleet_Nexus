import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mannfleet/util/color/app_colors.dart';
import 'package:mannfleet/widget/custom_appBar.dart';
import 'package:mannfleet/widget/custom_button.dart';
import 'package:mannfleet/widget/custom_input.dart';
import 'package:mannfleet/widget/custom_text.dart';
import 'package:mannfleet/widget/navigator_method.dart';
import 'package:provider/provider.dart';
import '../../../widget/motionToastHelper.dart';
import '../../../widget/showLoaderFunction.dart';
import '../viewModel/complaintsPro.dart';
import 'complaintHistoryScreen.dart';

class NewComplaint extends StatefulWidget {
  const NewComplaint({super.key});

  @override
  State<NewComplaint> createState() => _NewComplaintState();
}

class _NewComplaintState extends State<NewComplaint> {

  final TextEditingController descriptionController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  File? imageFile;
  File? videoFile;
  List<File> imageFiles = [];
  // File? videoFile;
  String? selectedCategory;

  List<String> categories = [
    "Booking",
    "Driver",
    "Payment",
    "Other",

  ];
  TextEditingController issueController=TextEditingController();
  TextEditingController bioController=TextEditingController();


  Future pickImages() async {
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        imageFiles = images.map((e) => File(e.path)).toList();
      });
    }
  }

  Future pickVideo() async {
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        videoFile = File(video.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(title: 'Support',isBack: false,),

      bottomSheet: Container(
        color: Colors.white,
        height: 120,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            CustomButton(
              title: 'Submit Complaint',
              onTap: () {
                final provider = context.read<ComplaintsProvider>();
                showLoader(context);

                provider.createComplaint(
                  context: context,
                  issueCategory: getApiCategory(selectedCategory ?? ""),
                  description: bioController.text,
                  imageFiles: imageFiles.map((e) => e.path).toList(),
                  videoFiles: videoFile?.path ?? "",
                );
                // Navigator.pop(context);

              },
            ),SizedBox(height: 20,),   CustomButton(
              title: 'My Complaint',
              onTap: () {
          navPush(context: context, action: ComplaintHistoryScreen());
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              CustomText(
                'Formal Grievance',
                size: 22,
                weight: FontWeight.w700,
                color: ColorResource.black,
              ),

              const SizedBox(height: 8),
              CustomText(
                'Please provide detailed information about the incident. Our team will investigate and respond within 24–48 hours.',
                size: 12,
                weight: FontWeight.w400,
                color: ColorResource.textBlack,
              ),

              const SizedBox(height: 25),
              const Text(
                "Issue Category",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorResource.textColor,
                ),
              ),

              const SizedBox(height: 8),

              CustomInputBox(
                controller: issueController,
                hintText: 'Select a Category',
                type: InputType.dropdown, // 🔥 MUST
                dropdownItems: [
                  'Driver Issue',
                  'Bus Delay',
                  'Payment Issue',
                  'Other',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),

              const SizedBox(height: 20),

              const Text(
                "Description of Issue",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color:ColorResource.textColor,
                ),
              ),

              const SizedBox(height: 8),
              CustomInputBox(
                controller: bioController,
                hintText: 'Tell us exactly what happened',
                // maxLines: 5,

              ),

              const SizedBox(height: 20),

              const Text(
                "Upload Evidence",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color:ColorResource.textColor,
                ),
              ),

              const SizedBox(height: 15),
              SizedBox(
                height: 110,
                child: Row(
                  children: [
                    // ➕ ADD IMAGE BUTTON
                    GestureDetector(
                      onTap: pickImages,
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt_outlined, size: 30),
                            SizedBox(height: 5),
                            Text("Photos"),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // 🔥 IMAGE PREVIEW LIST
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: imageFiles.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    imageFiles[index],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                // ❌ REMOVE IMAGE
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        imageFiles.removeAt(index);
                                      });
                                    },
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(Icons.close,
                                          size: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              GestureDetector(
                onTap: pickVideo,
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: videoFile == null
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.videocam_outlined, size: 30),
                          SizedBox(height: 5),
                          Text("Video"),
                        ],
                      )
                          : const Center(
                        child: Icon(
                          Icons.videocam,
                          size: 40,
                          color: Colors.green,
                        ),
                      ),
                    ),

                    // ❌ REMOVE VIDEO
                    if (videoFile != null)
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              videoFile = null;
                            });
                          },
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,
                            child: Icon(Icons.close, size: 14, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Row(
              //   children: [
              //     GestureDetector(
              //       onTap: pickImages,
              //       child: Container(
              //         height: 100,
              //         width: 100,
              //         decoration: BoxDecoration(
              //           border: Border.all(color: Colors.grey.shade300),
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         child: imageFiles.isEmpty
              //             ? Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: const [
              //             Icon(Icons.camera_alt_outlined, size: 30),
              //             SizedBox(height: 5),
              //             Text("Photos"),
              //           ],
              //         )
              //             : const Icon(Icons.check_circle, color: Colors.green, size: 40),
              //       ),
              //     ),
              //
              //     const SizedBox(width: 12),
              //     GestureDetector(
              //       onTap: pickVideo,
              //       child: Container(
              //         height: 100,
              //         width: 100,
              //         decoration: BoxDecoration(
              //           border: Border.all(
              //             color: Colors.grey.shade300,
              //           ),
              //           borderRadius: BorderRadius.circular(12),
              //         ),
              //         child: videoFile == null
              //             ? Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: const [
              //             Icon(Icons.videocam_outlined, size: 30),
              //             SizedBox(height: 5),
              //             Text("Video"),
              //           ],
              //         )
              //             : const Center(
              //           child: Icon(
              //             Icons.check_circle,
              //             color: Colors.green,
              //             size: 40,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              const SizedBox(height: 10),

              const Text(
                "Max 5MB PNG, JPG, MP4",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
  String getApiCategory(String value) {
    switch (value) {
      case "Driver Issue":
        return "driver";
      case "Bus Delay":
        return "booking";
      case "Cleanliness":
        return "other";
      case "Safety":
        return "other";
      default:
        return "other";
    }
  }
}