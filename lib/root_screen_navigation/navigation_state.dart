
class NavigationState {
  final NavigationItem selectedItem;

  NavigationState(this.selectedItem);
}

enum NavigationItem {
  home,
  giveaways,
  chat,
  wallet,
  settings
}
