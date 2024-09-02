class MenuModel {
  String? icon;
  String? title;
  String? route;
  bool isLogout;

  MenuModel({required this.icon, required this.title, required this.route, this.isLogout = false});
}