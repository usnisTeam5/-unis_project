// import 'package:flutter/material.dart';
// import 'package:unis_project/chat/OneToOneChat.dart';
// import '../css/css.dart';
// import 'dart:math';
// void main() {
//   runApp(NotifierApp());
// }
//
// class NotifierApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//       ),
//       drawer: Notifier(),
//     );
//   }
// }
//
// class Notifier extends StatefulWidget {
//   @override
//   _CustomDrawerState createState() => _CustomDrawerState();
// }
//
// class Header extends StatelessWidget {
//   final int selectedIndex;
//   final Function(int) onTabSelected;
//
//   const Header({
//     Key? key,
//     required this.selectedIndex,
//     required this.onTabSelected,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final width = min(MediaQuery.of(context).size.width,500.0);
//     return Container(
//       height: 60.0,
//       decoration: BoxDecoration(
//           color: Colors.white,
//         ),
//       child: Row(
//         children: [
//           IconButton(
//             padding: const EdgeInsets.only(left: 16.0),
//             icon: Icon(
//               Icons.arrow_back_ios,
//               color: Colors.grey[400],
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           _buildTab(0, '알림',width),
//           _buildTab(1, '대화',width),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTab(int index, String title , double width) {
//
//     final isSelected = selectedIndex == index;
//     return GestureDetector(
//       child: Center(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           decoration: BoxDecoration(
//             color: isSelected ? Colors.white : Colors.transparent,
//             borderRadius: BorderRadius.circular(30.0),
//           ),
//           child:
//           isSelected ? GradientText(width: width, text: title, tStyle: 'Bold', tSize: 0.06)
//                     :  Text( title, style: TextStyle(
//                               color:  Colors.grey[300],
//                               fontSize: width*0.06,
//                               fontFamily: 'Bold'
//                               ),
//                       ),
//         ),
//       ),
//       onTap: () {
//         onTabSelected(index);
//       },
//     );
//   }
// }
//
// class _CustomDrawerState extends State<Notifier> {
//   int _selectedIndex = 0;
//
//   List<Widget> _screens = [
//     ListView.builder(
//       itemCount: 10,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () {
//             AlarmDetailPopup(
//                 title: "알림 제목",
//                 date: "알림 일자",
//                 content: "알림 내용"
//             ).show(context);
//           },
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: Colors.grey.shade300,
//                 ),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       '스터디방1',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey[700],
//                         fontFamily: 'Bold'
//                       ),
//                     ),
//                     Spacer(),
//                     Text(
//                       '07/12 15:38  ',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[700],
//                         fontFamily: 'Round'
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10,),
//                 Text(
//                   '새로운 스터디원이 들어왔어요sdafsfkasdljdhfhlfaHFLOASDHFOADHFAODSFHASDOFH',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[700],
//                       fontFamily: 'Round',
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     ),
//     ListView.builder(
//       itemCount: 10,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => OneToOneChatScreen(friendName:"")),
//             );
//           },
//           child: Container(
//             padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: Colors.grey.shade300,
//                 ),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       '친구${index}',
//                       style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.grey[700],
//                           fontFamily: 'Bold'
//                       ),
//                     ),
//                     Spacer(),
//                     Text(
//                       '07/12 15:38  ',
//                       style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey[700],
//                           fontFamily: 'Round'
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10,),
//                 Text(
//                   '안녕하세요',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[700],
//                     fontFamily: 'Round',
//                   ),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     ),
//   ];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         width: MediaQuery.of(context).size.width,
//         child: Drawer(
//           child: Column(
//             children: [
//               Header(
//                 selectedIndex: _selectedIndex,
//                 onTabSelected: (index) {
//                   setState(() {
//                     _selectedIndex = index;
//                   });
//                 },
//               ),
//               PreferredSize(
//                 preferredSize: Size.fromHeight(1.0),  // Set the height of the underline
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: MainGradient(),
//                   ),
//                   height: 2.0,  // Set the thickness of the undedsrline
//                 ),
//               ),
//               Expanded(
//                 child: _screens[_selectedIndex],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class AlarmDetailPopup {
//   final String title;
//   final String date;
//   final String content;
//
//   AlarmDetailPopup({required this.title, required this.date, required this.content});
//
//
//   void show(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Row(
//             children: [
//               Expanded(child: Text(this.title, style: TextStyle(fontFamily: 'Bold', fontSize: 18))),
//               SizedBox(width: 8.0),  // 간격을 조정할 수 있습니다.
//               Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 12, fontFamily: 'Bold')),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 16.0),
//               Text(content, style: TextStyle(fontSize: 15, fontFamily: 'Bold',)),
//             ],
//           ),
//           actions: [
//             TextButton(
//               child: Text("닫기", style: TextStyle(fontFamily: 'Bold')),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//


import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:unis_project/view_model/alram_view_model.dart';
import '../chat/OneToOneChat.dart';
import '../chat/chat.dart';
import '../css/css.dart';
import '../models/alram_model.dart';
import '../models/chatRecord_model.dart';
import '../view_model/chatRecord_view_model.dart';
import '../view_model/friends_view_model.dart';
import '../view_model/user_profile_info_view_model.dart';
//import 'other_profile.dart';
import 'package:flutter/material.dart';
import '../css/css.dart';
import 'dart:math';
import '../profile/profile.dart';
import '../models/friends_model.dart';

