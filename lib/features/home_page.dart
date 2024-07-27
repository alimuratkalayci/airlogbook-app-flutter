import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackgroundColor,
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Son üç çekiliş!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16,),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CarouselSlider(
                  options: CarouselOptions(height: 150, autoPlay: true),
                  items: [1, 2, 3].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              print(Text('tıklandı'));
                              //TODO SONRA EKLE
                              /* Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const SignUpPage()),
                              ); */
                            },

                            child: Card(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
