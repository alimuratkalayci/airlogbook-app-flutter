import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../theme/theme.dart';

class AddFavoriteAircraftPage extends StatefulWidget {
  const AddFavoriteAircraftPage({super.key});

  @override
  _AddFavoriteAircraftPageState createState() => _AddFavoriteAircraftPageState();
}

class _AddFavoriteAircraftPageState extends State<AddFavoriteAircraftPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentSnapshot> _aircraftTypes = [];
  List<DocumentSnapshot> _filteredAircraftTypes = [];
  List<String> _selectedAircraftTypes = [];
  String? userId;

  @override
  void initState() {
    super.initState();
    _fetchAircraftTypes();
    _getCurrentUserId();
  }

  void _getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user?.uid;
    });
    _loadSelectedAircraftTypes();
  }

  void _fetchAircraftTypes() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('aircraft_types')
        .orderBy('name') // A'dan Z'ye sıralama
        .get();
    setState(() {
      _aircraftTypes = snapshot.docs;
      _filteredAircraftTypes = _aircraftTypes;
    });
  }

  void _filterAircraftTypes(String query) {
    List<DocumentSnapshot> filtered = _aircraftTypes
        .where((doc) => doc['name'].toString().toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredAircraftTypes = filtered;
    });
  }

  void _addAircraftType(String name) {
    if (!_selectedAircraftTypes.contains(name)) {
      setState(() {
        _selectedAircraftTypes.add(name);
      });
    }
  }

  void _removeAircraftType(String name) {
    setState(() {
      _selectedAircraftTypes.remove(name);
    });
  }

  void _saveFavoriteAircraftTypes() async {
    if (userId != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'favorite_types': _selectedAircraftTypes,
      });
      Navigator.pop(context);
    }
  }

  void _loadSelectedAircraftTypes() async {
    if (userId != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      List<dynamic>? favorites = userDoc['favorite_types'];
      setState(() {
        _selectedAircraftTypes = favorites?.cast<String>() ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackgroundColor,
      appBar: AppBar(
        foregroundColor: Colors.deepOrange,
        backgroundColor: AppTheme.darkBackgroundColor,
        title: Text('Add Favorite Aircraft'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Aircraft Types',
                labelStyle: TextStyle(color: Colors.white), // Etiket rengi
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Kenarlık rengi
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white), // Etkin kenarlık rengi
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepOrange), // Odaklanılmış kenarlık rengi
                ),
                fillColor: Colors.grey[800], // Arka plan rengi
                filled: true, // Arka plan renginin uygulanabilmesi için true olmalı
              ),
              style: TextStyle(color: Colors.white), // Metin rengi
              onChanged: (value) {
                _filterAircraftTypes(value);
              },
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              children: _selectedAircraftTypes.map((type) {
                return Chip(
                  label: Text(type),
                  onDeleted: () {
                    _removeAircraftType(type);
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredAircraftTypes.length,
                itemBuilder: (context, index) {
                  String name = _filteredAircraftTypes[index]['name'];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: ListTile(
                      tileColor: Colors.grey[900], // Arka plan rengi
                      leading: Icon(Icons.airplanemode_active, color: Colors.deepOrange), // İkon
                      title: Text(
                        name,
                        style: TextStyle(
                          color: Colors.white, // Yazı rengi
                          fontSize: 18, // Yazı boyutu
                          fontWeight: FontWeight.bold, // Yazı kalınlığı
                        ),
                      ),
                      trailing: Icon(
                          _selectedAircraftTypes.contains(name)
                              ? Icons.check_circle
                              : Icons.add, color: Colors.deepOrange), // Sağdaki ikon
                      onTap: () {
                        if (_selectedAircraftTypes.contains(name)) {
                          _removeAircraftType(name);
                        } else {
                          _addAircraftType(name);
                        }
                      },
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // İç boşluk
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Köşe yuvarlatma
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveFavoriteAircraftTypes,
                    child: Text('Save', style: TextStyle(color: Colors.deepOrange)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
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
}
