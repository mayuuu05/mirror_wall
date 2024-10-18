import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/web_controller.dart';

class BookmarkPage extends StatelessWidget {
  final WebController webController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: GestureDetector(
          onTap:() {
            Get.back();
          } ,
            child: Icon(Icons.arrow_back,color: Colors.white,)),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Bookmarks',style: TextStyle(
          color: Colors.white
        ),),

      ),
      body: Obx(() {
        if (webController.bookmarkList.isEmpty) {
          return const Center(child: Text('No bookmarks available'));
        }

        return ListView.builder(
          itemCount: webController.bookmarkList.length,
          itemBuilder: (context, index) {
            final bookmark = webController.bookmarkList[index];
            final query = bookmark['query'];
            final url = bookmark['url'];

            return ListTile(
              title: Text(query ?? 'Unknown'),
              leading: Icon(Icons.bookmark),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  webController.removeBookmark(url!);
                },
              ),
              onTap: () {
                webController.loadHistory(query!);
                Navigator.of(context).pop();
              },
            );
          },
        );
      }),
    );
  }
}
