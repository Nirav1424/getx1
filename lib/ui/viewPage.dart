import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/constant/AppColors.dart';
import 'package:getx/constant/customeButton.dart';
import 'package:intl/intl.dart';

import '../Models/UserDataModel.dart';
import '../controller/imageCarouselController.dart';
import '../repository/UserRepository.dart';

class ViewPage extends StatelessWidget {
  const ViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments =
        Get.arguments as Map<String, dynamic>?; // Receive arguments
    final userRepo = Get.put(UserRepository());
    final imageCarouselController = Get.put(ImageCarouselController());
    final imageUrls = [
      'assets/images/Bungalow.webp', // Replace with your asset paths or URLs
      'assets/images/banglose2.jpeg',
      'assets/images/bang3.webp',
    ];

    if (arguments == null || arguments['id'] == null) {
      // Handle null or missing arguments gracefully
      return Scaffold(
        body: const Center(
          child: Text("No data provided!"),
        ),
      );
    }

    final String id = arguments['id']; // Extract the ID from arguments

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: const Text("View Details"),
      ),
      body: StreamBuilder<UserDataModels?>(
        stream: userRepo.getOnlySelectedData(id), // Fetch data by ID
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Image (Mocked)
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: PageView.builder(
                    onPageChanged: (index) {
                      imageCarouselController
                          .updateIndex(index); // Update index on page change
                    },
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return Image.asset(
                        imageUrls[index], // Load image from assets
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),

                // Dots Indicator
                Obx(
                  () {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(imageUrls.length, (index) {
                          return AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            width: imageCarouselController.currentIndex.value ==
                                    index
                                ? 12
                                : 8,
                            height:
                                imageCarouselController.currentIndex.value ==
                                        index
                                    ? 12
                                    : 8,
                            decoration: BoxDecoration(
                              color:
                                  imageCarouselController.currentIndex.value ==
                                          index
                                      ? Colors.blue
                                      : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                    );
                  },
                ),

                Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // Rating Section (For Now Static)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            "4.5/5",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),

                // Address Section (Smaller Font)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Location: ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold, // Make "Location" bold
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: user.address,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Amount Section (Bold and Larger Font)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "\$ ${NumberFormat("#,##,###").format(user.amount)}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Description : ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold, // Make "Description" bold
                      color: Colors.black,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "This is a placeholder description for the property details. You can update this section with the actual details later.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),

                // Spacer ensures the button stays at the bottom if content isn't large enough
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomButton(text: "Book Now", onTap: () {}),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
