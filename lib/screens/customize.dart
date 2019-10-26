import 'package:flutter/material.dart';
import 'package:speed_cube_timer/components/customize/mesh_thumbnail.dart';
import 'package:speed_cube_timer/components/navigation/top_navbar.dart';
import 'package:speed_cube_timer/components/text_button.dart';
import 'package:speed_cube_timer/shared/background.dart';
import 'package:speed_cube_timer/shared/custom_list_view.dart';

class Customize extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TopNavbar("Customize", "assets/icons/sliders.svg", "sliders icon"),
            CustomListView(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: MediaQuery.of(context).size.width * 0.05),
                children: <Widget>[
                  TextButton("Unlock All Customizations &", "Remove Ads", () => null),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      MeshThumbnail("assets/gradients/mesh/thumbnail_gradient0.jpg", () => null),
                      MeshThumbnail("assets/gradients/mesh/thumbnail_gradient0.jpg", () => null),
                      MeshThumbnail("assets/gradients/mesh/thumbnail_gradient0.jpg", () => null),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      MeshThumbnail("assets/gradients/mesh/thumbnail_gradient0.jpg", () => null),
                      MeshThumbnail("assets/gradients/mesh/thumbnail_gradient0.jpg", () => null),
                      MeshThumbnail("assets/gradients/mesh/thumbnail_gradient0.jpg", () => null),
                    ],
                  ),
                ]
              )
            )
          ],
        )
      )
    );
  }
}