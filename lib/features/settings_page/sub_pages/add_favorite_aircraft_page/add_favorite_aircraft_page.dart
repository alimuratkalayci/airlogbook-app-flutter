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
        .orderBy('name')
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
      backgroundColor: AppTheme.BackgroundColor,
      appBar: AppBar(
        foregroundColor: AppTheme.TextColorWhite,
        backgroundColor: AppTheme.AccentColor,
        title: Text('Add Favorite Aircraft'),
      ),
      body: Column(
        children: [
          Container(
            color: AppTheme.BackgroundColor,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Aircraft Types',
                    labelStyle: TextStyle(color: AppTheme.AccentColor), // Etiket rengi
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppTheme.AccentColor,width: 2), // Kenarlık rengi
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppTheme.AccentColor,width: 2), // Etkin kenarlık rengi
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppTheme.AccentColor,width: 2), // Odaklanılmış kenarlık rengi
                    ),
                    fillColor: AppTheme.BackgroundColor, // Arka plan rengi
                    filled: true,
                  ),
                  style: TextStyle(color: AppTheme.AccentColor), // Metin rengi
                  onChanged: (value) {
                    _filterAircraftTypes(value);
                  },
                ),
                SizedBox(height: 16,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Yatay kaydırma yönü
                  child: Row(
                    children: _selectedAircraftTypes.map((type) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0), // Sağ boşluk için padding
                        child: Chip(
                          deleteIconColor: AppTheme.TextColorWhite,
                          backgroundColor: AppTheme.AccentColor,
                          shape: RoundedRectangleBorder(side: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(16)),
                          label: Text(
                            type,
                            style: TextStyle(color: AppTheme.TextColorWhite),
                          ),
                          onDeleted: () {
                            _removeAircraftType(type);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),

              ],),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: _filteredAircraftTypes.length,
              itemBuilder: (context, index) {
                String name = _filteredAircraftTypes[index]['name'];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: ListTile(
                    tileColor: AppTheme.BackgroundColor, // Arka plan rengi
                    leading: Icon(Icons.airplanemode_active, color: AppTheme.AccentColor,size: 36,), // İkon
                    title: Text(
                      name,
                      style: TextStyle(
                        color: AppTheme.AccentColor, // Yazı rengi
                        fontSize: 18, // Yazı boyutu
                        fontWeight: FontWeight.bold, // Yazı kalınlığı
                      ),
                    ),
                    trailing: Icon(
                      size: 36,
                      _selectedAircraftTypes.contains(name) ? Icons.check : Icons.add,
                      color: _selectedAircraftTypes.contains(name) ? Colors.green : AppTheme.AccentColor,
                    ),
                    onTap: () {
                      if (_selectedAircraftTypes.contains(name)) {
                        _removeAircraftType(name);
                      } else {
                        _addAircraftType(name);
                      }
                    },
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // İç boşluk
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppTheme.AccentColor,width: 2),
                      borderRadius: BorderRadius.circular(16), // Köşe yuvarlatma
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            color: AppTheme.BackgroundColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16,8,16,8),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveFavoriteAircraftTypes,
                      child: Text('Save', style: TextStyle(color: AppTheme.TextColorWhite)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.AccentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
