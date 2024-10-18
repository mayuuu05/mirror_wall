import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';
import '../helper/database_helper.dart';

class WebController extends GetxController {
  InAppWebViewController? webViewController;
  RxString currentUrl = 'https://www.google.com'.obs;
  TextEditingController txtSearch = TextEditingController();
  RxBool isLoading = false.obs;
  RxList<String> historyList = <String>[].obs;
  RxList<Map<String, String>> bookmarkList = <Map<String, String>>[].obs;
  final databaseHelper = DatabaseHelper();


  @override
  void onInit() {
    super.onInit();
    loadHistoryFromDatabase();
    loadBookmarksFromDatabase();
  }


  void loadSearchEngine(String url) {
    currentUrl.value = url;
    webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri.uri(Uri.parse(url))),
    );
  }
  var currentIndex = 0.obs;

  void updateIndex(int newIndex) {
    currentIndex.value = newIndex;
  }

  void setWebViewController(InAppWebViewController controller) {
    webViewController = controller;
  }

  void loadSearch(String query) async {
    currentUrl.value = 'https://www.google.com/search?q=$query';
    txtSearch.text = query;
    isLoading.value = true;

    if (!historyList.contains(query)) {
      historyList.add(query);
      try {
        await databaseHelper.insertHistory(query);
        print('History added: $query');
      } catch (e) {
        print('Error adding history: $e');
      }
    }

    webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri.uri(Uri.parse(currentUrl.value))),
    );
  }

  void setLoading(bool loading) {
    isLoading.value = loading;
  }

  void removeHistory(String query) async {
    historyList.remove(query);
    try {
      await databaseHelper.deleteHistory(query);
      print('History removed: $query');
    } catch (e) {
      print('Error removing history: $e');
    }
  }

  void loadHistory(String query) {
    currentUrl.value = 'https://www.google.com/search?q=$query';
    webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri.uri(Uri.parse(currentUrl.value))),
    );
  }

  Future<void> loadHistoryFromDatabase() async {
    try {
      List<String> savedHistory = await databaseHelper.getHistory();
      historyList.assignAll(savedHistory);
      print('History loaded: $savedHistory');
    } catch (e) {
      print('Error loading history: $e');
    }
  }

  Future<void> addBookmark() async {
    String query = txtSearch.text;
    if (!bookmarkList.any((bookmark) => bookmark['url'] == currentUrl.value)) {
      bookmarkList.add({'query': query, 'url': currentUrl.value});
      await databaseHelper.insertBookmark(query, currentUrl.value);
    }
  }

  Future<void> removeBookmark(String url) async {
    bookmarkList.removeWhere((bookmark) => bookmark['url'] == url);
    await databaseHelper.deleteBookmark(url);
  }

  Future<void> loadBookmarksFromDatabase() async {
    try {
      List<Map<String, String>> savedBookmarks = await databaseHelper.getBookmarks();
      bookmarkList.assignAll(savedBookmarks);
      print('Bookmarks loaded: $savedBookmarks');
    } catch (e) {
      print('Error loading bookmarks: $e');
    }
  }
}
