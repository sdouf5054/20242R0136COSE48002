import 'package:structure/config/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataField extends StatelessWidget {
  final String mainText;
  final String subText;
  final String? unit;
  final TextEditingController controller;
  final bool? isPercent;
  final int? isFinal;

  const DataField({
    super.key,
    required this.mainText,
    required this.subText,
    this.unit,
    required this.controller,
    this.isPercent,
    this.isFinal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 42.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            child: Row(
              children: [
                Text(
                  mainText,
                  style: TextStyle(
                    color: const Color(0xFF000000),
                    fontSize: 36.sp,
                  ),
                ),
                Text(
                  subText,
                  style: TextStyle(
                    color: Palette.greyTextColor,
                    fontSize: 30.sp,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 635.w,
                child: Focus(
                  onFocusChange: (hasFocus) {
                    // rebuild the widget on focus change
                    (context as Element).markNeedsBuild();
                  },
                  child: Builder(
                    builder: (context) {
                      final isFocused = Focus.of(context).hasFocus;
                      return TextFormField(
                        keyboardType: TextInputType.number,
                        textInputAction:
                            isFinal != null ? null : TextInputAction.next,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isFocused
                              ? Colors.white
                              : Colors.grey[200], // 배경색 설정
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none, // 기본 테두리 없음
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.green, // 초록색 테두리 설정
                              width: 1, // 테두리 두께 설정
                            ),
                          ),
                          suffixIcon: unit != null
                              ? Container(
                                  width: 20.w, // 필요한 너비로 조정
                                  height: 20.h,
                                  alignment: Alignment.center, // 오른쪽 끝에 맞춤
                                  child: Text(
                                    unit!,
                                    style: TextStyle(
                                      color: const Color(0xFF686868),
                                      fontSize: 30.sp,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        controller: controller,
                        textAlign: TextAlign.left,
                        inputFormatters: isPercent != null && isPercent == true
                            ? [
                                _PercentageInputFormatter(),
                              ]
                            : [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^-?\d{0,8}(\.\d{0,4})?')),
                              ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PercentageInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    double parsedValue = double.tryParse(newValue.text) ?? 0.0;

    if (parsedValue < 0 || parsedValue > 100 || newValue.text.length > 7) {
      return oldValue;
    }

    return newValue;
  }
}
