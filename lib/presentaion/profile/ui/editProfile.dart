import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../util/color/app_colors.dart';
import '../../../util/image_resource/image_resource.dart';
import '../../../widget/custom_appBar.dart';
import '../../../widget/custom_input.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/customImageView.dart';
import '../model/getProfileModel.dart';
import '../repo/profileRepo.dart';
import '../viewModel/profileViewModel.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController cityController;
  late TextEditingController dobController;
  late TextEditingController mobileController;

  File? selectedImage;
  final ImagePicker picker = ImagePicker();

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
    mobileController = TextEditingController();

    // Load profile data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfileDetailViewModel>(context, listen: false);
      provider.getProfileApi(context: context).then((_) {
        _fillInitialData(provider.getProfileModel);
      });
    });
  }

  void _fillInitialData(GetProfileModel? model) {
    if (model?.data?.user == null) return;

    final user = model!.data!.user!;

    nameController.text = user.name ?? '';
    emailController.text = user.email ?? '';
    cityController.text = ''; // API doesn't have city → leave empty or fetch from elsewhere
    mobileController.text = user.mobile ?? '';
    selectedGender = user.gender; // male / female / other
    dobController.text = _formatDateForDisplay(user.dob); // assuming you add dob in model

    setState(() {});
  }

  String _formatDateForDisplay(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return '';
    try {
      final date = DateTime.parse(isoDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return '';
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
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
              leading: const Icon(Icons.photo_library),
              title: const Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // UI format
      dobController.text = DateFormat('dd/MM/yyyy').format(picked);

      // API format
      dobApi = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _updateProfile(ProfileDetailViewModel provider) async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your name")),
      );
      return;
    }

    setState(() => isLoading = true);

    await provider.editProfileApi(
      context: context,
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      city: cityController.text.trim(),
      gender: selectedGender ?? '',
      dob: dobApi,//yyyy-mm-dd
      profilePic: selectedImage?.path ?? '',
    );

    setState(() => isLoading = false);

    if (provider.getProfileModel?.status == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
      Navigator.pop(context); // optional: go back after success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileDetailViewModel>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Edit Profile', isBack: true),
          body: provider.isLoading && provider.getProfileModel == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Photo
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 128,
                            width: 128,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(width: 3, color: Colors.white),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(width: 4, color:  Color(0xFF906B45)),
                              ),
                              child: ClipOval(
                                child: selectedImage != null
                                    ? Image.file(selectedImage!, fit: BoxFit.cover)
                                    : (provider.getProfileModel?.data?.user?.profilePic != null &&
                                    provider.getProfileModel!.data!.user!.profilePic!.isNotEmpty)
                                    ? CustomImageView(
                                  imagePath: provider.getProfileModel!.data!.user!.profilePic!,
                                  fit: BoxFit.cover,
                                  imageType:ImageType.network,
                                )
                                    : Image.asset("assets/images/person.png", fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Positioned(
                              bottom: 10,
                              right: 2,
                              child: GestureDetector(
                                onTap: _showImagePicker,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 3, color: Color(0xFF906B45)),
                                  ),
                                  child: Container(
                                      height: 30,
                                      width: 30,
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(999),
                                        color: ColorResource.white,
                                      ),

                                      child: Icon(Icons.edit)),
                                ),
                              ))
                        ],
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _showImagePicker,
                        child: CustomText(
                          'Change Photo',
                          size: 14,
                          weight: FontWeight.w600,
                          color: ColorResource.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Full Name
                CustomText('Full Name', size: 13, weight: FontWeight.w700),
                const SizedBox(height: 6),
                CustomInputBox(
                  controller: nameController,
                  hintText: 'Enter Full Name',
                ),

                const SizedBox(height: 16),

                // Email
                CustomText('Email Address', size: 13, weight: FontWeight.w700),
                const SizedBox(height: 6),
                CustomInputBox(
                  controller: emailController,
                  hintText: 'Enter Email',
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                // Mobile (read-only or editable?)
                CustomText('Mobile Number', size: 13, weight: FontWeight.w700),
                const SizedBox(height: 6),
                CustomInputBox(
                  controller: mobileController,
                  hintText: 'Mobile Number',
                  keyboardType: TextInputType.phone,
                  maxLength: 10,

                ),

                const SizedBox(height: 16),

                // City
                CustomText('City', size: 13, weight: FontWeight.w700),
                const SizedBox(height: 6),
                CustomInputBox(
                  controller: cityController,
                  hintText: 'Enter City',
                ),

                const SizedBox(height: 16),

                // Date of Birth
                CustomText('Date of Birth', size: 13, weight: FontWeight.w700),
                const SizedBox(height: 6),
                CustomInputBox(
                  controller: dobController,
                  hintText: 'DD/MM/YYYY',
                  type: InputType.date,
                  onTap: () {
                    _selectDate(context);
                  },
                ),

                const SizedBox(height: 16),

                // Gender Chips
                CustomText('Gender', size: 13, weight: FontWeight.w700),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: ['Male', 'Female', 'Other'].map((gender) {
                    final isSelected = selectedGender == gender.toLowerCase();
                    return ChoiceChip(
                      label: Text(gender),
                      selected: isSelected,
                      selectedColor: ColorResource.primary.withOpacity(0.2),
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: isSelected ? ColorResource.primary : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            selectedGender = gender.toLowerCase();
                          });
                        }
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 40),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : () => _updateProfile(provider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResource.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                        : const Text(
                      'Update Profile',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    cityController.dispose();
    dobController.dispose();
    mobileController.dispose();
    super.dispose();
  }
}