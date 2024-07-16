import 'package:flutter/material.dart';
import 'package:formafit/authentication/Onboarding/activity.dart';
import 'package:formafit/authentication/Onboarding/age.dart';
import 'package:formafit/authentication/Onboarding/gender.dart';
import 'package:formafit/authentication/Onboarding/gools.dart';
import 'package:formafit/authentication/Onboarding/height.dart';
import 'package:formafit/authentication/Onboarding/weight.dart';
import 'package:formafit/authentication/Onboarding/wellcome.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
class OnboardingPage extends StatefulWidget {


  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

    final PageController _pageController = PageController();

  int currentPageIndex = 0;

  void nextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

    void previousPage() {
    _pageController.previousPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: [
              WellcomePage(),
    
              GenderSelectionPage(onNext: nextPage,isSaveOrNext: true,),
              AgeSelectionPage(onNext: nextPage, onPrevious: previousPage,isSaveOrNext: true,),
              HeightSelectionPage(onNext: nextPage, onPrevious: previousPage,isSaveOrNext: true,),
              WeightSelectionPage(onNext: nextPage, onPrevious: previousPage,isSaveOrNext: true,),
              ActivityLevelPage(onNext: nextPage, onPrevious: previousPage,isSaveOrNext: true,),
              GoalSelectionPage(onFinish: nextPage, onPrevious: previousPage,isSaveOrNext: true,),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 7,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),

    );
  }
}