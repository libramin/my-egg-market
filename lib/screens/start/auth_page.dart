import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:my_egg_market/states/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

const Duration duration = Duration(milliseconds: 300);

class _AuthPageState extends State<AuthPage> {
  TextEditingController _phoneNumberController =
      TextEditingController(text: '010');
  TextEditingController _numController = TextEditingController();
  GlobalKey<FormState> _phoneNumFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _NumFormKey = GlobalKey<FormState>();

  VerificationStatus _verificationStatus = VerificationStatus.none;

  String? _verificationId;
  int? _forceResendingToken;

  @override
  void dispose() {
    _numController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        Size size = MediaQuery.of(context).size;

        return IgnorePointer(
          ignoring: _verificationStatus == VerificationStatus.verifying,
          child: Scaffold(
            appBar: AppBar(
              title: Text('전화번호 로그인'),
            ),
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/padlock.png',
                          width: size.width * 0.2,
                          height: size.width * 0.2,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                            '에그마켓은 휴대폰 번호로 가입해요.\n번호는 안전하게 보관 되며\n어디에도 공개되지 않아요.')
                      ],
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _phoneNumFormKey,
                      child: TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          MaskedInputFormatter('000 0000 0000')
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                        ),
                        validator: (phoneNum) {
                          if (phoneNum != null && phoneNum.length == 13) {
                            return null;
                          } else {
                            return '전화번호를 재 확인해주세요';
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                        onPressed: () async {
                          if(_verificationStatus == VerificationStatus.codeSending){
                            return ;
                          }
                          if (_phoneNumFormKey.currentState != null) {
                            bool passed =
                                _phoneNumFormKey.currentState!.validate();
                            if (passed) {
                              String phoneNum = _phoneNumberController.text;
                              phoneNum = phoneNum.replaceAll(' ', '');
                              phoneNum = phoneNum.replaceFirst('0', '');

                              FirebaseAuth auth = FirebaseAuth.instance;
                              setState(() {
                                _verificationStatus =
                                    VerificationStatus.codeSending;
                              });

                              await auth.verifyPhoneNumber(
                                  phoneNumber: '+82$phoneNum',
                                  forceResendingToken: _forceResendingToken,
                                  verificationCompleted:
                                      (PhoneAuthCredential credential) async {
                                    await auth.signInWithCredential(credential);
                                  },
                                  verificationFailed:
                                      (FirebaseAuthException error) {
                                    print(error.message);

                                    setState(() {
                                      _verificationStatus =
                                          VerificationStatus.none;
                                    });
                                  },
                                  codeSent: (String verificationId,
                                      int? forceResendingToken) async {
                                    setState(() {
                                      _verificationStatus =
                                          VerificationStatus.codeSent;
                                    });

                                    _verificationId = verificationId;
                                    _forceResendingToken = forceResendingToken;
                                  },
                                  codeAutoRetrievalTimeout:
                                      (String verificationId) {});
                            }
                          }

                          //임시저장 테스트
                          // _getAddress();
                        },
                        child: (_verificationStatus ==
                                VerificationStatus.codeSending)
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text('인증문자 발송')),
                    SizedBox(height: 20),
                    AnimatedOpacity(
                      duration: duration,
                      opacity: (_verificationStatus == VerificationStatus.none)
                          ? 0
                          : 1,
                      curve: Curves.easeInOut,
                      child: AnimatedContainer(
                        duration: duration,
                        height: _getVerificationHeight(_verificationStatus),
                        curve: Curves.easeInOut,
                        child: Form(
                          key: _NumFormKey,
                          child: TextFormField(
                            controller: _numController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [MaskedInputFormatter('000000')],
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                            ),
                            validator: (num) {
                              if (num != null && num.length == 6) {
                                return null;
                              } else {
                                return '인증 번호를 재 확인해주세요';
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                        duration: duration,
                        height: _getVerificationBtnHeight(_verificationStatus),
                        curve: Curves.easeInOut,
                        child: TextButton(
                            onPressed: () {
                              if (_NumFormKey.currentState != null) {
                                bool sucess =
                                    _NumFormKey.currentState!.validate();
                                if (sucess) {
                                  attempVerify(context);
                                }
                              }
                            },
                            child: (_verificationStatus ==
                                    VerificationStatus.verifying)
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text('인증'))),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  double _getVerificationHeight(VerificationStatus status) {
    if (status == VerificationStatus.none) {
      return 0;
    } else {
      return 70;
    }
  }

  double _getVerificationBtnHeight(VerificationStatus status) {
    if (status == VerificationStatus.none) {
      return 0;
    } else {
      return 48;
    }
  }

  void attempVerify(BuildContext context) async {
    setState(() {
      _verificationStatus = VerificationStatus.verifying;
    });

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!, smsCode: _numController.text);

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('faile!!');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('코드 재확인')));
    }

    setState(() {
      _verificationStatus = VerificationStatus.verificationDone;
    });
  }

  _getAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final String? address = prefs.getString('address') ?? '';
    print('my data : $address');
  }
}

enum VerificationStatus {
  none,
  codeSending,
  codeSent,
  verifying,
  verificationDone
}
