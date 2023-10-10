import 'package:flutter/material.dart';
import '../css/css.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';


class PointChargeScreen extends StatefulWidget {
  @override
  _PointChargeScreenState createState() => _PointChargeScreenState();
}

class _PointChargeScreenState extends State<PointChargeScreen> {
  int? _selectedPoint;
  @override
  Widget build(BuildContext context) {

    final width = min(MediaQuery.of(context).size.width,500.0);
    final height = min(MediaQuery.of(context).size.height,700.0);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left, size: 30,),

          color: Colors.grey,
          onPressed: () {
            Navigator.pop(context); // 로그인 화면으로 되돌아가기
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        //centerTitle: true,
        // Title을 중앙에 배치
        title: GradientText(
            width: width, text: '포인트 충전', tSize: 0.06, tStyle: 'Bold'),
        actions: [
          Row(
            children: [
              SizedBox(width: 5),
              Text(
                '1,000,000',
                style: TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Bold'),
              ),
              SizedBox(width: 20), // 추가적인 공간을 위해
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: SvgPicture.asset('image/point.svg', width: 20, height: 28, color: Colors.blue[400],),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _pointOption(1000),
                  _pointOption(2000),
                  _pointOption(5000),
                  _pointOption(10000),
                  _pointOption(30000),
                  _pointOption(50000),
                  _pointOption(100000),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(top: 20.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                gradient: MainGradient(),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: () {
                    if (_selectedPoint != null) {
                      String formattedPoint = formatNumber(_selectedPoint!);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text("'$formattedPoint' 포인트를 충전하시겠습니까?"),  // 수정된 부분
                            actions: <Widget>[
                              TextButton(
                                child: Text('취소'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('확인'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  // 실제 포인트 충전 로직을 여기에 추가할 수 있습니다.
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Text("충전할 포인트를 선택해주세요."),  // 선택되지 않았을 때의 안내 문구
                            actions: <Widget>[
                              TextButton(
                                child: Text('확인'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        '충전 하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Bold',
                          fontSize: width * 0.05,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pointOption(int point) {
    return GestureDetector( // InkWell도 사용 가능
      onTap: () {
        setState(() {
          _selectedPoint = point;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0,horizontal: 20.0),
        padding: const EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
        decoration: BoxDecoration(
          color: _selectedPoint == point ? Colors.blue[100] : Colors.grey[200], // 선택된 포인트에 따라 색상 변경
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(width: 10),
                Text('${formatNumber(point)}', style: TextStyle(fontFamily: 'Bold',color: Colors.grey[500],fontSize: 16),),
                Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: SvgPicture.asset('image/point.svg', width: 20, height: 28, color: Colors.blue[400],),
                ),
              ],
            ),
            Text('${formatNumber(point)} 원' , style: TextStyle(fontFamily: 'Bold',color: Colors.grey[500],fontSize: 16),),
          ],
        ),
      ),
    );
  }
}

String formatNumber(int number) {
  final formatter = NumberFormat('#,###');
  return formatter.format(number);
}
