import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mannfleet/util/color/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../widget/custom_appBar.dart';
import '../../../../widget/custom_button.dart';
import '../../../../widget/custom_input.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/motionToastHelper.dart';
import '../../../../widget/navigator_method.dart';
import '../../../../widget/showLoaderFunction.dart';
import '../../../bottomBar/bottomBar.dart';
import '../../../profile/viewModel/profileViewModel.dart';

class RegistrationScreen extends StatefulWidget {
  final String mobile;

  const RegistrationScreen({super.key, required this.mobile});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final picker = ImagePicker();

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController cityController;
  late TextEditingController dobController;
  late TextEditingController mobileController;

  File? selectedImage;

  String? selectedGender;
  String dobApi = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();

    emailController = TextEditingController();

    cityController = TextEditingController();

    dobController = TextEditingController();

    mobileController = TextEditingController(text: widget.mobile);
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();

    final maxDate = DateTime(now.year - 14, now.month, now.day);

    final initialDate = DateTime(now.year - 18, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: maxDate,
    );

    if (picked != null) {
      dobController.text = DateFormat('dd/MM/yyyy').format(picked);

      dobApi = DateFormat('yyyy-MM-dd').format(picked);

      setState(() {});
    }
  }

  Future<void> _submit(ProfileDetailViewModel provider) async {
    if (nameController.text.trim().isEmpty) {
      ToastHelper.show(context, message: "Enter name", type: ToastType.warning);
      return;
    }   if (emailController.text.trim().isEmpty) {
      ToastHelper.show(context, message: "Enter email", type: ToastType.warning);
      return;
    }

    // if (dobApi.isEmpty) {
    //   ToastHelper.show(context, message: "Select DOB", type: ToastType.warning);
    //   return;
    // }

    if (selectedGender == null) {
      ToastHelper.show(
        context,
        message: "Select gender",
        type: ToastType.warning,
      );
      return;
    }

    showLoader(context);

    await provider.editProfileApi(
      context: context,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      city: cityController.text.trim(),
      gender: selectedGender!,
      dob: dobApi,
      profilePic: selectedImage?.path ?? '',
    );

    Navigator.pop(context);

    if (provider.getProfileModel?.status == true) {
      ToastHelper.show(
        context,
        message: "Registration completed",
        type: ToastType.success,
      );

      navPushBottomRemove(
        context: context,
        action: const MainScreen(currentIndex: 0),
        duration: 100,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileDetailViewModel>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: const CustomAppBar(title: "Register", isBack: false),

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Center(
                  child: GestureDetector(
                    onTap: _showPicker,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 52,
                          backgroundImage:
                          selectedImage != null ? FileImage(selectedImage!) : null,
                          child: selectedImage == null
                              ? const Icon(Icons.camera_alt, size: 32)
                              : null,
                        ),

                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: ColorResource.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Center(
                //   child: GestureDetector(
                //     onTap: _showPicker,
                //     child: CircleAvatar(
                //       radius: 52,
                //       backgroundImage: selectedImage != null
                //           ? FileImage(selectedImage!)
                //           : null,
                //       child: selectedImage == null
                //           ? const Icon(Icons.camera_alt, size: 32)
                //           : null,
                //     ),
                //   ),
                // ),

                const SizedBox(height: 30),

                CustomText("Full Name"),
                const SizedBox(height: 6),

                CustomInputBox(
                  controller: nameController,
                  hintText: "Enter name",
                ),

                const SizedBox(height: 16),

                CustomText("Mobile"),
                const SizedBox(height: 6),

                IgnorePointer(
                  child: CustomInputBox(
                    controller: mobileController,
                    // enabled:
                    // false,
                    hintText: "Mobile",
                    maxLength: 10,
                    
                    
                  ),
                ),

                const SizedBox(height: 16),

                CustomText("Email"),
                const SizedBox(height: 6),

                CustomInputBox(controller: emailController, hintText: "Email"),
                const SizedBox(height: 16),

                CustomText("Gender"),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 10,
                  children: ["Male", "Female", "Other"].map((gender) {
                    return ChoiceChip(
                      label: Text(gender),
                      selected: selectedGender == gender.toLowerCase(),
                      onSelected: (val) {
                        setState(() {
                          selectedGender = gender.toLowerCase();
                        });
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                CustomText("City (Optional)"),
                const SizedBox(height: 6),

                CustomInputBox(controller: cityController, hintText: "City"),

                const SizedBox(height: 16),

                CustomText("Date of Birth (Optional)"),
                const SizedBox(height: 6),

                CustomInputBox(
                  controller: dobController,
                  hintText: "DD/MM/YYYY",
                  type: InputType.date,
                  onTap: () {
                    _selectDate(context);
                  },
                ),



                const SizedBox(height: 40),

                CustomButton(title: "Continue", onTap: () => _submit(provider)),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
