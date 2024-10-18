import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../controller/web_controller.dart';
import 'bookmark_screen.dart';
import 'history_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WebController webController = Get.put(WebController());
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('My Browser'),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.browser_updated_sharp),
        ),
        actions: [
          PopupMenuButton(
            color: Colors.white,
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: const Icon(Icons.bookmark),
                  title: const Text('All Bookmarks'),
                  onTap: () {
                    Get.back();
                    Get.to(() => BookmarkPage());

                  },
                ),
              ),
              PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Search Engine'),
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 1) {
            
              } else if (value == 2) {

                _showSearchEngineDialog(context, webController);
              }
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(screenHeight * 0.09),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.03),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.004,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.grey.shade200,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: TextField(
                          controller: webController.txtSearch,
                          onSubmitted: (value) {
                            webController.loadSearch(value);
                          },
                          decoration: const InputDecoration(
                            hintText: 'Search or type URL',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Icon(Icons.mic, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight*0.01,),
              Obx(() => webController.isLoading.value
                  ? LinearProgressIndicator(
                backgroundColor: Colors.grey.shade300,
                color: Colors.blue,
                minHeight: 2,
              )
                  : SizedBox.shrink()),

              SizedBox(height: screenHeight*0.02,)
            ],
          ),
        ),
      ),
      body: Obx(() => InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri.uri(Uri.parse(webController.currentUrl.value)),
        ),
        onWebViewCreated: (controller) {
          webController.webViewController = controller;
        },
      )),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_add_outlined),
            label: 'Bookmark',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back_ios_new_rounded),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.refresh),
            label: 'Refresh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward_ios_rounded),
            label: 'Forward',
          ),
        ],
        currentIndex: webController.currentIndex.value,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        onTap: (index) async {
          webController.updateIndex(index);

          switch (index) {
            case 0:
              break;
            case 1:
              webController.addBookmark();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bookmark added')),
              );
              break;
            case 2:
              Get.to(() => HistoryPage());
              break;
            case 3:
              await webController.webViewController?.goBack();
              break;
            case 4:
              await webController.webViewController?.reload();
              break;
            case 5:
              await webController.webViewController?.goForward();
              break;
          }
        },
      ),
        );
  }

  void _showSearchEngineDialog(BuildContext context, WebController webController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedEngine = 'https://www.google.com'; 
        return AlertDialog(
          title: Text('Search Engine'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('Google'),
                value: 'https://www.google.com',
                groupValue: selectedEngine,
                onChanged: (String? value) {
                  selectedEngine = value!;
                  webController.loadSearchEngine(selectedEngine);
                  Get.back();
                },
              ),
              RadioListTile<String>(
                title: const Text('Yahoo'),
                value: 'https://search.yahoo.com',
                groupValue: selectedEngine,
                onChanged: (String? value) {
                  selectedEngine = value!;
                  webController.loadSearchEngine(selectedEngine);
                  Get.back();
                },
              ),
              RadioListTile<String>(
                title: const Text('Bing'),
                value: 'https://www.bing.com',
                groupValue: selectedEngine,
                onChanged: (String? value) {
                  selectedEngine = value!;
                  webController.loadSearchEngine(selectedEngine);
                  Get.back();
                },
              ),
              RadioListTile<String>(
                title: const Text('DuckDuckGo'),
                value: 'https://duckduckgo.com',
                groupValue: selectedEngine,
                onChanged: (String? value) {
                  selectedEngine = value!;
                  webController.loadSearchEngine(selectedEngine);
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
