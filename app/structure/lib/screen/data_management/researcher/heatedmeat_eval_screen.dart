//
//
// 가열육 관능평가 페이지(View)
//
//

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:structure/components/custom_app_bar.dart';
import 'package:structure/components/loading_screen.dart';
import 'package:structure/components/main_button.dart';
import 'package:structure/components/part_eval.dart';
import 'package:structure/viewModel/data_management/researcher/heatedmeat_eval_view_model.dart';

class HeatedMeatEvaluation extends StatefulWidget {
  const HeatedMeatEvaluation({super.key});

  @override
  State<HeatedMeatEvaluation> createState() => _HeatedMeatEvaluation();
}

class _HeatedMeatEvaluation extends State<HeatedMeatEvaluation>
    with SingleTickerProviderStateMixin {
  // 가열육 관능평가 label
  List<List<String>> text = [
    ['Flavor', '풍미', '약간', '', '약간 풍부함', '', '풍부함'],
    ['Juiciness', '다즙성', '퍽퍽함', '', '보통', '', '다즙합'],
    ['Tenderness', '연도', '질김', '', '보통', '', '연함'],
    ['Umami', '표면육즙', '약함', '', '보통', '', '좋음'],
    ['Palatability', '기호도', '나쁨', '', '보통', '', '좋음'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: '가열육 관능평가',
        backButton: true,
        closeButton: false,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 'PartEval' 컴포넌트를 이용하여 관능평가 항목을 정의.
                SizedBox(height: 10.h),
                Row(
                  children: [
                    SizedBox(width: 40.w),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Row(children: [
                        Text(
                          'Flavor ',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '풍미',
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ]),
                    ),
                  ],
                ),
                PartEval(
                  idx: 0,
                  selectedText: text[0],
                  value: context.watch<HeatedMeatEvalViewModel>().flavor,
                  onChanged: (value) => context
                      .read<HeatedMeatEvalViewModel>()
                      .onChangedFlavor(value),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  children: [
                    SizedBox(width: 40.w),
                    const Row(children: [
                      Text(
                        'Juiciness ',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '다즙성',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ]),
                  ],
                ),
                PartEval(
                  idx: 1,
                  selectedText: text[1],
                  value: context.read<HeatedMeatEvalViewModel>().juiciness,
                  onChanged: (value) => context
                      .read<HeatedMeatEvalViewModel>()
                      .onChangedJuiciness(value),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  children: [
                    SizedBox(width: 40.w),
                    const Row(children: [
                      Text(
                        'Tenderness ',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '연도',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ]),
                  ],
                ),
                PartEval(
                  idx: 2,
                  selectedText: text[2],
                  value: context.read<HeatedMeatEvalViewModel>().tenderness,
                  onChanged: (value) => context
                      .read<HeatedMeatEvalViewModel>()
                      .onChangedTenderness(value),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  children: [
                    SizedBox(width: 40.w),
                    const Row(children: [
                      Text(
                        'Umami ',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '표면육즙',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ]),
                  ],
                ),
                PartEval(
                  idx: 3,
                  selectedText: text[3],
                  value: context.read<HeatedMeatEvalViewModel>().umami,
                  onChanged: (value) => context
                      .read<HeatedMeatEvalViewModel>()
                      .onChangedUmami(value),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  children: [
                    SizedBox(width: 40.w),
                    const Row(children: [
                      Text(
                        'Palatability ',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '기호도',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ]),
                  ],
                ),
                PartEval(
                  idx: 4,
                  selectedText: text[4],
                  value: context.read<HeatedMeatEvalViewModel>().palatability,
                  onChanged: (value) => context
                      .read<HeatedMeatEvalViewModel>()
                      .onChangedPalatability(value),
                ),
                SizedBox(
                  height: 60.h,
                ),
                // 데이터 저장 버튼
                Container(
                  margin: EdgeInsets.only(bottom: 18.h),
                  child: MainButton(
                    onPressed:
                        context.watch<HeatedMeatEvalViewModel>().completed
                            ? () => context
                                .read<HeatedMeatEvalViewModel>()
                                .saveData(context)
                            : null,
                    text: '저장',
                    width: 658.w,
                    height: 104.h,
                    mode: 1,
                  ),
                ),
              ],
            ),
            context.watch<HeatedMeatEvalViewModel>().isLoading
                ? const LoadingScreen()
                : Container()
          ],
        ),
      ),
    );
  }
}
