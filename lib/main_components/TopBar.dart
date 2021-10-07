import 'package:flutter/material.dart';

class TopBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(225, 250, 250, 250),
      height: 45,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text('HKU Guide',
              style: TextStyle(
                color: Color.fromARGB(255, 50, 50, 50),
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
            //Positioned(right: 0, child: Text('Set')),
          ],
        ),
      ),
    );
  }
}