import 'package:flutter/material.dart';
import 'package:mannfleet/util/color/app_colors.dart';
import 'package:mannfleet/util/image_resource/image_resource.dart';
import 'package:mannfleet/widget/customImageView.dart';
import 'package:mannfleet/widget/custom_button.dart';
import 'package:mannfleet/widget/custom_text.dart';
import '../../../../widget/motionToastHelper.dart';
import '../../../../widget/navigator_method.dart';
import '../../../../widget/showLoaderFunction.dart';
import '../../../booking/booking/ui/vehicleSelectionScreen.dart';

import '../../provider/homeProvider.dart';
import '../../widgets/customMessageDialog.dart';
import '../widget/buildDateTimeRow.dart';
import '../widget/buildDateTimeRowCompact.dart';
import '../widget/headerDetails.dart';
import '../widget/locationField.dart';

class AirportCityView extends StatefulWidget {
  final HomeProvider provider;
  final GlobalKey globalKey;
  final double screenHeight;
  final double screenWidth;
  final VoidCallback? onLocationFocus;
  final ScrollController? scrollController;

  const AirportCityView({
    super.key,
    required this.provider,
    required this.screenHeight,
    required this.screenWidth,
    required this.globalKey,
    this.onLocationFocus, // 👈 ADD
    this.scrollController,
  });

  @override
  State<AirportCityView> createState() => _AirportCityViewState();
}

