import 'package:flutter/material.dart';

class CekilisAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CekilisAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Center(
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            // Bildirim simgesine tıklama işlemi
            // Burada bildirimlerle ilgili işlevi ekleyebilirsiniz
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Notifications clicked!')),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
