
class NavigationState {
  final NavigationItem selectedItem;

  NavigationState(this.selectedItem);
}

enum NavigationItem {
  home,
  chat,
  addFlight,
  wallet,
  settings,

}
