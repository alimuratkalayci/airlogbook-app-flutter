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
      /*
      actions: [
        IconButton(
          onPressed: () {
            context.read<DrawerCubit>().getNavBarItem(DrawerItem.notification);
          },
          icon: const Icon(
            Icons.notifications_none,
            color: Colors.white,
          ),
        ),
      ],
       */
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
