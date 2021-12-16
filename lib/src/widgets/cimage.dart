import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_chalan/src/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 

class Cimage extends StatelessWidget {
  String? image_url;
  Cimage({this.image_url});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CachedNetworkImage(
        width: MediaQuery.of(context).size.width,
        imageUrl: image_url!,
        // errorWidget: (context, url, error) => Container(
        //     width: 50,
        //     height: 50,
        //     color: grey,
        //     child: Center(
        //       child: Text(
        //         name[0].toUpperCase(),
        //         style: TextStyle(color: dark),
        //       ),
        //     )),
        placeholder: (context, value) {
          return Container(
            width: 46,
            height: 46,
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(dark),
              backgroundColor: grey,
            ),
          );
        },
      ),
    );
  }
}

Widget cimage({required String image_url, BuildContext? context}) {
  return CachedNetworkImage(
    imageUrl: image_url,
    fit: BoxFit.cover,
    // errorWidget: (context, url, error) => Container(
    //     width: 50,
    //     height: 50,
    //     color: grey,
    //     child: Center(
    //       child: Text(
    //         name[0].toUpperCase(),
    //         style: TextStyle(color: dark),
    //       ),
    //     )),
    placeholder: (context, value) {
      return Container(
        width: 46,
        height: 46,
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(dark),
          backgroundColor: grey,
        ),
      );
    },
  );
}
