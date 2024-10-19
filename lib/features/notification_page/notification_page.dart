import 'package:flutter/material.dart';

class MyAccountPage extends StatefulWidget {
  @override
  State<MyAccountPage> createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'My Account',
            style: TextStyle(color: Color(0xff121212)),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Color(0xff121212),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          children: [
            Stack(
              children: [
                Container(
                  color: Color(0xffFAF9FD),
                  height: 74,
                  width: double.infinity,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: Center(
                          child: CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                            'assets/images/photo.png'), // assetler içindeki resimlerinizden seçebilirsiniz.
                      )),
                    ),
                    Center(
                      child: TextButton(
                        child: Text(
                          'Change Picture',
                          style: TextStyle(
                            color: Color(0xff54408C),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ), //NAME
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Color(0xffE8E8E8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      hintText: 'John',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ), //EMAIL
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Color(0xffE8E8E8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      hintText: 'Johndoe@email.com',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ), //PHONE NUMBER
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Color(0xffE8E8E8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        color: Color(0xff54408C),
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      hintText: '(+1) 234 567 890',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                'Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ), //PASSWORD
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: Color(0xffE8E8E8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    obscureText: _obscureText,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      hintText: '******',
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Save Changes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xff54408C),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(48),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
