import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:structure/config/pallete.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class PartEval extends StatelessWidget {
  PartEval({
    super.key,
    required this.idx,
    required this.value,
    required this.selectedText,
    required this.onChanged,
  });

  final List<String> imagePath = [
    'assets/images/eval_Marbling.png',
    'assets/images/eval_Color.png',
    'assets/images/eval_Texture.png',
    'assets/images/eval_SurfaceMoisture.png',
    'assets/images/eval_Overall.png'
  ];
  final List<String>? selectedText;
  final double value;
  final Function(dynamic value)? onChanged;
  final int idx;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 기준 이미지
          Image.asset(
            imagePath[idx],
            width: double.infinity,
            height: 68.h,
            fit: BoxFit.fitWidth,
          ),

          // 기준 텍스트
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 2; i < 7; i++)
                SizedBox(
                  width: 123.w,
                  child: Text(
                    selectedText![i],
                    style: Palette.h5,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),

          // 슬라이더
          SfSliderTheme(
            data: const SfSliderThemeData(
              tooltipBackgroundColor: Palette.meatRegiBtnBg,
            ),
            child: SfSlider(
              min: 1.0,
              max: 10.0,
              value: value,
              interval: 1,
              showTicks: true,
              showLabels: false,
              activeColor: Palette.meatRegiBtnBg,
              inactiveColor: Palette.notEditableBg,
              enableTooltip: true,
              onChanged: onChanged,
              tooltipTextFormatterCallback:
                  (dynamic actualValue, String formattedText) {
                final double newValue = actualValue;
                return newValue.toStringAsFixed(1);
              },
            ),
          ),
        ],
      ),
    );
  }
}
