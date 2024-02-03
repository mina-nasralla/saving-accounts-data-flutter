import 'package:flutter/material.dart';
import 'package:valo_accounts/responsive/screen_dimen.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget webscreenlayout;
  final Widget mobilecreenlayout;
  const ResponsiveLayout({super.key, required this.webscreenlayout, required this.mobilecreenlayout});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains){
      if(constrains.maxWidth> webscreen){
        //web screen
        return webscreenlayout;
      }
      return mobilecreenlayout;
    });
  }
}
