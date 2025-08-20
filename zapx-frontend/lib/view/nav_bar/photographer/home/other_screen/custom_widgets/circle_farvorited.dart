import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CutomFavIcon extends StatefulWidget {
  const CutomFavIcon({super.key});

  @override
  State<CutomFavIcon> createState() => _CutomFavIconState();
}

class _CutomFavIconState extends State<CutomFavIcon> {
  bool favi = false;
  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onTap: (){
        setState(() {
          favi = !favi;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 50,
              width: 6,
              decoration:  BoxDecoration(
                  color:favi? Colors.teal:Colors.white,
                  borderRadius:const  BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4))),
            ),
            Gap(5),
            Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: favi ? Colors.teal :Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.50))
              ),
              child: Center(
                child: Icon(
                  Icons.check,
                  color: favi ? Colors.white : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
