
class NavigationState {
  final NavigationItem selectedItem;

  NavigationState(this.selectedItem);
}

enum NavigationItem {
  home,
  flights,
  addFlight,
  analyze,
  settings,

}
