import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  PageController pageController;
  IntroPage(this.pageController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        //실제 앱 출시 시, MediaQuery.maybeOf 상황도 만족시켜야 안정적인 앱이 될 수 있다.
        Size _size = MediaQuery.of(context).size;
        final imgSize = _size.width - 20;
        final posImgSize = imgSize * 0.1;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _mainTitle(context),
                _images(imgSize, posImgSize),
                _title(),
                _subTitle(),
                _startButton(context)
              ],
            ),
          ),
        );
      },
    );
  }


  Column _startButton(BuildContext context) {
    return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                    onPressed: () {
                      pageController.animateToPage(1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                    child: Text(
                      '내 동네 설정하고 시작하기',
                      style: Theme.of(context).textTheme.button,
                    ),
                    style: TextButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor),
                  ),
                ],
              );
  }

  Text _subTitle() {
    return Text(
                '에그마켓은 동네 직거래 마켓이에요.\n내 동네를 설정하고 시작해보세요!',
                style: TextStyle(fontSize: 16),
              );
  }

  Text _title() {
    return Text(
                '우리 동네 중고 직거래 에그 마켓',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              );
  }

  SizedBox _images(double imgSize, double posImgSize) {
    return SizedBox(
                width: imgSize,
                height: imgSize,
                child: Stack(
                  children: [
                    Image.asset('assets/carrot_intro.png'),
                    Positioned(
                        width: posImgSize,
                        height: posImgSize,
                        left: imgSize * 0.45,
                        top: imgSize * 0.45,
                        child: Image.asset('assets/carrot_intro_pos.png')),
                  ],
                ),
              );
  }

  Text _mainTitle(BuildContext context) {
    return Text(
                '에그 마켓',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              );
  }
}
