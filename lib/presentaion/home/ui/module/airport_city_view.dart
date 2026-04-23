import 'package:flutter/material.dart';
import 'package:mannfleet/util/color/app_colors.dart';
import 'package:mannfleet/util/image_resource/image_resource.dart';
import 'package:mannfleet/widget/customImageView.dart';
import 'package:mannfleet/widget/custom_button.dart';
import 'package:mannfleet/widget/custom_text.dart';
import '../../../../widget/motionToastHelper.dart';
import '../../../../widget/navigator_method.dart';
import '../../../../widget/showLoaderFunction.dart';
import '../../../booking/ui/vehicleSelectionScreen.dart';
import '../../provider/homeProvider.dart';
import '../widget/buildDateTimeRow.dart';
import '../widget/buildDateTimeRowCompact.dart';
import '../widget/headerDetails.dart';
import '../widget/locationField.dart';


class AirportCityView extends StatelessWidget {
  final HomeProvider provider;
  final double screenHeight;
  final double screenWidth;

  const AirportCityView({
    super.key,
    required this.provider,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    final int wayIndex = provider.selectedWayIndex;
    final isOneWay = wayIndex == 0;
    final isRoundTrip = wayIndex == 1;
    final isHourly = wayIndex == 2;
    final isIntercity = wayIndex == 3;

    return Column(
      children: [
        // _buildHeader(provider: provider),
        SizedBox(height: screenHeight * 0.02),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: ShapeDecoration(
            color: ColorResource.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: ColorResource.homeOption),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubTabs(context),
              SizedBox(height: screenHeight * 0.018),
              _buildLocationFields(isHourly, isIntercity),
              const Divider(height: 24,color: Color(0xff94A3B8),thickness: 0.6,),
              // Divider(height: 1, color:  Color(0xff94A3B8)),
              _buildDateTimeSection(context, isHourly, isRoundTrip),
              const Divider(height: 24,color: Color(0xff94A3B8),thickness: 0.6,),

              const SizedBox(height: 30),
              CustomButton(
                title: isHourly
                    ? "Find Hourly Packages"
                    : isRoundTrip
                    ? "Find Round Trip Rides"
                    : isIntercity
                    ? "Search Intercity Rides"
                    : "Find Rides",
                onTap: () async {

                  /// ✅ Date Validation
                  if (provider.selectedApiDate.isEmpty) {
                    ToastHelper.show(
                      context,
                      message: "Select date",
                      type: ToastType.warning,
                    );
                    return;
                  }

                  /// ✅ Time Validation
                  if (provider.timeController.text.isEmpty) {
                    ToastHelper.show(
                      context,
                      message: "Select time",
                      type: ToastType.warning,
                    );
                    return;
                  }

                  /// ✅ Round Trip Validation
                  if (isRoundTrip) {
                    if (provider.selectedReturnApiDate.isEmpty) {
                      ToastHelper.show(
                        context,
                        message: "Select return date",
                        type: ToastType.warning,
                      );
                      return;
                    }

                    if (provider.returnTimeController.text.isEmpty) {
                      ToastHelper.show(
                        context,
                        message: "Select return time",
                        type: ToastType.warning,
                      );
                      return;
                    }
                  }

                  /// ✅ Pickup Validation
                  if (provider.pickupLat == null || provider.pickupLng == null) {
                    ToastHelper.show(
                      context,
                      message: "Select pickup location",
                      type: ToastType.warning,
                    );
                    return;
                  }

                  /// ✅ Drop Validation (skip for hourly)
                  if (!isHourly && (provider.dropLat == null || provider.dropLng == null)) {
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
                    final bookingType = isRoundTrip
                        ? "round_trip"
                        : isIntercity
                        ? "intercity"
                        : isHourly
                        ? "hourly"
                        : "one_way";

                    /// ✅ API Call
                    await provider.createBooking(
                      context: context,
                      bookingType: bookingType,
                    );

                    /// ✅ Close Loader Safely
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }

                    /// ✅ Success Toast
                    ToastHelper.show(
                      context,
                      message: "Fare estimates fetched successfully",
                      type: ToastType.success,
                    );

                    /// ✅ Navigate (Null Safe)
                    navPush(
                      context: context,
                      action: VehicleSelectionScreen(
                        pickupLat: provider.pickupLat!.toString(),
                        pickupLng: provider.pickupLng!.toString(),
                        dropLat: provider.dropLat?.toString() ?? "",
                        dropLng: provider.dropLng?.toString() ?? "",
                        scheduledDate: provider.selectedApiDate,
                        scheduledTime: provider.selectedApiTime,
                        toCity: provider.isSwapped ? provider.dropController.text : provider.pickupController.text,
                        returnDate: provider.selectedReturnApiDate,
                          returnTime: provider.selectedReturnApiTime,
                        selectedHours: provider.selectedHours.toString(),
                        tripDays: provider.tripDays.toString(),
                      ),
                    );

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
              )

            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader({
    required HomeProvider provider,
}) {
    return HeaderDetailScreen(   // ← yeh function abhi bhi HomeScreen mein hai
      screenHeight: screenHeight,
      provider: provider,
      screenWidth: screenWidth,
      image: AppImages.carImage,
      title: "Intercity Rides",
      subTitle: "Outstation travel at fixed prices",
      // title: isHourly
      //     ? 'Hourly Packages'
      //     : isIntercity
      //     ? 'Intercity Rides'
      //     : 'Reliable City Commute',
      // subTitle: isHourly
      //     ? 'Book by the hour • Free waiting time'
      //     : isIntercity
      //     ? 'Outstation travel at fixed prices'
      //     : 'Save 20% on your first airport trip this week.',
    );
  }

  Widget _buildSubTabs(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: ColorResource.homeOption,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(
          provider.tabsWay.length,
              (index) {
            final isSelected = provider.selectedWayIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => provider.changeWayTab(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      provider.tabsWay[index],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? ColorResource.textBlue : ColorResource.textBlack,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLocationFields(bool isHourly, bool isIntercity) {
    return Column(
      children: [
        LocationField(
          label: isHourly ? "PICKUP LOCATION" : "FROM",
          iconPath: AppImages.pickupImage,
          controller: provider.isSwapped ? provider.dropController : provider.pickupController,
          isPickup: !provider.isSwapped,
          height: 18,
          width: 18,

        ),
        if (!isHourly) ...[
          Row(
            children: [
              const Expanded(child:  Divider(height: 1, color:  Color(0xff94A3B8),thickness: 0.6,),),
              GestureDetector(
                onTap: provider.swapLocation,
                child: CustomImageView(
                  imagePath: AppImages.locationCross,
                  height: 35,
                  width: 35,
                ),
              ),
            ],
          ),
          LocationField(
            label: isIntercity ? "TO" : "DROP-OFF DESTINATION",
            iconPath: AppImages.locationImage,
            controller: provider.isSwapped ? provider.pickupController : provider.dropController,
            isPickup: provider.isSwapped,
            height: 15,
            width: 15,
          ),
        ],
      ],
    );
  }

  Widget _buildDateTimeSection(BuildContext context, bool isHourly, bool isRoundTrip) {

    if (isHourly) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => provider.pickDate(context),
                  child: BuildDateTimeRow(
                    icon: AppImages.calender,
                    label: "Pickup Date",
                    controller: provider.dateController,
                  ),
                ),
              ),   const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () => provider.pickTime(context),
                  child: BuildDateTimeRow(
                    icon: AppImages.timeImage,
                    label: "Pickup Time",
                    controller: provider.timeController,
                  ),
                ),
              ),
            ],
          ), const Divider(height: 24,color: Color(0xff94A3B8),thickness: 0.6,),

          const SizedBox(height: 8),
          _buildHourlyPackageSelector(provider),
        ],
      );
    }

    /// ✅ One Way + Intercity
    if (!isRoundTrip) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => provider.pickDate(context),
              child: BuildDateTimeRowCompact(
                title: "Pickup Date",
                icon: AppImages.calender,
                controller: provider.dateController,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => provider.pickTime(context),
              child: BuildDateTimeRowCompact(
                title: "Pickup Time",
                icon: AppImages.timeImage,
                controller: provider.timeController,
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
                onTap: () => provider.pickDate(context),
                child: BuildDateTimeRowCompact(
                  title: "Pickup Date",
                  icon: AppImages.calender,
                  controller: provider.dateController,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => provider.pickTime(context),
                child: BuildDateTimeRowCompact(
                  title: "Pickup Time",
                  icon: AppImages.timeImage,
                  controller: provider.timeController,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),    const Divider(height: 24,color: Color(0xff94A3B8),thickness: 0.6,),
        const SizedBox(height: 8),

        /// 🔥 Return Section
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => provider.pickReturnDate(context),
                child: BuildDateTimeRowCompact(
                  title:"Return Date" ,
                  icon: AppImages.calender,
                  controller: provider.returnDateController,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => provider.pickReturnTime(context),
                child: BuildDateTimeRowCompact(
                  title: "Return Time",
                  icon: AppImages.timeImage,
                  controller: provider.returnTimeController,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildHourlyPackageSelector(HomeProvider provider) {
    // You can make this dynamic later (API or list)
    final packages = ["4 hrs • 40 km", "6 hrs • 60 km", "8 hrs • 80 km", "12 hrs • 120 km"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Choose Package",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ColorResource.black,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: packages.map((pkg) {
            bool selected = provider.selectedHours == int.parse(pkg.split(" ")[0]);
            return GestureDetector(
              onTap: () {
                int hours = int.parse(pkg.split(" ")[0]);
                provider.setHours(hours);
                // TODO: save selected package
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? ColorResource.blueText.withOpacity(0.1) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: selected ? ColorResource.blueText : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  pkg,
                  style: TextStyle(
                    color: selected ? ColorResource.blueText : Colors.black87,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
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