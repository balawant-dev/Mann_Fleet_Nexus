// lib/features/home/ui/widget/location_tile.dart
import 'package:flutter/material.dart';
enum AddressType {
  Home,
  Work,
  Office,
  Other,
}

class LocationTile extends StatelessWidget {
  final dynamic item;
  // final dynamic item;
  final String isFavorite;
  final VoidCallback onTap;
  final VoidCallback onSave;

  const LocationTile({
    super.key,
    required this.item,
    required this.isFavorite,
    required this.onTap,
    required this.onSave,
  });

  IconData _getLeadingIcon() {
    switch (item.type) {
      case 'Home':
        return Icons.home;

      case 'Work':
      case 'Office':
        return Icons.business;

      case 'Other':
      default:
        return Icons.location_on;
    }
  }



  // IconData _getLeadingIcon() {
  //   final title = item.type?.toLowerCase() ?? '';
  //   if (title.contains('home')) return Icons.home;
  //   if (title.contains('college') || title.contains('school')) return Icons.school;
  //   if (title.contains('office') || title.contains('work')) return Icons.business;
  //   return Icons.history; // default recent
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ SizedBox(height: 12,),
        GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(_getLeadingIcon(), color: Colors.grey.shade300, size: 24),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.type.toUpperCase() ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 13,fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*0.6,
                        child: Text(
                          item.address ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color:  Colors.grey.shade300, fontSize: 13),
                        ),
                      ),
                    ],
                  )
                ],
              ),

              InkWell(
                onTap: onSave,
                child: Icon(
                  isFavorite=="RecentSearch" ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite=="RecentSearch" ? Colors.red : Colors.grey,
                  size: 22,
                ),
              ),

            ],
          ),
        ),
        SizedBox(height: 12,),

        // ListTile(
        //   contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        //   leading: Icon(_getLeadingIcon(), color: Colors.grey[700], size: 24),
        //   // title: Text(
        //   //   item.addressType ?? item.address?.split(',').first ?? '',
        //   //   style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        //   // ),
        //   subtitle: Text(
        //     item.address ?? '',
        //     maxLines: 1,
        //     overflow: TextOverflow.ellipsis,
        //     style: TextStyle(color: Colors.grey[600], fontSize: 13),
        //   ),
        //   trailing: InkWell(
        //     onTap: onSave,
        //     child: Icon(
        //       isFavorite ? Icons.favorite : Icons.favorite_border,
        //       color: isFavorite ? Colors.red : Colors.grey,
        //       size: 22,
        //     ),
        //   ),
        //   onTap: onTap,
        // ),
        const Divider(height: 1, indent: 25, color: Color(0xffE2E8F0)),
      ],
    );
  }
}