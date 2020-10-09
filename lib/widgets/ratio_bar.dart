
import 'package:flutter/cupertino.dart';
import 'package:gatabank/config.dart';

class RatioBar extends StatelessWidget {
  final int ratio1;
  final int ratio2;
  const RatioBar(this.ratio1, this.ratio2);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: ratio1,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: Container(
                    height: 10,
                    width: double.infinity,
                    color: App.theme.colors.background1
                ),
              ),
            )
        ),
        Expanded(
          flex: ratio2,
          child: Padding(
            padding: EdgeInsets.only(left: 2, right: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: Container(
                  height: 10,
                  width: double.infinity,
                  color: App.theme.colors.interest
              ),
            ),
          ),
        )
      ],
    );
  }
}