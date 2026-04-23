import 'package:flutter/material.dart';


class ServerErrorScreen extends StatelessWidget {
  final VoidCallback? onRetry;
  const ServerErrorScreen({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          // leading: SizedBox(),
          centerTitle: true,
          title: const Text('Server Error',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(
            Icons.cloud_off,
            size: 100,
            color: Colors.grey,
          ), SizedBox(height: 15,),

            Text('Something went wrong on the server. \nPlease try again later.'  ,textAlign: TextAlign.center,style: TextStyle(   fontSize: 14,
              color: Colors.grey,
            ),),
            SizedBox(height: 50,),
            ElevatedButton(
              onPressed: () {
                if (onRetry != null) {
                  onRetry!();
                }
                Navigator.pop(context);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}