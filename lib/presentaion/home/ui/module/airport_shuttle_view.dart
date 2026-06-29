
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mannfleet/util/color/app_colors.dart';

import 'package:mannfleet/widget/custom_button.dart';

import 'package:mannfleet/widget/navigator_method.dart';
import '../../../../widget/motionToastHelper.dart';
import '../../../../widget/showLoaderFunction.dart';
import '../../../shuttleModule/shuttleList/model/allUniqueStoppageModel.dart';
import '../../../shuttleModule/shuttleList/ui/shuttleShiftScreen.dart';
import '../../provider/homeProvider.dart';

import 'package:dropdown_search/dropdown_search.dart';

class AirportShuttleView extends StatefulWidget {
  final HomeProvider provider;
  final double screenHeight;
  final double screenWidth;
  final VoidCallback? onLocationFocus;

  const AirportShuttleView({
    super.key,
    required this.provider,
    required this.screenHeight,
    required this.screenWidth,
    this.onLocationFocus,
  });

  @override
  State<AirportShuttleView> createState() => _AirportShuttleViewState();
}

class _AirportShuttleViewState extends State<AirportShuttleView> {
  DateTime? selectedDate;

  /// UI ke liye
  String get displayDate =>
      selectedDate == null
          ? "Select Journey Date"
          : DateFormat("dd-MM-yyyy").format(selectedDate!);

  /// API ke liye
  String get apiDate =>
      selectedDate == null
          ? ""
          : DateFormat("yyyy-MM-dd").format(selectedDate!);
  final List<String> imgList = [
    'https://www.shutterstock.com/image-vector/green-bus-ticket-male-passenger-600nw-2568648387.jpg',
    'https://t3.ftcdn.net/jpg/04/64/95/84/360_F_464958421_ANvZSiYNItJYlSHjnikzlELE4FC1e9BT.jpg',
    'https://www.shutterstock.com/image-vector/bus-ticket-online-pay-smart-600nw-2595978685.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [


        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(12),
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

                  Text(
                    "Where are you heading today?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Find the best shuttleHistory routes across your city corridors.",
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),

              _buildLocationFields(),
              const SizedBox(height: 10),
Text("Select Journey Date",style: TextStyle(fontSize: 12),),              const SizedBox(height: 5),
// dtret
              GestureDetector(
                onTap: () async {
                  final DateTime today = DateTime.now();

                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: today,
                    firstDate: today,
                    lastDate: today.add(const Duration(days: 20)),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          displayDate,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              //yha par date picker add karo ui me dd-mm-yyyy format me jaye aur api me  "yyyy-MM-dd" jaye calender pickuer today se lekr future date tak and cuurent date se 20 day tak select kar sakta hai ok
              const SizedBox(height: 28),

              CustomButton(
                title: "Find Shuttle",
                onTap: () async {
                  /// ✅ Pickup Validation
                  if (widget.provider.pickupLatShuttle == null ||
                      widget.provider.pickupLngShuttle == null) {
                    ToastHelper.show(
                      context,
                      message: "Select pickup location",
                      type: ToastType.warning,
                    );
                    return;
                  }

                  /// ✅ Drop Validation (skip for hourly)
                  if (widget.provider.dropLatShuttle == null || widget.provider.dropLngShuttle == null) {
                    ToastHelper.show(
                      context,
                      message: "Select drop location",
                      type: ToastType.warning,
                    );
                    return;
                  }
                  if (selectedDate == null) {
                    ToastHelper.show(
                      context,
                      message: "Select journey date",
                      type: ToastType.warning,
                    );
                    return;
                  }
                  /// ✅ Show Loader
                  showLoader(context);
                  await widget.provider.getShuttleShiftStopApi(
                    context: context,
                    destination: widget.provider.selectedDestination?.name ?? "",
                    source: widget.provider.selectedSource?.name ?? "",
                    date: apiDate,
                    // date: "yyyy-MM-dd"//ise dynamic karo ok
                  );

                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                  ToastHelper.show(
                    context,
                    message: "Upcoming shifts fetched successfully",
                    type: ToastType.success,
                  );
                  print("🎁🎁🎁🎁🎁🎁Yes ho gya hai complte ok");
                  navPush(context: context, action: ShuttleShiftScreen(shuttleShiftStopPageModel: widget.provider.shuttleShiftStopPageModel!,));


                },
              ),


            ],
          ),
        ),
        // SizedBox(height: 10,),//yha par gif add karunag
        // Image.asset("assets/images/shuttle.jpg"),
        // LoopVideoScreen(),


        SizedBox(height: 10,),

      ],
    );
  }

  Widget _buildLocationFields() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // labelText: isSource ? "Select Pickup Location" : "Select Drop Location" ,
        Text("Select Pickup Location",style: TextStyle(fontSize: 12),), const SizedBox(height: 5),
        /// SOURCE
        StoppageDropdown(
          provider: widget.provider,
          isSource: true,
        ),

        SizedBox(height: 10),Text("Select Drop Location",style: TextStyle(fontSize: 12),), const SizedBox(height: 5),

        /// DESTINATION
        StoppageDropdown(
          provider: widget.provider,
          isSource: false,
        ),
      ],
    );
  }
}

class StoppageDropdown extends StatelessWidget {
  final HomeProvider provider;
  final bool isSource;

  const StoppageDropdown({
    super.key,
    required this.provider,
    required this.isSource,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: DropdownSearch<AllUniqueStoppageData>(


        /// ✅ API CALL YAHI HOGA
        items: (filter, loadProps) async {
          await provider.getStoppageNameApi(
            context: context,
            search: filter,
          );
          return provider.allUniqueStoppageModel?.data ?? [];
        },

        /// ✅ STRING SHOW
        itemAsString: (item) => item.name ?? "",

        /// ✅ SELECT
        onChanged: (value) {
          if (value == null) return;

          if (isSource) {
            provider.setSource(value);
          } else {
            provider.setDestination(value);
          }
        },

        /// ✅ SELECTED VALUE
        selectedItem: isSource
            ? provider.selectedSource
            : provider.selectedDestination,

        /// ✅ IMPORTANT (compareFn required)
        compareFn: (item1, item2) =>
        item1.name == item2.name,

        popupProps: PopupProps.menu(

          showSearchBox: true,

          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 1,horizontal: 10),
              hintText: "Search location...",
              hintStyle: TextStyle(color: Colors.black45,fontSize: 14),
              // border: OutlineInputBorder(
              //   gapPadding:
              // ),

            ),
          ),

          /// ✅ FIXED BUILDER (4 PARAMS)
          itemBuilder: (context, item, isDisabled, isSelected) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name ?? "",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                  Text(item.address ?? "",style: TextStyle(fontSize: 10),),
                  SizedBox(height: 5,),
                  Divider()
                ],
              ),
            );

            //   ListTile(
            //
            //
            //   title: Text(item.name ?? "",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
            //   subtitle: Text(item.address ?? "",style: TextStyle(fontSize: 10),),
            // );
          },
        ),

        /// ✅ UI
        decoratorProps: DropDownDecoratorProps(

          decoration: InputDecoration(
            hintText: isSource ? "Select Pickup Location" : "Select Drop Location",
            hintStyle: TextStyle(color: Colors.black45,fontSize: 12),
            // labelText: isSource ? "Select Pickup Location" : "Select Drop Location" ,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}