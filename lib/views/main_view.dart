import 'package:booktify/views/bookmark_view.dart';
import 'package:booktify/views/reading_view.dart';
import 'package:booktify/widgets/bottom_menu_item.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:booktify/utils/app_color.dart';
import 'home_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeView(),
    ReadingView(),
    BookmarkView(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Color getBottomNavColor() {
    return selectedIndex == 0 ? AppColors.myGreen : AppColors.myWhite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        color: getBottomNavColor(),
        child: Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.myWhite,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              BottomMenuItem(
                onTap: () => onItemTapped(0),
                isActive: selectedIndex == 0,
                title: "Explore",
                icon: MdiIcons.compassOutline,
              ),
              BottomMenuItem(
                onTap: () => onItemTapped(1),
                isActive: selectedIndex == 1,
                title: "Reading",
                icon: MdiIcons.bookOpenOutline,
              ),
              BottomMenuItem(
                onTap: () => onItemTapped(2),
                isActive: selectedIndex == 2,
                title: "Bookmark",
                icon: MdiIcons.bookmarkOutline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
