import 'package:ezhyper/Constants/colors.dart';
import 'package:ezhyper/Constants/static_data.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerNotification extends StatelessWidget {
final int length;
ShimmerNotification({this.length=3});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ListView.builder(
        itemCount: length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(StaticData.get_width(context) * 0.03),
            child: Shimmer.fromColors(
                baseColor: greyColor,
                highlightColor: Colors.grey[350],
                child
                    : Container(
                  decoration: BoxDecoration(
                      color: greyColor,
                      borderRadius: BorderRadius.circular(5.0)),

                  height: 100,
                  width: width * 0.75,

                )

            ),
          );

        }
    );



  }
}
