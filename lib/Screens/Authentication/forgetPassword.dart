import 'package:ezhyper/fileExport.dart';


class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  AnimationController _loginButtonController;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginButtonController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
  }

  Future<Null> _playAnimation() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _loginButtonController.forward();
    } on TickerCanceled {
      print('[_playAnimation] error');
    }
  }

  Future<Null> _stopAnimation() async {
    try {
      await _loginButtonController.reverse();
      setState(() {
        isLoading = false;
      });
    } on TickerCanceled {
      print('[_stopAnimation] error');
    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    _loginButtonController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return NetworkIndicator(
        child: PageContainer(
            child: Scaffold(
                key: _drawerKey,
                backgroundColor: whiteColor,
                body: BlocListener<ForgetPasswordBloc, AppState>(
                  bloc: forgetPassword_bloc,
                  listener: (context, state) async {
                    var data = state.model as AuthenticationModel;
                    if (state is Loading) {
                      print('login Loading');
                      _playAnimation();
                    } else if (state is Done) {
                      print('login done');
                      _stopAnimation();
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) {
                            return VerificationCode();
                          },
                          transitionsBuilder:
                              (context, animation8, animation15, child) {
                            return FadeTransition(
                              opacity: animation8,
                              child: child,
                            );
                          },
                          transitionDuration: Duration(milliseconds: 10),
                        ),
                      );
                    } else if (state is ErrorLoading) {
                      print('login ErrorLoading');
                      _stopAnimation();
                      Flushbar(
                        messageText: Row(
                          children: [
                            Text(
                              '${data.msg}',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(color: whiteColor),
                            ),
                            Spacer(),
                            Text(
                              translator.translate("Try Again" ),
                              textDirection: TextDirection.rtl,
                              style: TextStyle(color: whiteColor),
                            ),
                          ],
                        ),
                        flushbarPosition: FlushbarPosition.BOTTOM,
                        backgroundColor: redColor,
                        flushbarStyle: FlushbarStyle.FLOATING,
                        duration: Duration(seconds: 6),
                      )..show(_drawerKey.currentState.context);

                    }
                  },
                  child: Directionality(
                    textDirection: translator.currentLanguage == 'ar' ? TextDirection.rtl :TextDirection.ltr,
                    child:  Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * .06,
                            ),
                            topPart(),
                            SizedBox(
                              height: height * .04,
                            ),
                            Container(
                                height: height * .85,
                                width: width,
                                decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                          height * .05,
                                        ),
                                        topLeft: Radius.circular(height * .05))),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      right: width * .075, left: width * .075),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: height * .06,
                                      ),
                                      stepOne(),
                                      textReset(),
                                    //  password(),
                                      SizedBox(
                                        height: height * .06,
                                      ),
                                      emailTextField(),
                                      SizedBox(
                                        height: height * .03,
                                      ),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      nextButton()
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  )
                 ,
                ))));
  }

  Widget topPart() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: translator.currentLanguage == 'ar' ? TextDirection.rtl :TextDirection.ltr,
      child:  Container(
      padding: EdgeInsets.only(left: width * .075),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
      Padding(
      padding: EdgeInsets.only(right: translator.currentLanguage == 'ar'? height * 0.02 : 0 ,left: translator.currentLanguage == 'ar'? 0 : height * 0.02),
        child:InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) {
                    return SignIn();
                  },
                  transitionsBuilder:
                      (context, animation8, animation15, child) {
                    return FadeTransition(
                      opacity: animation8,
                      child: child,
                    );
                  },
                  transitionDuration: Duration(milliseconds: 10),
                ),
              );
            },
            child: Container(
              child: translator.currentLanguage == 'ar' ? Image.asset(
                "assets/images/arrow_right.png",
                height: height * .03,
              ) : Image.asset(
                "assets/images/arrow_left.png",
                height: height * .03,
              ),
            ),
          )),
          SizedBox(
            width: width * .03,
          ),
          Container(
              child: MyText(
            text: translator.translate("forget password").toUpperCase(),
            size:EzhyperFont.primary_font_size,
            weight: FontWeight.bold,
          )),
        ],
      ),
    ),
    )
   ;
  }

  Widget stepOne() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MyText(
            text: translator.translate("Step 1 Of 3"),
            size: height * .028,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget textReset() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width ,
      child: MyText(
        text: translator.translate("Please Enter Your Registered Email Address To Reset Password" ),
        size:EzhyperFont.secondary_font_size,
        weight: FontWeight.bold,
        maxLines: 2,
        align: translator.currentLanguage == 'ar' ?TextAlign.right : TextAlign.left,
      ),
    );
  }

  Widget password() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width * .85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          MyText(
            text: "Password",
            size:EzhyperFont.primary_font_size,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }

  Widget emailTextField() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return StreamBuilder<String>(
        stream: forgetPassword_bloc.email,
        builder: (context, snapshot) {
          return CustomTextField(
            secure: false,
            onchange: forgetPassword_bloc.email_change,
            hint: translator.translate("Email Address *"),
            inputType: TextInputType.emailAddress,
            suffixIcon: null,
            errorText: snapshot.error,
          );
        });
  }

  Widget nextButton() {

    return   StaggerAnimation(
      titleButton: translator.translate("Next").toUpperCase(),
      buttonController: _loginButtonController.view,
      onTap: () {
        if (!isLoading) {
          forgetPassword_bloc.add(sendOtpClick());
        }
      },
    );
  }
}
