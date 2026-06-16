// import 'package:flutter/material.dart';
// import 'package:mannfleet/util/color/app_colors.dart';
// import 'package:mannfleet/widget/custom_appBar.dart';
//
// import '../../../home/ui/model/shuttleShiftStopPageModel.dart';
//
// class ShuttleShiftScreen extends StatelessWidget {
//   final ShuttleShiftStopPageModel shuttleShiftStopPageModel;
//   const ShuttleShiftScreen({super.key,required this.shuttleShiftStopPageModel});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FB),
//       appBar: CustomAppBar(title: "Shuttle Routes",isBack: true,),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: shuttleShiftStopPageModel.data!.length,
//         itemBuilder: (context, index) {
//           var data=shuttleShiftStopPageModel.data![index];
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
//                       const Text(
//                         "Morning Express Shuttle",
//                         style: TextStyle(
//                           color: Color(0xFF1B1B1B),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       _priceTag("₹450 + GST"),
//                     ],
//                   ),
//
//                   const SizedBox(height: 14),
//
//                   /// ROUTE
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Column(
//                         children: [
//                           _dot(),
//                           _line(),
//                           _dot(),
//                         ],
//                       ),
//                       const SizedBox(width: 12),
//
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _locationTile(
//                               title: "Delhi ISBT",
//                               subtitle: "Departure: 06:30 AM",
//                             ),
//                             const SizedBox(height: 18),
//                             _locationTile(
//                               title: "Noida Sector 62",
//                               subtitle: "Arrival: 07:15 AM",
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 14),
//
//                   /// INTERMEDIATE
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
//                         const Text(
//                           "3 Intermediate Stops Available",
//                           style: TextStyle(
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
//                       onPressed: () {},
//                       child: const Text(
//                         "View Details",
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
//       height: 40,
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


import 'package:flutter/material.dart';
import 'package:mannfleet/util/color/app_colors.dart';
import 'package:mannfleet/widget/custom_appBar.dart';
import 'package:mannfleet/widget/navigator_method.dart';

import '../../../bottomBar/bottomBar.dart';
import '../../../home/ui/model/shuttleShiftStopPageModel.dart';
import 'choosePassScreen.dart';

class ShuttleShiftScreen extends StatefulWidget {
  final ShuttleShiftStopPageModel shuttleShiftStopPageModel;

  const ShuttleShiftScreen({
    super.key,
    required this.shuttleShiftStopPageModel,
  });

  @override
  State<ShuttleShiftScreen> createState() => _ShuttleShiftScreenState();
}

class _ShuttleShiftScreenState extends State<ShuttleShiftScreen> {
  int? expandedIndex;
  @override
  Widget build(BuildContext context) {
    final dataList = widget.shuttleShiftStopPageModel.data ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: CustomAppBar(title: "Shuttle Routes", isBack: true,

        // onBackTap: () {
        //   MainScreen.changeTab(context, 0);
        // },

      ),
      body: dataList.isEmpty
          ?  Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// ICON
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: ColorResource.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.route_rounded,
                size: 45,
                color: ColorResource.primary,
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            const Text(
              "No Routes Found",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            /// SUBTITLE
            const Text(
              "No routes found for given\nsource and destination",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 18),

            /// OPTIONAL BUTTON
            GestureDetector(
              onTap: (){
                navPop(context: context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: ColorResource.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.refresh_rounded,
                      color: ColorResource.primary,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Try Another Route",
                      style: TextStyle(
                        color:ColorResource.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final data = dataList[index];

          final source = data.source;
          final destination = data.destination;
          final stops = data.intermediateStops ?? [];

          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.shiftName ?? "N/A Shift",
                        style: const TextStyle(
                          color: Color(0xFF1B1B1B),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      _priceTag("₹${data.priceWithGst ?? 0}"),
                      // _priceTag("₹${data.totalPrice ?? 0}"),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// ROUTE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (expandedIndex == index) {
                              expandedIndex = null;
                            } else {
                              expandedIndex = index;
                            }
                          });
                        },
                        child: Column(
                          children: [
                            /// SOURCE DOT
                            _dot(),

                            /// LINE till next point
                            _line(),

                            /// INTERMEDIATE DOTS (dynamic)
                            if (expandedIndex == index)
                              ...List.generate(stops.length, (i) {
                                return Column(
                                  children: [
                                    _dot(),
                                    _line(),
                                  ],
                                );
                              }),

                            /// DESTINATION DOT
                            _dot(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),


                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              if (expandedIndex == index) {
                                expandedIndex = null;
                              } else {
                                expandedIndex = index;
                              }
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// SOURCE
                              _locationTile(
                                title: source?.name ?? "-",
                                subtitle: "Departure: ${source?.departureTime ?? '-'}",
                              ),

                              /// INTERMEDIATE STOPS (INLINE in same flow)
                              if (expandedIndex == index)
                                ...stops.map((stop) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: _locationTile(
                                      title: stop.name ?? "-",
                                      subtitle:
                                      "Arrival: ${stop.arrivalTime ?? '-'} | Departure: ${stop.departureTime ?? '-'}",
                                    ),
                                  );
                                }).toList(),

                              const SizedBox(height: 14),

                              /// DESTINATION
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

                  /// INTERMEDIATE STOPS
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorResource.primary.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: ColorResource.primary.withOpacity(0.15),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: ColorResource.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "${stops.length} Intermediate Stops Available",
                          style: const TextStyle(
                            color: Color(0xFF444444),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text("Journey Date : ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
                      Text(" ${data.date ?? "-"}",style: TextStyle(fontSize: 12),),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorResource.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        navPush(context: context, action: ChoosePassScreen(destination: destination?.name ?? "-",source: source?.name ?? "-",bookingDate: data.date ?? "-",shiftId:  data.shiftId ?? "-",));
                      },
                      child: const Text(
                        "Continue",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _locationTile({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF222222),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: Color(0xFF777777),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _dot() {
    return Container(
      height: 10,
      width: 10,
      decoration: BoxDecoration(
        color: ColorResource.primary,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _line() {
    return Container(
      height: 50,
      width: 2,
      color: ColorResource.primary.withOpacity(0.2),
    );
  }

  Widget _priceTag(String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ColorResource.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ColorResource.primary.withOpacity(0.2),
        ),
      ),
      child: Text(
        price,
        style: TextStyle(
          color: ColorResource.primary,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}