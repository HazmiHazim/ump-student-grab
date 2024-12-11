import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ump_student_grab_mobile/BL/chat_websocket_service.dart';
import 'package:ump_student_grab_mobile/Screen/Account/main_account_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Booking/main_booking_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Chat/main_chat_screen.dart';
import 'package:ump_student_grab_mobile/Screen/Home/home_screen.dart';
import 'package:ump_student_grab_mobile/widget/custom_bottom_navigation_bar.dart';
import 'package:provider/provider.dart';

class SharedWidget extends StatefulWidget {

  @override
  _SharedWidgetState createState() => _SharedWidgetState();
}

class _SharedWidgetState extends State<SharedWidget> with SingleTickerProviderStateMixin {

  int _selectedScreen = 0;
  late final AnimationController _navAnimController;
  int _unreadMessages = 3;

  // List of app bar titles for each screen
  final List<String> _appBarTitles = [
    'Home',  // Title for HomeScreen
    'Bookings',  // Title for MainBookingScreen
    'Messages',  // Title for MainChatScreen
    'My Account',  // Title for MainAccountScreen
  ];

  @override
  void initState() {
    super.initState();
    _navAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    // Safely check if the widget is still mounted before accessing the context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) { // Check if the widget is still in the widget tree
        final chatWebsocketService = Provider.of<ChatWebsocketService>(context, listen: false);
        chatWebsocketService.stopConnection();
      }
    });

    // Dispose of the animation controller
    _navAnimController.dispose();

    super.dispose();
  }


  // Screen selection handler
  void _onScreenSelected(int index) {
    setState(() {
      _selectedScreen = index;
    });

    // Start WebSocket connection only when 'Messages' (MainChatScreen) is selected
    final chatWebsocketService = Provider.of<ChatWebsocketService>(context, listen: false);

    if (_selectedScreen == 2) {
      chatWebsocketService.startConnection();
    } else {
      chatWebsocketService.stopConnection();
    }

    // Optional: start or stop animations based on selected index
    if (!_navAnimController.isAnimating) {
      _navAnimController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10.0,
                spreadRadius: 1.0,
                offset: Offset(0, 1),
              )
            ]
          ),
          child: AppBar(
            title: Text(_appBarTitles[_selectedScreen]),
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedScreen,
        children: [
          HomeScreen(),
          MainBookingScreen(),
          MainChatScreen(),
          MainAccountScreen()
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedScreen: _selectedScreen,
        onDestinationSelected: _onScreenSelected,
        navAnimation: _navAnimController,
        unreadMessages: _unreadMessages
      ),
    );
  }
}