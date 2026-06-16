import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../util/color/app_colors.dart';
import '../../../widget/custom_appBar.dart';
import '../../bottomBar/bottomBar.dart';
import '../../profile/viewModel/profileViewModel.dart';
import '../viewModel/walletViewModel.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  void loadInitialData() {
    final vm = Provider.of<ProfileDetailViewModel>(context, listen: false);
    final vm2 = Provider.of<WalletViewModel>(context, listen: false);
    vm.getProfileApi(context: context);
    vm2.getWalletTransactionApi(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        isBack: true,
        title: "My Wallet",
        onActionTap: () {
          print("Setting clicked");
        },
        // onBackTap: () {
        //   MainScreen.changeTab(context, 0);
        // },
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   centerTitle: true,
      //   title: const Text(
      //     "My Wallet",
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontWeight: FontWeight.w600,
      //     ),
      //   ),
      //   iconTheme: const IconThemeData(color: Colors.black),
      // ),
      body: Consumer2<ProfileDetailViewModel, WalletViewModel>(
        builder: (context, pro, walletPro, child) {
          // if(pro.getProfileModel==null ||pro.getProfileModel!.data==null){
          //   return Center(child: CircularProgressIndicator());
          // }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Wallet Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [
                        ColorResource.primary,
                        ColorResource.primarySec,
                        // Color(0xff1E88E5),
                        // Color(0xff42A5F5),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(.2),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Available Balance",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        // "₹ 12,500",
                        "₹ ${pro.getProfileModel?.data?.user?.walletBalance ?? 0}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// Buttons
                // Row(
                //   children: [
                //     Expanded(
                //       child: ElevatedButton.icon(
                //         onPressed: () {},
                //         icon: const Icon(Icons.add),
                //         label: const Text("Add Money"),
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.green,
                //           minimumSize: const Size(double.infinity, 55),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(14),
                //           ),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 12),
                //     Expanded(
                //       child: ElevatedButton.icon(
                //         onPressed: () {},
                //         icon: const Icon(Icons.account_balance_wallet_outlined),
                //         label: const Text("Withdraw"),
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.orange,
                //           minimumSize: const Size(double.infinity, 55),
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(14),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                //
                // const SizedBox(height: 30),

                /// Transaction History Title
                Text(
                  "Transaction History",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 15),


                /// Transaction List
                walletPro.walletTransactionModel == null ||
                        walletPro.walletTransactionModel!.data == null
                    ? Center(child: CircularProgressIndicator())
                    : walletPro.walletTransactionModel!.data!.isEmpty
                    ? SizedBox(
                  height: 300,
                    width: MediaQuery.of(context).size.width,

                    child: Center(child: Text("No Transaction History")))
                    : ListView.builder(
                      itemCount: walletPro.walletTransactionModel!.data!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        // bool isCredit = index % 2 == 0;
                        final data=walletPro.walletTransactionModel!.data![index];
                        print("Date is ${data.createdAt}");
                        final formattedDate = DateFormat(
                          'dd MMMM yyyy • hh:mm a',
                        ).format(
                          DateTime.parse(data.createdAt!).toLocal(),
                        );
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade200),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.08),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color:
                                  data.type =="credit"
                                          ? Colors.green.withOpacity(.1)
                                          : Colors.red.withOpacity(.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  data.type =="credit"
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color:   data.type =="credit" ? Colors.green : Colors.red,
                                ),
                              ),
                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.type =="credit" ? "Money Added" : "Payment Sent",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formattedDate,
                              //        "12 July 2026 • 10:30 AM",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Text(
                                data.type =="credit" ? "+ ₹${data.amount}" : "- ₹${data.amount}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color:   data.type =="credit" ? Colors.green : Colors.red,
                                ),
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
}
