//
//
//
// import 'package:flutter/material.dart';
// import 'package:mannfleet/util/color/app_colors.dart';
// import 'package:mannfleet/widget/custom_appBar.dart';
// import 'package:mannfleet/widget/navigator_method.dart';
//
// import '../../../bottomBar/bottomBar.dart';
// import '../../../home/ui/model/shuttleShiftStopPageModel.dart';
// import 'choosePassScreen.dart';
//
// class ShuttleShiftScreen extends StatefulWidget {
//   final ShuttleShiftStopPageModel shuttleShiftStopPageModel;
//   final String travelType;//single or both
//
//   const ShuttleShiftScreen({
//     super.key,
//     required this.shuttleShiftStopPageModel,
//     required this.travelType
//   });
//
//   @override
//   State<ShuttleShiftScreen> createState() => _ShuttleShiftScreenState();
// }
//
// class _ShuttleShiftScreenState extends State<ShuttleShiftScreen> {
//   int? expandedIndex;
//   @override
//   Widget build(BuildContext context) {
//     final dataList = widget.shuttleShiftStopPageModel.data ?? [];
//     final dataReturnShiftsList = widget.shuttleShiftStopPageModel.returnShifts ?? [];
//     final bool isBoth = widget.travelType.toLowerCase() == "both";
//     //ager travelType =sigle aaya to ui yaise hi rhega but ager both rahega to tab bana padega Onward Shifts, and Return Shifts,Onward Shifts,wo jo current me list hai wo dikega  Return Shifts, me dataReturnShiftsList ye and design pardt ko separte kar lo yha par sirf dta rakhan hoga ui dono tab ka same hai data bhi same hi hai ok
//
//
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FB),
//       appBar: CustomAppBar(title: "Shuttle Routes", isBack: true,
//
//         // onBackTap: () {
//         //   MainScreen.changeTab(context, 0);
//         // },
//
//       ),
//       body: dataList.isEmpty
//           ?  Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//
//             /// ICON
//             Container(
//               height: 90,
//               width: 90,
//               decoration: BoxDecoration(
//                 color: ColorResource.primary.withOpacity(0.08),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.route_rounded,
//                 size: 45,
//                 color: ColorResource.primary,
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             /// TITLE
//             const Text(
//               "No Routes Found",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             /// SUBTITLE
//             const Text(
//               "No routes found for given\nsource and destination",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 15,
//                 height: 1.5,
//                 color: Colors.grey,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//
//             const SizedBox(height: 18),
//
//             /// OPTIONAL BUTTON
//             GestureDetector(
//               onTap: (){
//                 navPop(context: context);
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 18,
//                   vertical: 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: ColorResource.primary.withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       Icons.refresh_rounded,
//                       color: ColorResource.primary,
//                       size: 18,
//                     ),
//                     SizedBox(width: 8),
//                     Text(
//                       "Try Another Route",
//                       style: TextStyle(
//                         color:ColorResource.primary,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       )
//           : ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: dataList.length,
//         itemBuilder: (context, index) {
//           final data = dataList[index];
//
//           final source = data.source;
//           final destination = data.destination;
//           final stops = data.intermediateStops ?? [];
//
//           return Container(
//             margin: const EdgeInsets.only(bottom: 15),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.06),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 )
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// HEADER
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         data.shiftName ?? "N/A Shift",
//                         style: const TextStyle(
//                           color: Color(0xFF1B1B1B),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       _priceTag("₹${data.priceWithGst ?? 0}"),
//                       // _priceTag("₹${data.totalPrice ?? 0}"),
//                     ],
//                   ),
//
//                   const SizedBox(height: 14),
//
//                   /// ROUTE
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           setState(() {
//                             if (expandedIndex == index) {
//                               expandedIndex = null;
//                             } else {
//                               expandedIndex = index;
//                             }
//                           });
//                         },
//                         child: Column(
//                           children: [
//                             /// SOURCE DOT
//                             _dot(),
//
//                             /// LINE till next point
//                             _line(),
//
//                             /// INTERMEDIATE DOTS (dynamic)
//                             if (expandedIndex == index)
//                               ...List.generate(stops.length, (i) {
//                                 return Column(
//                                   children: [
//                                     _dot(),
//                                     _line(),
//                                   ],
//                                 );
//                               }),
//
//                             /// DESTINATION DOT
//                             _dot(),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//
//
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: (){
//                             setState(() {
//                               if (expandedIndex == index) {
//                                 expandedIndex = null;
//                               } else {
//                                 expandedIndex = index;
//                               }
//                             });
//                           },
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               /// SOURCE
//                               _locationTile(
//                                 title: source?.name ?? "-",
//                                 subtitle: "Departure: ${source?.departureTime ?? '-'}",
//                               ),
//
//                               /// INTERMEDIATE STOPS (INLINE in same flow)
//                               if (expandedIndex == index)
//                                 ...stops.map((stop) {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(top: 14),
//                                     child: _locationTile(
//                                       title: stop.name ?? "-",
//                                       subtitle:
//                                       "Arrival: ${stop.arrivalTime ?? '-'} | Departure: ${stop.departureTime ?? '-'}",
//                                     ),
//                                   );
//                                 }).toList(),
//
//                               const SizedBox(height: 14),
//
//                               /// DESTINATION
//                               _locationTile(
//                                 title: destination?.name ?? "-",
//                                 subtitle: "Arrival: ${destination?.arrivalTime ?? '-'}",
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 14),
//
//                   /// INTERMEDIATE STOPS
//                   Container(
//                     padding: const EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: ColorResource.primary.withOpacity(0.06),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                         color: ColorResource.primary.withOpacity(0.15),
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.location_on,
//                           color: ColorResource.primary,
//                           size: 18,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           "${stops.length} Intermediate Stops Available",
//                           style: const TextStyle(
//                             color: Color(0xFF444444),
//                             fontSize: 13,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 12),
//                   Row(
//                     children: [
//                       Text("Journey Date : ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
//                       Text(" ${data.date ?? "-"}",style: TextStyle(fontSize: 12),),
//                     ],
//                   ),
//                   const SizedBox(height: 12),
//
//                   /// BUTTON
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorResource.primary,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       onPressed: () {
//                         navPush(context: context, action: ChoosePassScreen(destination: destination?.name ?? "-",source: source?.name ?? "-",bookingDate: data.date ?? "-",shiftId:  data.shiftId ?? "-",));
//                       },
//                       child: const Text(
//                         "Continue",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _locationTile({required String title, required String subtitle}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             color: Color(0xFF222222),
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           subtitle,
//           style: const TextStyle(
//             color: Color(0xFF777777),
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _dot() {
//     return Container(
//       height: 10,
//       width: 10,
//       decoration: BoxDecoration(
//         color: ColorResource.primary,
//         borderRadius: BorderRadius.circular(20),
//       ),
//     );
//   }
//
//   Widget _line() {
//     return Container(
//       height: 50,
//       width: 2,
//       color: ColorResource.primary.withOpacity(0.2),
//     );
//   }
//
//   Widget _priceTag(String price) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: ColorResource.primary.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(
//           color: ColorResource.primary.withOpacity(0.2),
//         ),
//       ),
//       child: Text(
//         price,
//         style: TextStyle(
//           color: ColorResource.primary,
//           fontWeight: FontWeight.w700,
//           fontSize: 12,
//         ),
//       ),
//     );
//   }
// }














//
//
//
// import 'package:flutter/material.dart';
// import 'package:mannfleet/util/color/app_colors.dart';
// import 'package:mannfleet/widget/custom_appBar.dart';
// import 'package:mannfleet/widget/navigator_method.dart';
//
// import '../../../bottomBar/bottomBar.dart';
// import '../../../home/ui/model/shuttleShiftStopPageModel.dart';
// import 'choosePassScreen.dart';
//
// class ShuttleShiftScreen extends StatefulWidget {
//   final ShuttleShiftStopPageModel shuttleShiftStopPageModel;
//   final String travelType; // "single" or "both"
//
//   const ShuttleShiftScreen({
//     super.key,
//     required this.shuttleShiftStopPageModel,
//     required this.travelType,
//   });
//
//   @override
//   State<ShuttleShiftScreen> createState() => _ShuttleShiftScreenState();
// }
//
// class _ShuttleShiftScreenState extends State<ShuttleShiftScreen>
//     with SingleTickerProviderStateMixin {
//   int? expandedIndex;
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.travelType.toLowerCase() == "both") {
//       _tabController = TabController(length: 2, vsync: this);
//     }
//   }
//
//   @override
//   void dispose() {
//     if (widget.travelType.toLowerCase() == "both") {
//       _tabController.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dataList = widget.shuttleShiftStopPageModel.data ?? [];
//     final returnDataList = widget.shuttleShiftStopPageModel.returnShifts ?? [];
//
//     final bool isBoth = widget.travelType.toLowerCase() == "both";
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FB),
//       appBar: CustomAppBar(
//         title: "Shuttle Routes",
//         isBack: true,
//       ),
//       body: isBoth
//           ? Column(
//         children: [
//           Container(
//             color: Colors.white,
//             child: TabBar(
//               controller: _tabController,
//               labelColor: ColorResource.primary,
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: ColorResource.primary,
//               tabs: const [
//                 Tab(text: "Onward Shifts"),
//                 Tab(text: "Return Shifts"),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildShiftList(dataList, "Onward"),
//                 _buildShiftList(returnDataList, "Return"),
//               ],
//             ),
//           ),
//         ],
//       )
//           : _buildShiftList(dataList, "Single"),
//     );
//   }
//
//   Widget _buildShiftList(List<dynamic> shifts, String type) {
//     if (shifts.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               height: 90,
//               width: 90,
//               decoration: BoxDecoration(
//                 color: ColorResource.primary.withOpacity(0.08),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.route_rounded,
//                 size: 45,
//                 color: ColorResource.primary,
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               "No Routes Found",
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "No routes found for given\nsource and destination",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 15,
//                 height: 1.5,
//                 color: Colors.grey,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 18),
//             GestureDetector(
//               onTap: () => navPop(context: context),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 18,
//                   vertical: 10,
//                 ),
//                 decoration: BoxDecoration(
//                   color: ColorResource.primary.withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 child: const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(Icons.refresh_rounded,
//                         color: ColorResource.primary, size: 18),
//                     SizedBox(width: 8),
//                     Text(
//                       "Try Another Route",
//                       style: TextStyle(
//                         color: ColorResource.primary,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//
//     return ListView.builder(
//       padding: const EdgeInsets.all(12),
//       itemCount: shifts.length,
//       itemBuilder: (context, index) {
//         final data = shifts[index];
//
//         final source = data.source;
//         final destination = data.destination;
//         final stops = data.intermediateStops ?? [];
//
//         return Container(
//           margin: const EdgeInsets.only(bottom: 15),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.06),
//                 blurRadius: 12,
//                 offset: const Offset(0, 6),
//               )
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(14),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// HEADER
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       data.shiftName ?? "N/A Shift",
//                       style: const TextStyle(
//                         color: Color(0xFF1B1B1B),
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     _priceTag("₹${data.priceWithGst ?? 0}"),
//                   ],
//                 ),
//
//                 const SizedBox(height: 14),
//
//                 /// ROUTE
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     InkWell(
//                       onTap: () => _toggleExpand(index),
//                       child: Column(
//                         children: [
//                           _dot(),
//                           _line(),
//                           if (expandedIndex == index)
//                             ...List.generate(stops.length, (i) {
//                               return Column(
//                                 children: [_dot(), _line()],
//                               );
//                             }),
//                           _dot(),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//
//                     Expanded(
//                       child: GestureDetector(
//                         onTap: () => _toggleExpand(index),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _locationTile(
//                               title: source?.name ?? "-",
//                               subtitle: "Departure: ${source?.departureTime ?? '-'}",
//                             ),
//
//                             if (expandedIndex == index)
//                               ...stops.map((stop) {
//                                 return Padding(
//                                   padding: const EdgeInsets.only(top: 14),
//                                   child: _locationTile(
//                                     title: stop.name ?? "-",
//                                     subtitle:
//                                     "Arrival: ${stop.arrivalTime ?? '-'} | Departure: ${stop.departureTime ?? '-'}",
//                                   ),
//                                 );
//                               }).toList(),
//
//                             const SizedBox(height: 14),
//
//                             _locationTile(
//                               title: destination?.name ?? "-",
//                               subtitle: "Arrival: ${destination?.arrivalTime ?? '-'}",
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 const SizedBox(height: 14),
//
//                 /// INTERMEDIATE STOPS INFO
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: ColorResource.primary.withOpacity(0.06),
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: ColorResource.primary.withOpacity(0.15),
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.location_on,
//                           color: ColorResource.primary, size: 18),
//                       const SizedBox(width: 6),
//                       Text(
//                         "${stops.length} Intermediate Stops Available",
//                         style: const TextStyle(
//                           color: Color(0xFF444444),
//                           fontSize: 13,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     const Text("Journey Date : ",
//                         style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
//                     Text(" ${data.date ?? "-"}",
//                         style: const TextStyle(fontSize: 12)),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//
//                 /// CONTINUE BUTTON
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: ColorResource.primary,
//                       elevation: 0,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                     onPressed: () {
//                       navPush(
//                         context: context,
//                         action: ChoosePassScreen(
//                           destination: destination?.name ?? "-",
//                           source: source?.name ?? "-",
//                           bookingDate: data.date ?? "-",
//                           shiftId: data.shiftId ?? "-",
//                           travelType: widget.travelType,
//                           returnShiftId:data.shiftId ?? "-" ,
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "Continue",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   void _toggleExpand(int index) {
//     setState(() {
//       expandedIndex = expandedIndex == index ? null : index;
//     });
//   }
//
//   Widget _locationTile({required String title, required String subtitle}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(
//             color: Color(0xFF222222),
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           subtitle,
//           style: const TextStyle(
//             color: Color(0xFF777777),
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _dot() {
//     return Container(
//       height: 10,
//       width: 10,
//       decoration: BoxDecoration(
//         color: ColorResource.primary,
//         borderRadius: BorderRadius.circular(20),
//       ),
//     );
//   }
//
//   Widget _line() {
//     return Container(
//       height: 50,
//       width: 2,
//       color: ColorResource.primary.withOpacity(0.2),
//     );
//   }
//
//   Widget _priceTag(String price) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: ColorResource.primary.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: ColorResource.primary.withOpacity(0.2)),
//       ),
//       child: Text(
//         price,
//         style: TextStyle(
//           color: ColorResource.primary,
//           fontWeight: FontWeight.w700,
//           fontSize: 12,
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:mannfleet/util/color/app_colors.dart';
import 'package:mannfleet/widget/custom_appBar.dart';
import 'package:mannfleet/widget/navigator_method.dart';


import '../../../presentaion/home/ui/model/shuttleShiftStopPageModel.dart';
import '../../../presentaion/home/widgets/customMessageDialog.dart';
import 'choosePassScreen.dart';

class ShuttleShiftScreen extends StatefulWidget {
  final ShuttleShiftStopPageModel shuttleShiftStopPageModel;
  final String travelType; // "single" or "both"

  const ShuttleShiftScreen({
    super.key,
    required this.shuttleShiftStopPageModel,
    required this.travelType,
  });

  @override
  State<ShuttleShiftScreen> createState() => _ShuttleShiftScreenState();
}

class _ShuttleShiftScreenState extends State<ShuttleShiftScreen>
    with SingleTickerProviderStateMixin {
  int? expandedIndex;
  late TabController _tabController;

  // Selection States
  int? selectedOnwardIndex;
  int? selectedReturnIndex;

  @override
  void initState() {
    super.initState();
    if (widget.travelType.toLowerCase() == "both") {
      _tabController = TabController(length: 2, vsync: this);
    }
  }

  @override
  void dispose() {
    if (widget.travelType.toLowerCase() == "both") {
      _tabController.dispose();
    }
    super.dispose();
  }

  bool get isSelectionComplete {
    final bool isBoth = widget.travelType.toLowerCase() == "both";
    if (isBoth) {
      return selectedOnwardIndex != null && selectedReturnIndex != null;
    } else {
      return selectedOnwardIndex != null;
    }
  }

  void _onContinue() {
    if (!isSelectionComplete) return;

    final dataList = widget.shuttleShiftStopPageModel.data ?? [];
    final returnList = widget.shuttleShiftStopPageModel.returnShifts ?? [];

    final selectedOnward = dataList[selectedOnwardIndex!];
    final selectedReturn = widget.travelType.toLowerCase() == "both"
        ? returnList[selectedReturnIndex!]
        : null;

    print("destination : ${ selectedOnward.destination?.name ?? "-"}");
    print("source : ${ selectedOnward.source?.name ?? "-"}");
    print("bookingDate : ${ selectedOnward.date ?? "-"}");
    print("shiftId : ${ selectedOnward.shiftId ?? "-"}");
    print("travelType : ${ widget.travelType}");
    print("returnShiftId : ${ selectedReturn?.shiftId ?? "-"}");

    navPush(
      context: context,
      action: ChoosePassScreen(
        destination: selectedOnward.destination?.name ?? "-",
        source: selectedOnward.source?.name ?? "-",
        bookingDate: selectedOnward.date ?? "-",
        shiftId: selectedOnward.shiftId ?? "-",
        travelType: widget.travelType,
        returnShiftId: selectedReturn?.shiftId ?? "-",
        // You can pass more data if needed
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isBoth = widget.travelType.toLowerCase() == "both";
    final dataList = widget.shuttleShiftStopPageModel.data ?? [];
    final returnDataList = widget.shuttleShiftStopPageModel.returnShifts ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: CustomAppBar(title: "Shuttle Routes", isBack: true),
      body: isBoth
          ? Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: ColorResource.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: ColorResource.primary,
              tabs: const [
                Tab(text: "Onward Shifts"),
                Tab(text: "Return Shifts"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildShiftList(dataList, "Onward", isOnward: true),
                _buildShiftList(returnDataList, "Return", isOnward: false),
              ],
            ),
          ),
        ],
      )
          : _buildShiftList(dataList, "Single", isOnward: true),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildShiftList(List<dynamic> shifts, String type, {required bool isOnward}) {
    if (shifts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: ColorResource.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.route_rounded, size: 45, color: ColorResource.primary),
            ),
            const SizedBox(height: 20),
            const Text("No Routes Found", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text(
              "No routes found for given\nsource and destination",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: shifts.length,
      itemBuilder: (context, index) {
        final data = shifts[index];
        final source = data.source;
        final destination = data.destination;
        final stops = data.intermediateStops ?? [];

        final bool isSelected = isOnward
            ? selectedOnwardIndex == index
            : selectedReturnIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              if (isOnward) {
                selectedOnwardIndex = selectedOnwardIndex == index ? null : index;
              } else {
                selectedReturnIndex = selectedReturnIndex == index ? null : index;
              }
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Colors.red : Colors.transparent,
                width: isSelected ? 2 : 0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.shiftName ?? "N/A Shift",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      _priceTag("₹${data.priceWithGst ?? 0}"),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => _toggleExpand(index),
                        child: Column(children: [
                          _dot(),
                          _line(),
                          if (expandedIndex == index)
                            ...List.generate(stops.length, (_) => Column(children: [_dot(), _line()])),
                          _dot(),
                        ]),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _toggleExpand(index),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _locationTile(
                                title: source?.name ?? "-",
                                subtitle: "Departure: ${source?.departureTime ?? '-'}",
                              ),
                              if (expandedIndex == index)
                                ...stops.map((stop) => Padding(
                                  padding: const EdgeInsets.only(top: 14),
                                  child: _locationTile(
                                    title: stop.name ?? "-",
                                    subtitle:
                                    "Arrival: ${stop.arrivalTime ?? '-'} | Departure: ${stop.departureTime ?? '-'}",
                                  ),
                                )),
                              const SizedBox(height: 14),
                              _locationTile(
                                title: destination?.name ?? "-",
                                subtitle: "Arrival: ${destination?.arrivalTime ?? '-'}",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorResource.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColorResource.primary.withOpacity(0.15)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: ColorResource.primary, size: 18),
                        const SizedBox(width: 6),
                        Text("${stops.length} Intermediate Stops Available",
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text("Journey Date : ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      Text(" ${data.date ?? "-"}", style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomButton() {
    final bool isBoth = widget.travelType.toLowerCase() == "both";
    final String buttonText = isSelectionComplete
        ? "Continue"
        : (isBoth ? "Please select both shift" : "Please select a shift");
    // final String buttonText = isSelectionComplete
    //     ? "Continue"
    //     : (isBoth ? "Please select one Onward & one Return shift" : "Please select a shift");

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -2))],
        ),
        child: ElevatedButton(
          onPressed: isSelectionComplete ? _onContinue : (){
            CustomMessageDialog.show(
              context: context,
              title: "Warning",
              message: isBoth ? "Please select one Onward & one Return shift" : "Please select a shift",
              type: MessageType.warning,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelectionComplete ? ColorResource.primary : Colors.grey,
            minimumSize: const Size(double.infinity, 45),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _toggleExpand(int index) {
    setState(() {
      expandedIndex = expandedIndex == index ? null : index;
    });
  }

  // Reusable widgets
  Widget _locationTile({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Color(0xFF222222), fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Color(0xFF777777), fontSize: 12)),
      ],
    );
  }

  Widget _dot() => Container(height: 10, width: 10, decoration: BoxDecoration(color: ColorResource.primary, borderRadius: BorderRadius.circular(20)));

  Widget _line() => Container(height: 50, width: 2, color: ColorResource.primary.withOpacity(0.2));

  Widget _priceTag(String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ColorResource.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorResource.primary.withOpacity(0.2)),
      ),
      child: Text(price, style: TextStyle(color: ColorResource.primary, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }
}