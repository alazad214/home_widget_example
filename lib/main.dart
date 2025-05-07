import 'dart:io';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<String> imageUrls = [
    'https://asset.gecdesigns.com/img/visiting-card-templates/elegant-visiting-card-design-for-creative-professionals-10042403-1712758228308-cover.webp',
    'https://asset.gecdesigns.com/img/visiting-card-templates/modern-creative-business-card-design-professional-sr09092409-cover.webp',
  ];

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Widget Example',
      home: Scaffold(
        appBar: AppBar(title: Text('Home Widget Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              int currentIndex = 0;
              await _updateWidget(imageUrls, currentIndex);
            },
            child: Text('Initialize Widget'),
          ),
        ),
      ),
    );
  }

  Future<void> _updateWidget(List<String> urls, int index) async {
    final imageUrl = urls[index];
    final response = await http.get(Uri.parse(imageUrl));
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/widget_image.jpg');
    await file.writeAsBytes(response.bodyBytes);

    await HomeWidget.saveWidgetData<String>('imagePath', file.path);
    await HomeWidget.saveWidgetData<int>('currentIndex', index);
    await HomeWidget.saveWidgetData<int>('totalImages', urls.length);

    await HomeWidget.updateWidget(
      name: 'HomeScreenWidgetProvider',
      iOSName: 'HomeWidgetExtension',
    );
  }
}
