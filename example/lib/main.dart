import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_shimmer/get_shimmer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Get Shimmer Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          centerTitle: true,
          title: Text('GetShimmer Demo'),
          leading: IconButton.outlined(
            onPressed: () {
              Get.defaultDialog(
                title: 'User Info',
                content: Column(
                  spacing: 8,
                  children: [
                    Row(
                      children: [
                        Text('Name: '),
                        GetShimmer.fromColors(
                          child: Container(
                            height: 10,
                            width: 100,
                            decoration: BoxDecoration(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Age: '),
                        GetShimmer.fromColors(
                          child: Container(
                            height: 10,
                            width: 100,
                            decoration: BoxDecoration(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('City: '),
                        GetShimmer.fromColors(
                          child: Container(
                            height: 10,
                            width: 100,
                            decoration: BoxDecoration(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                confirm: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    child: Text('Exit'),
                  ),
                ),
              );
            },
            icon: Icon(Icons.person),
          ),
        ),
        body: ListView.builder(
          itemCount: 20,
          itemBuilder: (context, index) {
            return GetShimmer.fromColors(
              // in 0.0.6 the baseColor and highlightColor not required
              // baseColor: Colors.grey.shade300,
              // highlightColor: Colors.grey.shade100,
              child: Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(radius: 30),
                    title: Container(
                      margin: EdgeInsets.only(right: Get.width / 2),
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    subtitle: Container(
                      width: double.infinity,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
