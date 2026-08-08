import 'package:flutter/material.dart';

class HeadingSix extends StatelessWidget {
  final String? headingSix;
  final double? heaingSize;
  final FontWeight? headingWeight;
  final Color? headingColor;
  const HeadingSix(
      {Key? key,
      this.headingSix,
      this.heaingSize,
      this.headingWeight,
      this.headingColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(headingSix!,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: headingWeight,
              fontSize: heaingSize,
              color: headingColor,
            ));
  }
}
