import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/bookingHistoryProvider.dart';

class RatingBottomSheet extends StatefulWidget {
  final String bookingId;
  final String driverName;

  const RatingBottomSheet({
    super.key,
    required this.bookingId,
    required this.driverName,
  });

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  double rating = 5;

  final reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingHistoryProvider>(
      builder: (context, provider, _) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      "How was your ride with ${widget.driverName}?",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        return IconButton(
                          onPressed: () {
                            setState(() {
                              rating = i + 1.0;
                            });
                          },
                          icon: Icon(
                            i < rating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 34,
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: reviewController,
                      maxLines: 4,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: "Write review (optional)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: provider.isSubmittingRating
                              ? null
                              : () async {
                                  final ok = await provider.submitRating(
                                    context: context,
                                    bookingId: widget.bookingId,
                                    rating: rating,
                                    comment: reviewController.text,
                                  );

                                  if (ok) {
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Thanks for rating ❤️"),
                                      ),
                                    );
                                  }
                                },
                          child: provider.isSubmittingRating
                              ? const CircularProgressIndicator()
                              : const Text("Submit Review"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
