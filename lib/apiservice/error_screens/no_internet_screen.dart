import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  final VoidCallback? onRetry;
  const NoInternetScreen({super.key, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text('No Internet',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 100,
              color: Colors.grey,
            )
            , SizedBox(height: 15,),
            const Text('Please check your internet connection.',textAlign: TextAlign.center,style: TextStyle(   fontSize: 14,
              color: Colors.grey,
            ),),            SizedBox(height: 50,),
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