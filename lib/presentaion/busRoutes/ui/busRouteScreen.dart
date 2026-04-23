import 'package:flutter/material.dart';
import 'package:mannfleet/util/image_resource/image_resource.dart';
import 'package:mannfleet/widget/custom_appBar.dart';
import 'package:mannfleet/widget/custom_text.dart';
import '../../../util/color/app_colors.dart';
import '../../../widget/customImageView.dart';

class BusRoutes extends StatefulWidget {
  const BusRoutes({super.key});

  @override
  State<BusRoutes> createState() => _BusRoutesState();
}

class _BusRoutesState extends State<BusRoutes> {

  int selectedIndex = 0;

  List<String> filters = [
    "Nearby",
    "Popular",
    "Recommended"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Bus Routes',
       isBack: true,
       // actionImage: AppImages.calendericon,
        onActionTap: () {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// SEARCH
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorResource.homeOption,
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search routes...',
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

              /// FILTERS
              Row(
                children: List.generate(
                  filters.length,
                      (index) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: selectedIndex == index
                              ? ColorResource.viewText
                              : ColorResource.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: selectedIndex == index
                                ? ColorResource.viewText
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: CustomText(
                          filters[index],
                          size: 14,
                          weight: FontWeight.w600,
                          color: selectedIndex == index
                              ? ColorResource.white
                              : ColorResource.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    "Popular Routes in Noida",
                    size: 16,
                    weight: FontWeight.w700,
                  ),
                  CustomText(
                    "LIVE VIEW",
                    size: 12,
                    weight: FontWeight.w600,
                    color: ColorResource.textColor,
                  ),
                ],
              ),

              const SizedBox(height: 15),

              /// CARD 1
              routeCard(
                start: "Sector 18",
                end: "Pari Chowk",
                route: "Route 34A • Via Noida-Greater Noida Expy",
                time: "4 MINS",
                percent: "60% Full",
                status: "STANDING AVAILABLE",
                color: ColorResource.textColor,
              ),

              const SizedBox(height: 15),

              /// CARD 2
              routeCard(
                start: "Botanical Garden",
                end: "Advant",
                route: "Route 8 • Via Sector 142",
                time: "12 MINS",
                percent: "20% Full",
                status: "PLENTY OF SEATS",
                color: ColorResource.textColor,
              ),

              const SizedBox(height: 20),

              /// NEARBY BUS STOP BANNER
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage("assets/map.png"), // map image
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Text(
                        "Nearby Bus Stops",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "3 stops within 500m",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// CARD 3
              routeCard(
                start: "Sector 62",
                end: "City Center",
                route: "Route 112 • Express Service",
                time: "DUE",
                percent: "95% Full",
                status: "HIGHLY CONGESTED",
                color: ColorResource.aberColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ROUTE CARD WIDGET
  Widget routeCard({
    required String start,
    required String end,
    required String route,
    required String time,
    required String percent,
    required String status,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey.shade100,
      ),
      child: Column(
        children: [

          /// TOP ROW
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.directions_bus,color: ColorResource.textColor,),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "$start  →  $end",
                      size: 16,
                      weight: FontWeight.w700,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      route,
                      size: 13,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const CustomText(
                    "NEXT BUS",
                    size: 12,
                    color: Colors.grey,
                  ),
                  CustomText(
                    time,
                    size: 16,
                    weight: FontWeight.w700,
                    color: color,
                  )
                ],
              )
            ],
          ),

          const SizedBox(height: 5),

          Divider(),

          const SizedBox(height: 5),

          /// BOTTOM
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  percent,
                  size: 12,
                  weight: FontWeight.w600,
                  color: color,
                ),
              ),

              const SizedBox(width: 10),

              CustomText(
                status,
                size: 12,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }
}