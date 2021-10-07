import 'package:flutter/material.dart';

typedef void ChangePageCallback(int pageIndex);

class BottomBar extends StatefulWidget{
  BottomBar({Key key, this.pageIndex, this.changePage}) : super(key: key);

  final ChangePageCallback changePage;
  final int pageIndex;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(225, 240, 240, 240),
      height: 85,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(onPressed: (){widget.changePage(0);}, child: null,),
            ElevatedButton(onPressed: (){widget.changePage(1);}, child: null,),
            ElevatedButton(onPressed: (){widget.changePage(2);}, child: null,),
            ElevatedButton(onPressed: (){widget.changePage(3);}, child: null,),
            ElevatedButton(onPressed: (){widget.changePage(4);}, child: null,),
          ],
        ),
      ),
    );
  }
}

