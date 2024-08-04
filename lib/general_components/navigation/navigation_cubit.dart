import 'package:bloc/bloc.dart';
import 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState(NavigationItem.home));

  void selectItem(NavigationItem item) {
    emit(NavigationState(item));
  }
}
