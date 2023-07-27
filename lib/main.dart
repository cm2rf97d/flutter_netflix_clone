import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:netflix_sample/model/Movie/download_movie_state.dart';
import 'package:netflix_sample/pages/Download/download_page.dart';
import 'package:netflix_sample/pages/Home/home_page.dart';
import 'package:netflix_sample/model/Movie/movie_state.dart';
import 'package:netflix_sample/pages/Home/home_page_cell.dart';
import 'package:netflix_sample/pages/Search/search_page.dart';
import 'package:netflix_sample/pages/UpComing/upcoming_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix Demo',
      theme: ThemeData(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // 判斷目前選擇的 Tabbar index.

  // Tabbar 的 Navigation Title 和 對應的Page
  final List<Map<String, dynamic>> _tabbarPageList = [
    {'title': 'Home', 'widget': const HomePage()},
    {
      'title': 'UpComing',
      'widget': const UpComingPage(fetchCategory: "/movie/upcoming")
    },
    {'title': 'Search', 'widget': const SearchPage()},
    {'title': 'Download', 'widget': const DownloadPage()},
  ];

  // Tabbar 的圖案
  final List<BottomNavigationBarItem> _navigationBarItem = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
      tooltip: '',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.play_circle_outline),
      label: 'UpComing',
      tooltip: '',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Search',
      tooltip: '',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.download),
      label: 'Download',
      tooltip: '',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(_tabbarPageList[_selectedIndex]['title']),
      ),
      body: CupertinoTabScaffold( // iOS的 Tabbar 架構. (目前是不想讓每次切換Tabbar時，每個頁面都要重新Rebuild才使用)
          tabBar: CupertinoTabBar(
            items: _navigationBarItem,
            backgroundColor: Colors.black,
            activeColor: Colors.white,
            onTap: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          tabBuilder: (BuildContext context, int index) {
            return _tabbarPageList[index]['widget'];
          }),
    );
  }
}
