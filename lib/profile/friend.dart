import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../css/css.dart';
import '../view_model/friends_view_model.dart';
import '../view_model/user_profile_info_view_model.dart';
import 'other_profile.dart';
import 'package:flutter/material.dart';
import '../css/css.dart';
import 'other_profile.dart';
import 'dart:math';
import '../profile/profile.dart';
import '../models/friends_model.dart';

void main() => runApp(FriendsList());

class FriendsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Bold',
      ),
      home: MyListScreen(),
      routes: {
        // ... 기존 라우트
        '/favoritesList': (context) {  // MyListScreenArguments를 읽어옴
          final args = ModalRoute.of(context)?.settings.arguments as MyListScreenArguments?;
          return MyListScreen(initialTabIndex: args?.initialTabIndex ?? 0);
        },
      },
    );
  }
}

class MyListScreenArguments { //Argument 전달용 클래스
  final int initialTabIndex;

  MyListScreenArguments(this.initialTabIndex);
}

class MyListScreen extends StatefulWidget {
  final int initialTabIndex;

  MyListScreen({Key? key, this.initialTabIndex = 0}) : super(key: key);

  @override
  _MyListScreenState createState() => _MyListScreenState();
}

class _MyListScreenState extends State<MyListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int count = 0;
  int tabTemp =0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTabIndex);
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

          final friendsViewModel = Provider.of<FriendsProfileViewModel>(context, listen: true);
          final myprofile = Provider.of<UserProfileViewModel>(context, listen: false);

          WidgetsBinding.instance.addPostFrameCallback((_) async{ // 나중에 호출됨.
            if(count == 0) {
              count ++;
              print("count: ${count}");

              // 다른 비동기 작업 실행
              await friendsViewModel.fetchPicks(myprofile.nickName);
              await friendsViewModel.fetchFriends(myprofile.nickName);
              await friendsViewModel.fetchBlocks(myprofile.nickName);
            }
            if(_tabController.index == 0 && _tabController.index != tabTemp){
              tabTemp = _tabController.index;
              await friendsViewModel.fetchPicks(myprofile.nickName);
            }
            else if(_tabController.index == 1 && _tabController.index != tabTemp){
              tabTemp = _tabController.index;
              await friendsViewModel.fetchFriends(myprofile.nickName);
            }
            else if(_tabController.index == 2 && _tabController.index != tabTemp){
              tabTemp = _tabController.index;
              await friendsViewModel.fetchBlocks(myprofile.nickName);
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
                            //Tab(child: gradientTabText(width, '찜', 0)),
                            Tab(child: gradientTabText(width, '친구', 0)),
                            Tab(child: gradientTabText(width, '차단', 1)),
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
                (friendsViewModel.isLoading == true || count == 0)
                    ? Center(child: CircularProgressIndicator(),)
                :Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // buildListView(friendsViewModel, '찜'),
                      buildListView(friendsViewModel, '친구' ),
                      buildListView(friendsViewModel, '차단'),
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


  ListView buildListView(FriendsProfileViewModel friendsViewModel,String type) {
    // This code block remains unchanged from your original code.
    final _friendsViewModel = friendsViewModel;
    List<UserInfoMinimumDto> UserList; // 찜 또는 친구 또는 차단
    if(type == '찜')
      UserList = _friendsViewModel.pickList;
    else if(type == '친구')
      UserList = _friendsViewModel.friendList;
    else { // 차단
      UserList = _friendsViewModel.blockList;
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: UserList.length,
      itemBuilder: (context, index) {
        final friend = UserList[index];

        return GestureDetector(
          onTap: () async{
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => OthersProfilePage(friend.nickname)),
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
            child: Row(
              children: [
                Container(
                  width: 40.0, // 이미지의 크기 조절
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // 원형 모양을 만들기 위해 사용
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: MemoryImage(base64Decode(friend.image)),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  friend.nickname,
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
}

