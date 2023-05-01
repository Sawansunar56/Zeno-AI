import 'package:flutter/material.dart';
import 'package:frontend/constants/colors.dart';
import 'package:frontend/constants/router_constants.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class StartPage extends StatelessWidget {
  StartPage({super.key});
  final _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 109, 177, 255)),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                child: Text("data"),
              ),
              SizedBox(
                height: 400,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 80, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 200,
                            child: PageView(
                              controller: _controller,
                              scrollDirection: Axis.horizontal,
                              children: [
                                SizedBox(
                                  width: 260,
                                  child: Column(
                                    children: [
                                      Text(
                                        "AI Assistant in your pocket",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 40.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          "AI assistant can answer any of your question. Just ask!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black38,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 260,
                                  child: Column(
                                    children: [
                                      Text(
                                        "AI Assistant in your pocket",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 40.0,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          "AI assistant can answer any of your question. Just ask!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black26,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SmoothPageIndicator(
                                  controller: _controller,
                                  count: 3,
                                  axisDirection: Axis.horizontal,
                                  effect: SlideEffect(
                                    activeDotColor: primaryBlue,
                                    dotHeight: 10,
                                    dotColor: Colors.black26,
                                    dotWidth: 10,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    GoRouter.of(context)
                                        .replaceNamed(RouterConstants.homePage);
                                  },
                                  child: Icon(Icons.arrow_forward),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
