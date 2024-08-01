import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/theme.dart';
import 'dart:io';

class AddGiveawayPage extends StatefulWidget {
  const AddGiveawayPage({Key? key}) : super(key: key);

  @override
  _AddGiveawayPageState createState() => _AddGiveawayPageState();
}

class _AddGiveawayPageState extends State<AddGiveawayPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(); // Bilet fiyatı için controller eklendi
  String? selectedItem;
  String? selectedDuration;
  File? _image;
  final List<String> items = ['Item 1', 'Item 2', 'Item 3']; // Çekiliş için eşyalar
  final List<String> durations = ['7 gün', '15 gün', '30 gün'];

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: AppTheme.darkBackgroundColor,
        title: Text(
          'Çekiliş ekle',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Çekiliş Başlığı',
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.numberWithOptions(decimal: true), // Bilet fiyatı için numerik klavye
              decoration: InputDecoration(
                hintText: 'Bilet adet fiyatı', // Buraya bilet fiyatı için açıklama eklendi
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Çekiliş için eşya seçin:', style: TextStyle(color: Colors.white)),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 72),
                  child: DropdownButton<String>(
                    value: selectedItem,
                    items: items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedItem = newValue;
                      });
                    },
                    hint: Text('Eşya seçin', style: TextStyle(color: Colors.white)),
                    selectedItemBuilder: (BuildContext context) {
                      return items.map<Widget>((String item) {
                        return Text(
                          item,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Çekiliş süresi seçin:', style: TextStyle(color: Colors.white)),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 72),
                  child: DropdownButton<String>(
                    value: selectedDuration,
                    items: durations.map((String duration) {
                      return DropdownMenuItem<String>(
                        value: duration,
                        child: Text(duration),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedDuration = newValue;
                      });
                    },
                    hint: Text('Süre seçin', style: TextStyle(color: Colors.white)),
                    selectedItemBuilder: (BuildContext context) {
                      return durations.map<Widget>((String duration) {
                        return Text(
                          duration,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Resim seçin:', style: TextStyle(color: Colors.white)),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 72),
                  child: IconButton(
                    icon: Icon(Icons.image, color: Colors.white),
                    onPressed: _pickImage,
                  ),
                ),
              ],
            ),
            if (_image != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Image.file(
                    _image!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addGiveaway,
                    child: Text(
                      'Çekilişi ekle',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.darkAccentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addGiveaway() async {
    if (_titleController.text.isEmpty ||
        selectedItem == null ||
        selectedDuration == null ||
        _image == null ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lütfen tüm alanları doldurun ve resim seçin'),
      ));
      return;
    }

    int durationInDays;
    if (selectedDuration == '7 gün') {
      durationInDays = 7;
    } else if (selectedDuration == '15 gün') {
      durationInDays = 15;
    } else {
      durationInDays = 30;
    }

    DateTime startDate = DateTime.now();
    DateTime endDate = startDate.add(Duration(days: durationInDays));

    try {

      String imageUrl = await _uploadImage();

      // Çekilişi Firestore'a ekleme
      DocumentReference giveawayRef = await FirebaseFirestore.instance.collection('giveaways').add({
        'giveawayId': '',
        'title': _titleController.text,
        'item': selectedItem,
        'duration': selectedDuration,
        'start_date': startDate,
        'end_date': endDate,
        'status': 'active',
        'imageUrl': imageUrl,
        'ticket_price': double.parse(_priceController.text),
        'participants': {},
      });

      String giveawayId = giveawayRef.id;


      await giveawayRef.update({
        'giveawayId': giveawayId,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Çekiliş başarıyla eklendi!'),
      ));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Çekiliş eklenirken hata oluştu: $e'),
      ));
    }
  }

  Future<String> _uploadImage() async {
    if (_image == null) {
      throw Exception('Resim seçilmedi');
    }

    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('giveaway_images')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = ref.putFile(_image!);
      final snapshot = await uploadTask.whenComplete(() {});
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception('Resim yüklenirken hata oluştu: $e');
    }
  }
}
