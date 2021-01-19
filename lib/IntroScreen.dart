import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'theme.dart';
import 'MainPage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
class IntroScreen extends StatefulWidget {
  @override
  IntroScreenState createState() => new IntroScreenState();
}
class IntroScreenState extends State<IntroScreen> {
  List data = new List();
  List<Widget> tabs = new List();
  int selectedIndex=0;
  CarouselController buttonCarouselController = CarouselController();
  @override
  void initState() {
    data.add({
      'title': "REDIFINE HEALTHCARE",
      'path': 'Assets/intro1.png',
      'description': "We bring to you redefined healthcare where going to hospital is no longer the need of the arch as you can get professional at the comfort of your home"
    });
    data.add({
      'title': "VIRTUAL HEALTHCARE ASSISTANT",
      'path': 'Assets/intro2.png',
      'description': "To bring to you the latest technology we have self designed chat bot to help you know if you are suffering from any of the on going pandemics and also provide precautions you must follow"
    });
    super.initState();
  }
  void CallbackCarousel(int index,CarouselPageChangedReason reason){
    setState(() {
      selectedIndex = index;
    });
  }
  void renderListCustomTabs() {
    for (int i = 0; i < data.length; i++) {
      var currentSlide = data[i];
      tabs.add(Container(
        child: Center(
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: Container(
                      child: Text(
                        currentSlide['title'],
                        style: heading,
                        textAlign: TextAlign.center,
                      ),
                      margin: EdgeInsets.all(20.0),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(currentSlide['path'])
                      )
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text(
                      currentSlide['description'],
                      style: normal,
                      textAlign: TextAlign.center,
                    ),
                    margin: EdgeInsets.all(20.0),
                  ),
                ],
              )
          ),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    tabs.clear();
    renderListCustomTabs();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          CarouselSlider(
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              scrollDirection: Axis.horizontal,
              height: MediaQuery.of(context).size.height,
              initialPage: 0,
              enableInfiniteScroll: false,
              enlargeCenterPage: true,
              onPageChanged: CallbackCarousel,
            ),
            items: tabs,
          ),
          Positioned(
            bottom: 30,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: (selectedIndex!=data.length-1)?Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: FlatButton(
                      child: Icon(Icons.skip_next,color: Colors.white,size: 32,),
                      color: orange,
                      onPressed: (){
                        setState(() {
                          selectedIndex=data.length-1;
                          buttonCarouselController.jumpToPage(tabs.length-1);
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  Expanded(child: DotsIndicator(
                    dotsCount: tabs.length,
                    position: selectedIndex.toDouble(),
                    decorator: DotsDecorator(
                      color: Colors.deepOrangeAccent.shade100,
                      activeColor: orange,
                      size: const Size.square(9.0),
                      activeSize: const Size(18.0, 9.0),
                      activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    ),
                  )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: FlatButton(
                      child: Icon(Icons.arrow_forward,color: Colors.white,size: 32,),
                      color: orange,
                      onPressed: (){
                        setState(() {
                          selectedIndex++;
                          buttonCarouselController.animateToPage(selectedIndex,duration: Duration(milliseconds: 300),curve: Curves.easeOut);
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ):Row(
                children: [
                  Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: FlatButton(
                      child: Icon(Icons.done,color: Colors.white,size: 32,),
                      color: orange,
                      onPressed: (){
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>MainPage()));
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}