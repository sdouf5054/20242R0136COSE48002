import 'package:structure/components/data_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:structure/config/palette.dart';

class DataField extends StatefulWidget {
  final String mainText;
  final String subText;
  final String? unit;
  final TextEditingController controller;
  final bool? isL;
  final bool? isA;
  final void Function(String)? onChangeFunc;
  final bool isFinal;
  final GlobalKey<FormState>? formKey;
  final String? Function(String?)? validateFunc;
  final VoidCallback? onEditingComplete;
  const DataField({
    super.key,
    required this.mainText,
    required this.subText,
    this.unit,
    required this.controller,
    this.isL,
    this.isA,
    this.isFinal = false,
    this.onChangeFunc,
    this.formKey,
    this.validateFunc,
    this.onEditingComplete,
  });

  @override
  State<DataField> createState() => _DataFieldState();
}

class _DataFieldState extends State<DataField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (!_focusNode.hasFocus) {
      widget.formKey?.currentState?.validate();
    }
    if (_focusNode.hasFocus != _isFocused) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // 제목
        DataTitle(korText: widget.subText, engText: widget.mainText),
        SizedBox(height: 16.h),

        // 입력 textfield
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          textInputAction:
              widget.isFinal ? TextInputAction.done : TextInputAction.next,
          textAlign: TextAlign.left,
          validator: widget.validateFunc,
          onEditingComplete: widget.onEditingComplete,
          cursorColor: Palette.primary,
          keyboardType: TextInputType.number,
          onChanged: widget.onChangeFunc,
          decoration: InputDecoration(
            filled: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
            fillColor: _isFocused ? Colors.white : Colors.grey[200], // 배경색 설정
            errorStyle: Palette.h6.copyWith(color: Palette.error),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: const BorderSide(color: Palette.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: const BorderSide(color: Palette.error),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide.none, // 기본 테두리 없음
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: const BorderSide(
                color: Palette.primary, // 초록색 테두리 설정
                width: 1, // 테두리 두께 설정
              ),
            ),
            suffixIcon: widget.unit != null
                ? Container(
                    width: 24.w, // 필요한 너비로 조정
                    height: 24.h,
                    alignment: Alignment.center, // 오른쪽 끝에 맞춤
                    child: Text(
                      widget.unit!,
                      style:
                          Palette.h4Regular.copyWith(color: Palette.secondary),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

// class _PercentageInputFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     double parsedValue = double.tryParse(newValue.text) ?? 0.0;

//     if (parsedValue < 0 || parsedValue > 100 || newValue.text.length > 7) {
//       return oldValue;
//       // return newValue;
//     }

//     return newValue;
//   }
// }

// class RangeInputFormatter extends TextInputFormatter {
//   final int minValue;
//   final int maxValue;
//   final int length;
//   const RangeInputFormatter({
//     required this.minValue,
//     required this.maxValue,
//     required this.length,
//   });
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     if (newValue.text.length >= length) {
//       double? parsedValue = double.tryParse(newValue.text);
//       if (parsedValue == null ||
//           parsedValue < minValue ||
//           parsedValue > maxValue) {
//         return oldValue;
//       }
//     }
//     return newValue;
//   }
// }