class _AirportCityViewState extends State<AirportCityView> {
  void _scrollToTop() {
    widget.scrollController?.animateTo(
      0.0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// Initial Current Location
      if (widget.provider.pickupLat == null) {
        widget.provider.setCurrentLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int wayIndex = widget.provider.selectedWayIndex;
    final isOneWay = wayIndex == 0;
    final isIntercity = wayIndex == 1;
    final isRoundTrip = wayIndex == 2;
    final isHourly = wayIndex == 3;
    // final isOneWay = wayIndex == 0;
    // final isRoundTrip = wayIndex == 1;
    // final isHourly = wayIndex == 2;
    // final isIntercity = wayIndex == 3;
    return Column(
      children: [
        _buildHeader(provider: widget.provider),
        SizedBox(height: widget.screenHeight * 0.02),
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: ShapeDecoration(
            color:ColorResource.white,
            // color: ColorResource.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: ColorResource.homeOption),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubTabs(context: context, key: widget.globalKey),
              SizedBox(height: widget.screenHeight * 0.018),
              _buildLocationFields(isHourly, isIntercity),
              // const Divider(
              //   height: 24,
              //   color: Color(0xff94A3B8),
              //   thickness: 0.6,
              // ),
              // Divider(height: 1, color:  Color(0xff94A3B8)),
              _buildDateTimeSection(context, isHourly, isRoundTrip),

              // const Divider(
              //   height: 24,
              //   color: Color(0xff94A3B8),
              //   thickness: 0.6,
              // ),
              const SizedBox(height: 24),
              CustomButton(
                title:
                    isHourly
                        ? "Find Hourly Packages"
                        : isRoundTrip
                        ? "Find Round Trip Rides"
                        : isIntercity
                        ? "Search Intercity Rides"
                        : "Find Rides",
                onTap: () async {
                  /// ✅ Date Validation
                  if (widget.provider.selectedApiDate.isEmpty) {
                    ToastHelper.show(
                      context,
                      message: "Select date",
                      type: ToastType.warning,
                    );
                    return;
                  }

                  /// ✅ Time Validation
                  if (widget.provider.timeController.text.isEmpty) {
                    ToastHelper.show(
                      context,
                      message: "Select time",
                      type: ToastType.warning,
                    );
                    return;
                  }

                  /// ✅ Round Trip Validation
                  if (isRoundTrip) {
                    if (widget.provider.selectedReturnApiDate.isEmpty) {
                      ToastHelper.show(
                        context,
                        message: "Select return date",
                        type: ToastType.warning,
                      );
                      return;
                    }

                    if (widget.provider.returnTimeController.text.isEmpty) {
                      ToastHelper.show(
                        context,
                        message: "Select return time",
                        type: ToastType.warning,
                      );
                      return;
                    }
                  }

                  /// ✅ Pickup Validation
                  if (widget.provider.pickupLat == null ||
                      widget.provider.pickupLng == null) {
                    ToastHelper.show(
                      context,
                      message: "Select pickup location",
                      type: ToastType.warning,
                    );
                    return;
                  }
                  print("Brijesh print dropLat ${widget.provider.dropLat},dropLat ${widget.provider.dropLat} ,address ${widget.provider.dropController}");

                  /// ✅ Drop Validation (skip for hourly)
                  if (!isHourly &&
                      (widget.provider.dropLat == null ||
                          widget.provider.dropLng == null)) {
                    ToastHelper.show(
                      context,
                      message: "Select drop location",
                      type: ToastType.warning,
                    );
                    return;
                  }

                  /// ✅ Show Loader
                  showLoader(context);

                  try {
                    /// ✅ Booking Type
                    final bookingType =
                        isRoundTrip
                            ? "round_trip"
                            : isIntercity
                            ? "intercity"
                            : isHourly
                            ? "hourly"
                            : "one_way";

                    /// ✅ API Call
                    await widget.provider.createBooking(
                      context: context,
                      bookingType: bookingType,
                    );

                    /// ✅ Close Loader Safely
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }

            CustomMessageDialog.show(
                      context: context,
                      title: "Warning",
                      message: widget.provider.oneWayBookingModel?.message,
                      type: MessageType.warning,
                    );

                    /// ✅ Success Toast
                    // ToastHelper.show(
                    //   context,
                    //   message: widget.provider.oneWayBookingModel?.message,
                    //   // message: "Fare estimates fetched successfully",
                    //   type: ToastType.success,
                    // );
                    if (widget.provider.oneWayBookingModel!.status == true) {
                      Navigator.pop(context);
                      navPush(
                        context: context,
                        action: VehicleSelectionScreen(
                          pickupLat: widget.provider.pickupLat!.toString(),
                          pickupLng: widget.provider.pickupLng!.toString(),
                          dropLat: widget.provider.dropLat?.toString() ?? "",
                          dropLng: widget.provider.dropLng?.toString() ?? "",
                          scheduledDate: widget.provider.selectedApiDate,
                          scheduledTime: widget.provider.selectedApiTime,
                          toCity:
                              widget.provider.isSwapped
                                  ? widget.provider.dropController.text
                                  : widget.provider.pickupController.text,
                          returnDate: widget.provider.selectedReturnApiDate,
                          returnTime: widget.provider.selectedReturnApiTime,
                          selectedHours:
                              widget.provider.selectedHours.toString(),
                          tripDays: widget.provider.tripDays.toString(),
                        ),
                      );
                    }

                    /// ✅ Navigate (Null Safe)
                    // navPush(
                    //   context: context,
                    //   action: VehicleSelectionScreen(
                    //     pickupLat: widget.provider.pickupLat!.toString(),
                    //     pickupLng: widget.provider.pickupLng!.toString(),
                    //     dropLat: widget.provider.dropLat?.toString() ?? "",
                    //     dropLng: widget.provider.dropLng?.toString() ?? "",
                    //     scheduledDate: widget.provider.selectedApiDate,
                    //     scheduledTime: widget.provider.selectedApiTime,
                    //     toCity: widget.provider.isSwapped
                    //         ? widget.provider.dropController.text
                    //         : widget.provider.pickupController.text,
                    //     returnDate: widget.provider.selectedReturnApiDate,
                    //     returnTime: widget.provider.selectedReturnApiTime,
                    //     selectedHours: widget.provider.selectedHours.toString(),
                    //     tripDays: widget.provider.tripDays.toString(),
                    //   ),
                    // );
                  } catch (e) {
                    /// ❌ Error Handle
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }

                    ToastHelper.show(
                      context,
                      message: "Something went wrong",
                      type: ToastType.error,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader({required HomeProvider provider}) {
    return HeaderDetailScreen(
      // ← yeh function abhi bhi HomeScreen mein hai
      screenHeight: widget.screenHeight,
      provider: provider,
      screenWidth: widget.screenWidth,

    );
  }

  Widget _buildSubTabs({
    required BuildContext context,
    required GlobalKey key,
  }) {
    return Builder(
      builder: (context) {
        return Container(
          key: key,
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            gradient:  LinearGradient(
              colors: [
                ColorResource.primary,
                ColorResource.primarySec,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            // color: Color(0xfff2dfe0),
            // color: ColorResource.homeOption,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: List.generate(widget.provider.tabsWay.length, (index) {
              final isSelected = widget.provider.selectedWayIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => widget.provider.changeWayTab(index),
                  child: Container(
                    // duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        widget.provider.tabsWay[index],
                        style: TextStyle(
                          fontSize: 16,
                          // fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:        isSelected
                              ? ColorResource.primary
                              : Colors.white,
                          // color:
                          // isSelected
                          //     ? ColorResource.primary
                          //     : Colors.black.withOpacity(0.8),
                          // color:
                          //     isSelected
                          //         ? ColorResource.textBlue
                          //         : ColorResource.textBlack,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildLocationFields(bool isHourly, bool isIntercity) {
    return Column(
      children: [
        LocationField(
          label: isHourly ? "PICKUP LOCATION" : "FROM",
          iconPath: AppImages.pickupImage,
          controller:
              widget.provider.isSwapped
                  ? widget.provider.dropController
                  : widget.provider.pickupController,
          isPickup: !widget.provider.isSwapped,
          height: 18,

          width: 18,
          onFocus: widget.onLocationFocus,
        ),
        // SizedBox(height: 7,),
        if (!isHourly) ...[
          Row(
            children: [

              SizedBox(height: 10, width: 1),

            ],
          ),
          LocationField(
            label: isIntercity ? "TO" : "DROP-OFF DESTINATION",
            iconPath: AppImages.locationImage,
            controller:
                widget.provider.isSwapped
                    ? widget.provider.pickupController
                    : widget.provider.dropController,
            isPickup: widget.provider.isSwapped,
            height: 15,
            width: 15,
            onFocus: widget.onLocationFocus,
          ),
          // SizedBox(height: 7,),
        ],
      ],
    );
  }

  Widget _buildDateTimeSection(
    BuildContext context,
    bool isHourly,
    bool isRoundTrip,
  ) {
    if (isHourly) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    widget.provider.pickDate(context);
                  },
                  // onTap: () => widget.provider.pickDate(context),
                  child: BuildDateTimeRow(
                    icon: AppImages.calender,
                    label: "Pickup Date",
                    controller: widget.provider.dateController,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    widget.provider.pickTime(context);
                  },
                  // onTap: () => widget.provider.pickTime(context),
                  child: BuildDateTimeRow(
                    icon: AppImages.timeImage,
                    label: "Pickup Time",
                    controller: widget.provider.timeController,
                  ),
                ),
              ),
            ],
          ),

          // const Divider(height: 24, color: Color(0xff94A3B8), thickness: 0.6),
          const SizedBox(height: 8),
          _buildHourlyPackageSelector(widget.provider),
        ],
      );
    }

    /// ✅ One Way + Intercity
    if (!isRoundTrip) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                widget.provider.pickDate(context);
              },
              // onTap: () => widget.provider.pickDate(context),
              child: BuildDateTimeRowCompact(
                title: "Pickup Date",
                icon: AppImages.calender,
                controller: widget.provider.dateController,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                widget.provider.pickTime(context);
              },
              // onTap: () => widget.provider.pickTime(context),
              child: BuildDateTimeRowCompact(
                title: "Pickup Time",
                icon: AppImages.timeImage,
                controller: widget.provider.timeController,
              ),
            ),
          ),
        ],
      );
    }

    /// 🔥 ROUND TRIP UI
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  widget.provider.pickDate(context);
                },
                // onTap: () => widget.provider.pickDate(context),
                child: BuildDateTimeRowCompact(
                  title: "Pickup Date",
                  icon: AppImages.calender,
                  controller: widget.provider.dateController,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  widget.provider.pickTime(context);
                },
                // onTap: () => widget.provider.pickTime(context),
                child: BuildDateTimeRowCompact(
                  title: "Pickup Time",
                  icon: AppImages.timeImage,
                  controller: widget.provider.timeController,
                ),
              ),
            ),
          ],
        ),

        // const SizedBox(height: 8),
        // const Divider(height: 24, color: Color(0xff94A3B8), thickness: 0.6),
        // const SizedBox(height: 8),

        /// 🔥 Return Section
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  widget.provider.pickReturnDate(context);
                },
                // onTap: () => widget.provider.pickReturnDate(context),
                child: BuildDateTimeRowCompact(
                  title: "Return Date",
                  icon: AppImages.calender,
                  controller: widget.provider.returnDateController,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  widget.provider.pickReturnTime(context);
                },
                // onTap: () => widget.provider.pickReturnTime(context),
                child: BuildDateTimeRowCompact(
                  title: "Return Time",
                  icon: AppImages.timeImage,
                  controller: widget.provider.returnTimeController,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHourlyPackageSelector(HomeProvider provider) {
    final packages = provider.choosePackageModel?.data ?? [];

    if (packages.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: Text("No packages available")),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          "Choose Package",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black



            // color: ColorResource.black,
          ),
        ),
        const SizedBox(height: 12),

        Wrap(
          spacing: 10,
          runSpacing: 12,
          children:
              packages.map((pkg) {
                bool isSelected = provider.selectedHours == pkg.hours;

                return GestureDetector(
                  onTap: () {
                    if (pkg.hours != null) {
                      provider.setHours(
                        pkg.hours!,
                      ); // ← Model se hours set kar rahe hain
                      // Agar package ID bhi save karna hai toh yahan add kar sakte ho
                      // provider.setSelectedPackageId(pkg.sId);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? ColorResource.primarySec
                              : ColorResource.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color:
                            isSelected
                                ? ColorResource.primarySec
                                : Colors.black,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      pkg.name ?? "${pkg.hours} hrs • ${pkg.includedKms} km",
                      style: TextStyle(
                        fontSize: 14,
                        color:
                            isSelected
                                ? ColorResource.white
                                : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
