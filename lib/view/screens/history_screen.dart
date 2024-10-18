import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/web_controller.dart';

class HistoryPage extends StatelessWidget {
  final WebController webController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
            onTap:() {
              Get.back();
            } ,
            child: Icon(Icons.arrow_back,color: Colors.white,)),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Search History',style: TextStyle(
            color: Colors.white
        ),),
      ),
      body: Obx(() {
        if (webController.historyList.isEmpty) {
          return const Center(child: Text('No history available'));
        }

        return ListView.builder(
          itemCount: webController.historyList.length,
          itemBuilder: (context, index) {
            final query = webController.historyList[index];
            return ListTile(
              title: Text(query),
              leading: Icon(Icons.history),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  webController.removeHistory(query);
                },
              ),
              onTap: () {
                webController.loadHistory(query);
                Navigator.of(context).pop();
              },
            );
          },
        );
      }),
    );
  }
}
