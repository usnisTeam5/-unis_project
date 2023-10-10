import 'package:flutter/material.dart';
import '../css/css.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoinWithdrawalScreen extends StatefulWidget {
  @override
  _CoinWithdrawalScreenState createState() => _CoinWithdrawalScreenState();
}

class _CoinWithdrawalScreenState extends State<CoinWithdrawalScreen> {
  int currentCoin = 10000;
  int coinWithdraw = 0;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController accountController = TextEditingController();
  bool agreeToProvideInfo = false;

  Future<void> _selectNumberOfCoin() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        String? selectedValue; // 선택된 인원

        return AlertDialog(
          title: Text('금액 선택'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true, // 리스트의 크기를 내용에 맞게 조절
              itemCount: 10, // 5개의 항목 (1명 ~ 5명)
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text('${formatNumber((index + 1)*10000)} 원'),
                  onTap: () {
                    setState(() {
                      coinWithdraw  = (index + 1)*10000;
                    });
                    Navigator.of(context).pop(); // 선택 후 다이얼로그 닫기
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final width = min(MediaQuery
        .of(context)
        .size
        .width, 500.0);
    final height = min(MediaQuery
        .of(context)
        .size
        .height, 700.0);

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
            width: width, text: '현금 인출', tSize: 0.06, tStyle: 'Bold'),
      ),
      body: SingleChildScrollView(
        child:  Padding(
          //height: height - AppBar().preferredSize.height - MediaQuery.of(context).padding.top,
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              // Coin Info
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.grey[200],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _coinInfoRow("내 코인", currentCoin),
                    SizedBox(height: 5,),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('총 인출 금액', style: TextStyle(fontFamily: 'Bold')),
                        Spacer(),
                        coinWithdraw == 0
                            ? GestureDetector(
                          onTap: _selectNumberOfCoin,
                          child: Container(
                            //height: 30,
                            //width: 70,
                            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                            padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              border: Border.all(color: Colors.grey[300]!),  // 경계선 추가 (원하시면 제거 가능)
                              borderRadius: BorderRadius.circular(10.0), // 모서리를 둥글게
                            ),
                            child: Center(
                              child: Text(
                                '${formatNumber(coinWithdraw)} ',
                                style: TextStyle(
                                  //fontSize: 18.0,
                                  fontFamily: 'Bold',
                                ),
                              ),
                            ),
                          ),
                        )
                        : TextButton(
                          onPressed: _selectNumberOfCoin,
                          child: Text(
                          '${formatNumber(coinWithdraw)} ',
                          style: TextStyle(
                            //fontSize: 18.0,
                            fontFamily: 'Bold',
                          ),
                        ),
                        ),
                        Text(' 원  ', style: TextStyle(fontFamily: 'Bold')),
                      ],
                    ),
                    //_coinInfoRow("총 인출 금액", coinWithdraw),
                    SizedBox(height: 10,),
                    Divider(height: 1.0,),
                    SizedBox(height: 10,),
                    (currentCoin - coinWithdraw) >= 0 ? _coinInfoRow("인출 후 코인", currentCoin - coinWithdraw)
                                                      : Text('포인트 부족 ', style: TextStyle(fontFamily: 'Bold',color: Colors.red,fontSize: 15)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Bank Info
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.grey[200],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("정보입력", style: TextStyle(fontFamily: 'Bold')),
                    SizedBox(height: 10,),
                    _textField("이름", nameController),
                    _textField("은행명", bankController),
                    _textField("계좌번호", accountController),
                  ],
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: agreeToProvideInfo,
                    onChanged: (bool? value) {
                      setState(() {
                        agreeToProvideInfo = value!;
                      });
                    },
                  ),
                  Text("개인정보제공 동의", style: TextStyle(fontFamily: 'Bold')),
                ],
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
                      if (coinWithdraw == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(content: Text("인출 금액을 설정해주세요."));
                            }
                        );
                        return; // early return
                      }

                      if (nameController.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(content: Text("이름을 입력해주세요."));
                            }
                        );
                        return; // early return
                      }

                      if (bankController.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(content: Text("은행명을 입력해주세요."));
                            }
                        );
                        return; // early return
                      }

                      if (accountController.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(content: Text("계좌번호를 입력해주세요."));
                            }
                        );
                        return; // early return
                      }

                      if (!agreeToProvideInfo) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(content: Text("개인정보제공 동의를 해주세요."));
                            }
                        );
                        return; // early return
                      }
                      print(nameController);
                      print(bankController);
                      print(accountController);
                      String studyTitle = "현금 인출";
                      if(currentCoin - coinWithdraw < 0){
                        showDialog(context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  content: Text(
                                  "포인트가 부족합니다")
                              );
                            }
                        );
                      }
                      else if (agreeToProvideInfo == false)
                        showDialog(context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(content: Text(
                                  "개인정보제공 동의를 해주세요"));
                            }
                        );
                      else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              //title: Text('스터디 탈퇴',style: TextStyle(fontFamily: 'Round'),),
                              content: Text("'$studyTitle' 을 정말 하시겠습니까?"),
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
                                    // 탈퇴
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
                          '현금 인출',
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
      ),
    );
  }

  Widget _coinInfoRow(String title, int coin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontFamily: 'Bold')),
        Row(
          children: [
            Text('${formatNumber(coin)}   ', style: TextStyle(fontFamily: 'Bold')),
            Padding(
              padding: EdgeInsets.only(top: 3),
              child: SvgPicture.asset('image/point.svg', width: 20, height: 28, color: Colors.blue[400],),
            ),
          ],
        ),
      ],
    );
  }

  Widget _textField(String labelText, TextEditingController controller) {
    var inputFormatters;
    var keyboardType = TextInputType.text;
    int maxLength = 20;

    if (labelText == "계좌번호") {
      inputFormatters = <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly, // 숫자만 입력 가능
      ];
      keyboardType = TextInputType.number;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
          counterText: '', // 오른쪽 아래에 나타나는 글자 수 카운터를 숨김
        ),
        style: TextStyle(fontFamily: 'Bold'),
        maxLength: maxLength,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
      ),
    );
  }
}
String formatNumber(int number) {
  final formatter = NumberFormat('#,###');
  return formatter.format(number);
}