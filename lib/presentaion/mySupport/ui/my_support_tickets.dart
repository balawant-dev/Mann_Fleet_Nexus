// import 'package:flutter/material.dart';
// import 'package:mannfleet/widget/custom_button.dart';
// import 'package:mannfleet/widget/custom_text.dart';
//
// import '../../../util/color/app_colors.dart';
// import '../../../util/image_resource/image_resource.dart';
// import '../../../widget/customImageView.dart';
// class MySupportTickets extends StatefulWidget {
//   const MySupportTickets({super.key});
//
//   @override
//   State<MySupportTickets> createState() => _MySupportTicketsState();
// }
//
// class _MySupportTicketsState extends State<MySupportTickets> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Support Tickets'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//             padding: EdgeInsets.all(15),
//           child: Column(
//             children: [
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 width: MediaQuery.of(context).size.width,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: ColorResource.homeOption,
//                 ),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     hintText: 'Search FAQs, ride issues...',
//                     prefixIcon: Padding(
//                       padding: const EdgeInsets.all(12),
//                       child: CustomImageView(
//                         imagePath: AppImages.searchImage,
//                         height: 18,
//                         width: 18,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     prefixIconConstraints: const BoxConstraints(
//                       minHeight: 18,
//                       minWidth: 18,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 10,),
//               SupportCard(),
//               SizedBox(height: 20,),
//               CustomButton(title: 'New Support Ticket', onTap: (){})
//             ],
//           ),
//         ),
//       ),
//
//     );
//   }
//   Widget SupportCard(){
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: ShapeDecoration(
//         color: ColorResource.white,
//         shape: RoundedRectangleBorder(
//           side: BorderSide(
//             width: 1,
//             color: ColorResource.homeOption,
//           ),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         shadows: [
//           BoxShadow(
//             color: Color(0x0C000000),
//             blurRadius: 2,
//             offset: Offset(0, 1),
//             spreadRadius: 0,
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 children: [
//                   CustomText(
//                     'TICKET ID',
//                     size: 10,
//                     weight: FontWeight.w700,
//                     color: ColorResource.textBlack,
//                   ),
//                   CustomText(
//                     '#MN-45920',
//                     size: 14,
//                     weight: FontWeight.w700,
//                     color: ColorResource.black,
//                   )
//                 ],
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Color(0xFFFFEDD5),
//                 ),
//                 child: CustomText(
//                   'Under Review',
//                   size: 11,
//                   weight: FontWeight.w700,
//                   color: ColorResource.orange,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 20,),
//           Row(
//             children: [
//               CustomImageView(
//                 imagePath: AppImages.refund,
//                 height: 13,
//                 width: 18,
//                 fit: BoxFit.cover,
//               ),
//               SizedBox(width: 10,),
//               CustomText(
//                 'Refund for Cancelled Ride',
//                 size: 14,
//                 weight: FontWeight.w500,
//                 color: ColorResource.textBlack,
//               )
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               CustomText(
//                 'Submitted on Oct 24, 2023 • 02:30 PM',
//                 size: 11,
//                 weight: FontWeight.w400,
//                 color: ColorResource.textBlack,
//               ),
//               Icon(Icons.arrow_forward_ios,size: 15,color: ColorResource.textBlack,)
//             ],
//           )
//
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:mannfleet/widget/custom_appBar.dart';
import 'package:mannfleet/widget/custom_button.dart';
import 'package:mannfleet/widget/custom_text.dart';

import '../../../util/color/app_colors.dart';
import '../../../util/image_resource/image_resource.dart';
import '../../../widget/customImageView.dart';

class MySupportTickets extends StatefulWidget {
  const MySupportTickets({super.key});

  @override
  State<MySupportTickets> createState() => _MySupportTicketsState();
}

class _MySupportTicketsState extends State<MySupportTickets> {

  List tickets = [
    {
      "id": "#MN-45920",
      "title": "Refund for Cancelled Ride",
      "date": "Submitted on Oct 24, 2023 • 02:30 PM",
      "status": "Under Review",
      "icon": AppImages.refund
    },
    {
      "id": "#MN-45811",
      "title": "Driver Conduct Issue",
      "date": "Submitted on Oct 22, 2023 • 09:15 AM",
      "status": "Action Taken",
      "icon": AppImages.refund
    },
    {
      "id": "#MN-45704",
      "title": "Wallet Top-up Issue",
      "date": "Submitted on Oct 18, 2023 • 11:45 AM",
      "status": "Resolved",
      "icon": AppImages.refund
    },
    {
      "id": "#MN-45662",
      "title": "Airport Booking Inquiry",
      "date": "Submitted on Oct 15, 2023 • 04:20 PM",
      "status": "Resolved",
      "icon": AppImages.refund
    }
  ];

  Color getStatusColor(String status) {
    if (status == "Under Review") {
      return const Color(0xFFFFEDD5);
    } else if (status == "Action Taken") {
      return const Color(0xFFDCE7FF);
    } else {
      return const Color(0xFFDFF5E3);
    }
  }

  Color getStatusTextColor(String status) {
    if (status == "Under Review") {
      return ColorResource.orange;
    } else if (status == "Action Taken") {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My Support Tickets'),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorResource.homeOption,
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search by Ticket ID or category...',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CustomImageView(
                      imagePath: AppImages.searchImage,
                      height: 18,
                      width: 18,
                      fit: BoxFit.cover,
                    ),
                  ),
                  prefixIconConstraints:
                  const BoxConstraints(minHeight: 18, minWidth: 18),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: tickets.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SupportCard(
                      id: tickets[index]["id"],
                      title: tickets[index]["title"],
                      date: tickets[index]["date"],
                      status: tickets[index]["status"],
                      icon: tickets[index]["icon"],
                    ),
                  );
                },
              ),
            ),

            /// Button
            CustomButton(
              title: 'New Support Ticket',
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }

  Widget SupportCard({
    required String id,
    required String title,
    required String date,
    required String status,
    required String icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: ColorResource.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: ColorResource.homeOption,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Column(
        children: [

          /// Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    'TICKET ID',
                    size: 10,
                    weight: FontWeight.w700,
                    color: ColorResource.textBlack,
                  ),
                  CustomText(
                    id,
                    size: 14,
                    weight: FontWeight.w700,
                    color: ColorResource.black,
                  )
                ],
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: getStatusColor(status),
                ),
                child: CustomText(
                  status,
                  size: 11,
                  weight: FontWeight.w700,
                  color: getStatusTextColor(status),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          /// Title Row
          Row(
            children: [
              CustomImageView(
                imagePath: icon,
                height: 16,
                width: 18,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomText(
                  title,
                  size: 14,
                  weight: FontWeight.w500,
                  color: ColorResource.textBlack,
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          /// Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                date,
                size: 11,
                weight: FontWeight.w400,
                color: ColorResource.textBlack,
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: ColorResource.textBlack,
              )
            ],
          )
        ],
      ),
    );
  }
}