import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:zapxx/configs/color/color.dart';

class DeliverPhotos extends StatefulWidget {
  const DeliverPhotos({super.key});

  @override
  State<DeliverPhotos> createState() => _DeliverPhotosState();
}

class _DeliverPhotosState extends State<DeliverPhotos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: .2,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Potfolio',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 57),
            Row(
              children: [
                Text(
                  "Sports",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                SizedBox(width: 10),
                Icon(Icons.edit, size: 20, color: AppColors.backgroundColor),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 2,
                  dashPattern: [6, 3],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/gallery1.png',
                          width: 80, // Width of the container
                          height: 80,
                        ),
                        Positioned(
                            bottom: 5,
                            right: 10,
                            child: Icon(Icons.delete, color: Colors.red)),
                      ],
                    )),
                SizedBox(width: 10),
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/gallery1.png',
                          width: 80, // Width of the container
                          height: 80,
                        ),
                        Positioned(
                            bottom: 5,
                            right: 10,
                            child: Icon(Icons.delete, color: Colors.red)),
                      ],
                    )),
              ],
            ),
            SizedBox(height: 57),
            Row(
              children: [
                Text(
                  "Picture Delivery",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 2,
                  dashPattern: [6, 3],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/gallery1.png',
                          width: 80, // Width of the container
                          height: 80,
                        ),
                        Positioned(
                            bottom: 5,
                            right: 10,
                            child: Icon(Icons.delete, color: Colors.red)),
                      ],
                    )),
                SizedBox(width: 10),
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/images/gallery1.png',
                          width: 80, // Width of the container
                          height: 80,
                        ),
                        Positioned(
                            bottom: 5,
                            right: 10,
                            child: Icon(Icons.delete, color: Colors.red)),
                      ],
                    )),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                  'Post',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                )),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
