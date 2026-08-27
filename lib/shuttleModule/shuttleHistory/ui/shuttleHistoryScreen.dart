import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../widget/custom_appBar.dart';

import '../viewModel/shuttleHistoryViewModel.dart';

class ShuttleHistoryScreen extends StatefulWidget {
  const ShuttleHistoryScreen({super.key});

  @override
  State<ShuttleHistoryScreen> createState() => _ShuttleHistoryScreenState();
}

class _ShuttleHistoryScreenState extends State<ShuttleHistoryScreen> {
  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() {
    final vm = Provider.of<ShuttleHistoryViewModel>(context, listen: false);

    vm.getShuttleHistoryApi(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        isBack: true,
        title: "Shuttle History",
        onActionTap: () {
          print("Setting clicked");
        },
        // onBackTap: () {
        //   MainScreen.changeTab(context, 0);
        // },
      ),

      body: Consumer<ShuttleHistoryViewModel>(
        builder: (context, pro, child) {
          if (pro.shuttleHistoryModel == null ||
              pro.shuttleHistoryModel!.data == null) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.height,
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (pro.shuttleHistoryModel!.data!.isEmpty) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.height,
              child: Center(child: Text("No Shuttle History Found")),
            );
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Wallet Card
                ListView.builder(
                  itemCount: pro.shuttleHistoryModel!.data!.length,
                  // padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final item = pro.shuttleHistoryModel!.data![index];
                    print("Time ${item.checkIn!.time}");
                    // final item = pro.shuttleHistoryModel!.data![index];

                    DateTime checkInTime = DateTime.parse(item.checkIn!.time!);

                    String formattedDate = DateFormat('dd MMM yyyy').format(checkInTime);
// 11 Jun 2026

                    String formattedTime = DateFormat('hh:mm a').format(checkInTime);
// 09:42 AM
                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xffE5E7EB)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x08000000),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Route Header
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xffEFF6FF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.directions_bus,
                                  color: Color(0xff2563EB),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  "${item.source?.name??"No Source"} To ${item.destination?.name??"No Destination"}",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  item.status!.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          /// From
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.radio_button_checked,
                                color: Colors.green,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:  [
                                    Text(
                                      "FROM",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "${item.source?.name??"No Source"}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "${item.source?.address??"No Source address"}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: SizedBox(
                              height: 22,
                              child: VerticalDivider(thickness: 1),
                            ),
                          ),

                          /// To
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:  [
                                    Text(
                                      "TO",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Text(
                                      "${item.destination?.name??"No Destination"}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      "${item.destination?.address??"No Destination Address"}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          const Divider(),

                          const SizedBox(height: 10),

                          /// Bottom Details
                          Row(
                            children: [
                              Expanded(
                                child: _infoTile(
                                  Icons.calendar_month,
                                  "Date",
                                  formattedDate,
                                ),
                              ),
                              Expanded(
                                child:_infoTile(
                                  Icons.access_time,
                                  "Time",
                                  formattedTime,
                                ),
                              ),
                              Expanded(
                                child: _infoTile(
                                  Icons.confirmation_num,
                                  "Ride",
                                  "#${item.rideNumber}",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Column(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