void main() => runApp(Notifier1());

class Notifier1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Bold',
      ),
      home: Notifier(),
      routes: {
        // ... 기존 라우트
        '/favoritesList': (context) {  // MyListScreenArguments를 읽어옴
          final args = ModalRoute.of(context)?.settings.arguments as MyListScreenArguments?;
          return Notifier(initialTabIndex: args?.initialTabIndex ?? 0);
        },
      },
    );
  }
}

class MyListScreenArguments { //Argument 전달용 클래스
  final int initialTabIndex;

  MyListScreenArguments(this.initialTabIndex);
}

class Notifier extends StatefulWidget {
  final int initialTabIndex;

  Notifier({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  _MyListScreenState createState() => _MyListScreenState();
}

class _MyListScreenState extends State<Notifier> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int count = 0;
  int tabTemp =0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTabIndex);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  Widget gradientTabText(double width, String text, int tabIndex) {
    return _tabController?.index == tabIndex
        ? GradientText(
      width: width,
      text: text,
      tStyle: 'Bold',
      tSize: 0.05,
    )
        : Text(
      text,
      style: TextStyle(
        color: Colors.grey[300],
        fontFamily: 'Bold',
        fontSize: width * 0.05,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = min(MediaQuery.of(context).size.width, 500.0);
    double tabBarHeight = MediaQuery.of(context).size.height * 0.08;

    return ChangeNotifierProvider(
        create: (_) => FriendsProfileViewModel(),
        builder: (context, child) {

          final chatListViewModel = Provider.of<ChatListViewModel>(context, listen: true);
          final myprofile = Provider.of<UserProfileViewModel>(context, listen: false);
          final alram = Provider.of<AlarmViewModel>(context, listen: true);
          WidgetsBinding.instance.addPostFrameCallback((_) async{ // 나중에 호출됨.
            if(count == 0) {
              count ++;
              print("count: ${count}");

              // 다른 비동기 작업 실행
              await chatListViewModel.fetchChatList(myprofile.nickName);

            }
            if(_tabController.index == 0 && _tabController.index != tabTemp){
              tabTemp = _tabController.index;
            }
            else if(_tabController.index == 1 && _tabController.index != tabTemp){
              tabTemp = _tabController.index;
            }
          });


          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: tabBarHeight,
                    color: Colors.white,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey,),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                          width: 270,
                          child: TabBar(
                            controller: _tabController,
                            tabs: [
                              Tab(child: gradientTabText(width, '알림', 0)),
                              Tab(child: gradientTabText(width, '대화', 1)),
                            ],
                            indicatorColor: Colors.white,
                            labelColor: Colors.white,
                            indicatorSize: TabBarIndicatorSize.label,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 2.0,
                    decoration: BoxDecoration(
                      gradient: MainGradient(),
                    ),
                  ),
                  (chatListViewModel.isLoading == true || count == 0)
                      ? Center(child: CircularProgressIndicator(),)
                      :Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        buildListView1(alram, '알림'),
                        buildListView2(chatListViewModel, '대화' ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  ListView buildListView1(AlarmViewModel alarm,String type) {
    // This code block remains unchanged from your original code.
    AlarmViewModel _alarm = alarm;
    List<QaAlarmDto> alarmList = _alarm.qaAlarmsStore;
    // 알람 리스트가 비어있을 경우 텍스트 위젯을 반환
    if (alarmList.isEmpty) {
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '알람이 없습니다.',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Round',
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      );
    }
    return ListView.builder(

      padding: EdgeInsets.zero,
      itemCount: alarmList.length,
      itemBuilder: (context, index) {
        QaAlarmDto alarmIndex = alarmList[index];
        return GestureDetector(
          onTap: () async{
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ChatScreen(qaKey: alarmIndex.qaKey, forAns: false, course: alarmIndex.course,)
                )
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 20),
                Text(
                  ' \"${alarmIndex.course} \" 답변이 왔습니다',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Round',
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  ListView buildListView2(ChatListViewModel friendsViewModel,String type) {
    // This code block remains unchanged from your original code.
    final _friendsViewModel = friendsViewModel;
    List<ChatListDto> UserList; // 찜 또는 친구 또는 차단
      UserList = _friendsViewModel.chatList;

    if (UserList.isEmpty) {
      return ListView(
        padding: EdgeInsets.zero,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '대화 목록이 없습니다.',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Round',
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: UserList.length,
      itemBuilder: (context, index) {
        ChatListDto friend = UserList[index];
        String time = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(friend.time));
        return GestureDetector(
          onTap: () async{
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OneToOneChatScreen(
                  friendName: friend.nickname, // 2 상대
                ),
              ),
            );
            _friendsViewModel.notify();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      friend.nickname,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                          fontFamily: 'Bold'
                      ),
                    ),
                    Spacer(),
                    Text(
                      time,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontFamily: 'Round'
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Text(
                  friend.msg!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontFamily: 'Round',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

