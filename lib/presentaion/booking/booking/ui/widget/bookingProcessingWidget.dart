import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
final GlobalKey<_BookingProcessingWidgetState> bookingKey = GlobalKey();


class BookingProcessingWidget extends StatefulWidget {
  const BookingProcessingWidget({super.key});

  @override
  State<BookingProcessingWidget> createState() =>
      _BookingProcessingWidgetState();
}

enum BookingStep { creating, payment, success }

class _BookingProcessingWidgetState
    extends State<BookingProcessingWidget> {

  BookingStep step = BookingStep.creating;

  void showPayment() {
    setState(() {
      step = BookingStep.payment;
    });
  }

  void showSuccess() {
    setState(() {
      step = BookingStep.success;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = "";
    String subtitle = "";

    switch (step) {
      case BookingStep.creating:
        title = "Creating your booking...";
        subtitle = "Please wait while we reserve your ride";
        break;

      case BookingStep.payment:
        title = "Redirecting to payment...";
        subtitle = "Opening secure payment gateway";
        break;

      case BookingStep.success:
        title = "Booking Confirmed 🎉";
        subtitle = "Your vehicle is successfully booked 🚗";
        break;
    }

    return Container(
      height: 380,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          /// ICON
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: step == BookingStep.success
                ? BounceIn(
              child: Icon(Icons.check_circle,
                  size: 80, color: Color(0xFF03045E)),
            )
                : Pulse(
              infinite: true,
              child: CircularProgressIndicator(
                color: Color(0xFF03045E),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),

          const SizedBox(height: 10),

          /// Extra small text
          if (step == BookingStep.creating)
            FadeInUp(
              child: Text(
                "Securing your ride...",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

          if (step == BookingStep.payment)
            FadeInUp(
              child: Text(
                "Do not press back",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
        ],
      ),
    );
  }
}