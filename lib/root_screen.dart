import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'general_components/navigation/navigation.dart';
import 'general_components/navigation/navigation_cubit.dart';


class RootScreen extends StatelessWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: RootScreenUI(),
    );
  }
}
