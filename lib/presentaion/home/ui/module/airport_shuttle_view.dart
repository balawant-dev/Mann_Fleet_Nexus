
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mannfleet/util/color/app_colors.dart';

import 'package:mannfleet/widget/custom_button.dart';

import 'package:mannfleet/widget/navigator_method.dart';
import '../../../../shuttleModule/shuttleList/model/allUniqueStoppageModel.dart';
import '../../../../shuttleModule/shuttleList/ui/shuttleShiftScreen.dart';
import '../../../../widget/motionToastHelper.dart';
import '../../../../widget/showLoaderFunction.dart';


import '../../provider/homeProvider.dart';

import 'package:dropdown_search/dropdown_search.dart';

class AirportShuttleView extends StatefulWidget {
  final HomeProvider provider;
  final double screenHeight;
  final double screenWidth;
  final VoidCallback? onLocationFocus;
  //Onward Shifts, Return Shifts,

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [


        Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.all(12),
          decoration: ShapeDecoration(
            color: ColorResource.white,
            // color: ColorResource.white,
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,     color:   Colors.black,),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Find the best shuttleHistory routes across your city corridors.",
                    style: TextStyle(fontSize: 13,      color:   Colors.black,),
                  ),
                  SizedBox(height: 24),

              _buildLocationFields(),
              const SizedBox(height: 10),
Text("Select Journey Date",style: TextStyle(fontSize: 12,     color:   Colors.black,),),              const SizedBox(height: 5),
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
                       Icon(Icons.calendar_month,     color:   Colors.black,),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          displayDate,
                          style:  TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,     color:   Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text("Travel Type", style: TextStyle(fontSize: 12,     color:   Colors.black,)),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRadioOption("Single", "single"),
                  const SizedBox(width: 24),
                  _buildRadioOption("Both", "both"),
                ],
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
                    travelType: widget.provider.travelType,
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
                  navPush(context: context, action: ShuttleShiftScreen(shuttleShiftStopPageModel: widget.provider.shuttleShiftStopPageModel!,travelType:  widget.provider.travelType,));


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
  Widget _buildRadioOption(String title, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<String>(

          value: value,
          groupValue: widget.provider.travelType,           // From Provider
          activeColor: ColorResource.primary,
          fillColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.selected)) {
              return ColorResource.primary; // Selected color
            }
            return Colors.grey; // Inactive border color
          }),

          onChanged: (newValue) {
            if (newValue != null) {
              widget.provider.setTravelType(newValue);      // Update via Provider
            }
          },
        ),
        Text(title, style:  TextStyle(fontSize: 14,     color:   Colors.black,)),
      ],
    );
  }
  Widget _buildLocationFields() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // labelText: isSource ? "Select Pickup Location" : "Select Drop Location" ,
        Text("Select Pickup Location",style: TextStyle(fontSize: 12,     color:   Colors.black,),), const SizedBox(height: 5),
        /// SOURCE
        StoppageDropdown(
          provider: widget.provider,
          isSource: true,
        ),

        SizedBox(height: 10),Text("Select Drop Location",style: TextStyle(fontSize: 12,     color:   Colors.black,),), const SizedBox(height: 5),

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

          menuProps: const MenuProps(
            backgroundColor: Colors.white,
            // backgroundColor: Color(0xFF1E1E1E),
          ),

          searchFieldProps: TextFieldProps(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor:  Colors.white,
              // fillColor: const Color(0xFF2A2A2A),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
              hintText: "Search location...",
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),

          itemBuilder: (context, item, isDisabled, isSelected) {
            return Container(
              color:  Colors.white,
              // color: const Color(0xFF1E1E1E),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? "",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.address ?? "",
                    style:  TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Divider(color: Colors.grey.shade800),
                ],
              ),
            );
          },
        ),


        // popupProps: PopupProps.menu(
        //
        //   showSearchBox: true,
        //
        //   searchFieldProps: TextFieldProps(
        //     decoration: InputDecoration(fillColor: ColorResource.bgColor,
        //
        //       contentPadding: EdgeInsets.symmetric(vertical: 1,horizontal: 10),
        //       hintText: "Search location...",
        //       hintStyle: TextStyle(     color:   Colors.black,fontSize: 14),
        //       // border: OutlineInputBorder(
        //       //   gapPadding:
        //       // ),
        //
        //     ),
        //   ),
        //
        //   /// ✅ FIXED BUILDER (4 PARAMS)
        //   itemBuilder: (context, item, isDisabled, isSelected) {
        //     return Container(
        //       color: ColorResource.bgColor,
        //       padding: const EdgeInsets.symmetric(horizontal: 12.0),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Text(item.name ?? "",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500,     color:   Colors.black,),),
        //           Text(item.address ?? "",style: TextStyle(fontSize: 10,     color:   Colors.black,),),
        //           SizedBox(height: 5,),
        //           Divider()
        //         ],
        //       ),
        //     );
        //
        //     //   ListTile(
        //     //
        //     //
        //     //   title: Text(item.name ?? "",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
        //     //   subtitle: Text(item.address ?? "",style: TextStyle(fontSize: 10),),
        //     // );
        //   },
        // ),

        /// ✅ UI
        // decoratorProps: DropDownDecoratorProps(
        //
        //   decoration: InputDecoration(
        //     hintText: isSource ? "Select Pickup Location" : "Select Drop Location",
        //     hintStyle: TextStyle(     color:   Colors.black,fontSize: 12),
        //     // labelText: isSource ? "Select Pickup Location" : "Select Drop Location" ,
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(12),
        //     ),
        //   ),
        // ),
        dropdownBuilder: (context, selectedItem) {
          return Text(
            selectedItem?.name ??
                (isSource
                    ? "Select Pickup Location"
                    : "Select Drop Location"),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          );
        },decoratorProps: DropDownDecoratorProps(decoration: InputDecoration(suffixIconColor: Colors.white,))
        // decoratorProps: DropDownDecoratorProps(
        //
        //   decoration: InputDecoration(
        //     filled: true,
        //     fillColor: const Color(0xFF2A2A2A),
        //     hintText:
        //     isSource ? "Select Pickup Location" : "Select Drop Location",
        //     hintStyle: const TextStyle(
        //       color: Colors.grey,
        //       fontSize: 12,
        //     ),
        //     suffixIconColor: Colors.white,
        //     enabledBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(12),
        //       borderSide: const BorderSide(color: Colors.grey),
        //     ),
        //     focusedBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(12),
        //       borderSide: const BorderSide(color: Colors.blue),
        //     ),
        //   ),
        // ),
      ),
    );
  }

}