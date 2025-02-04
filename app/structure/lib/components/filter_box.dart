//
//
// FilterBox 컴포넌트 : Researcher
//
//

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:structure/components/custom_divider.dart';
import 'package:structure/components/custom_table_calendar.dart';
import 'package:structure/components/date_container.dart';
import 'package:structure/components/filter_row.dart';
import 'package:structure/components/main_button.dart';
import 'package:structure/config/palette.dart';

/// 데이터 관리 페이지에서 사용되는 필터 area
///
/// ### 일반 `type = 0`
/// 조회기간 : `dateList`, `onTapDate`, `dateStatus`, `firstDayText`, `indexDay`, `firstDayOnTapTable`, `lastDayText`, `lastDayOnTapTable`, `isOpenTable`, `focused`, `onDaySelected`
/// <br /> 축종 : `speciesList`, `onTapSpecies`, `speciesStatus`
/// /// <br /> 상태 : `statusList`, `onTapStatus`, `statusStatus`
/// <br /> 정렬 순서 : `sortList`, `onTapSort`, `sortStatus`
///
/// ### 관리자 추가정보 입력 `type = 1`
/// 조회기간 : `dateList`, `onTapDate`, `dateStatus`, `firstDayText`, `indexDay`, `firstDayOnTapTable`, `lastDayText`, `lastDayOnTapTable`, `isOpenTable`, `focused`, `onDaySelected`
/// <br /> 데이터 : `dataList`, `onTapData`, `dataStatus`
/// <br /> 축종 : `speciesList`, `onTapSpecies`, `speciesStatus`
/// <br /> 정렬 순서 : `sortList`, `onTapSort`, `sortStatus`
///
/// ### 관리자 일반데이터 승인 `type = 2`
/// 조회기간 : `dateList`, `onTapDate`, `dateStatus`, `firstDayText`, `indexDay`, `firstDayOnTapTable`, `lastDayText`, `lastDayOnTapTable`, `isOpenTable`, `focused`, `onDaySelected`
/// <br /> 데이터 : `dataList`, `onTapData`, `dataStatus`
/// <br /> 축종 : `speciesList`, `onTapSpecies`, `speciesStatus`
/// <br /> 상태 : `statusList`, `onTapStatus`, `statusStatus`
/// <br /> 정렬 순서 : `sortList`, `onTapSort`, `sortStatus`

class FilterBox extends StatelessWidget {
  // 필터 종류 0:normal, 1: 관리자 추가정보 입력, 2 : 관리자 일반데이터 승인
  final int type;

  // 조회기간
  final List<String> dateList;
  final Function? onTapDate;
  final List<bool> dateStatus;

  // 날짜
  final String firstDayText;
  final int indexDay;
  final dynamic Function()? firstDayOnTapTable;
  final String lastDayText;
  final dynamic Function()? lastDayOnTapTable;

  // 달력
  final bool isOpenTable;
  final DateTime focused;
  final dynamic Function(DateTime, DateTime) onDaySelected;

  // 데이터
  final List<String>? dataList;
  final Function? onTapData;
  final List<bool>? dataStatus;

  // 축종
  final List<String>? speciesList;
  final Function? onTapSpecies;
  final List<bool>? speciesStatus;

  // 조회 버튼
  final bool checkedFilter;
  final Function()? onPressedFilterSave;

  // 상태 (대기중 : 0, 승인 : 2, 반려 : 1)
  final List<String>? statusList;
  final Function? onTapstatus;
  final List<bool>? statusStatus;

  // 정렬 순서
  final List<String>? sortList;
  final Function? onTapSort;
  final List<bool>? sortStatus;

  const FilterBox({
    super.key,
    required this.type,
    required this.dateList,
    this.onTapDate,
    required this.dateStatus,
    required this.firstDayText,
    required this.indexDay,
    this.firstDayOnTapTable,
    required this.lastDayText,
    this.lastDayOnTapTable,
    required this.isOpenTable,
    required this.focused,
    required this.onDaySelected,
    this.dataList,
    this.onTapData,
    this.dataStatus,
    this.speciesList,
    this.onTapSpecies,
    this.speciesStatus,
    this.statusList,
    this.onTapstatus,
    this.statusStatus,
    required this.checkedFilter,
    this.onPressedFilterSave,
    this.sortList,
    this.onTapSort,
    this.sortStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomDivider(height: 16),

        // 조회 기간
        // 모든 필터에서 표시
        Text('조회 기간', style: Palette.h5SemiBoldSecondary),
        SizedBox(height: 16.h),

        // 조회기간 filterRow
        // FilterRow 컴포넌트를 이용하여 Filter list 표현
        FilterRow(
          filterList: dateList,
          onTap: onTapDate,
          status: dateStatus,
        ),

        // 직접 입력일때만 height 생성
        dateStatus[3] ? SizedBox(height: 16.h) : Container(),

        // 날짜 컨테이너
        if (dateStatus[3])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 날짜를 '직접설정'으로 지정할 때, 사용되는 날짜 선택 기능
              // 시작 날짜
              Expanded(
                child: DateContainer(
                  dateString: firstDayText,
                  dateStatus: dateStatus[3],
                  showDecoration: indexDay == 0,
                  onTap: dateStatus[3] ? () => firstDayOnTapTable : null,
                ),
              ),

              SizedBox(width: 16.w),
              const Text('-'),
              SizedBox(width: 16.w),

              // 날짜를 '직접설정'으로 지정할 때, 사용되는 날짜 선택 기능
              // 끝 날짜
              Expanded(
                child: DateContainer(
                  dateString: lastDayText,
                  dateStatus: dateStatus[3],
                  showDecoration: indexDay == 1,
                  onTap: dateStatus[3] ? () => lastDayOnTapTable : null,
                ),
              ),
            ],
          ),

        // 달력
        // '직접설정'이 선택되었을 때, 표현되는 'CustomTableCalendar' 위젯 (날짜 선택 달력 위젯)
        if (isOpenTable)
          CustomTableCalendar(
            focusedDay: focused,
            selectedDay: focused,
            onDaySelected: onDaySelected,
          ),
        SizedBox(height: 24.h),

        // 데이터 필터 (나의 데이터)
        // 연구자 필터에서만 표시
        if (type != 0)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 데이터
              Text('데이터', style: Palette.h5SemiBoldSecondary),
              SizedBox(height: 16.h),
              // 데이터 filterrow
              // FilterRow 컴포넌트를 이용하여 Filter list 표현
              FilterRow(
                filterList: dataList ?? [],
                onTap: onTapData,
                status: dataStatus ?? [],
              ),
              SizedBox(height: 24.h),
            ],
          ),

        // 축종 필터
        // 모든 필터에서 표시
        Text('축종', style: Palette.h5SemiBoldSecondary),
        SizedBox(height: 16.h),

        // 축종 filterRow
        FilterRow(
          filterList: speciesList ?? [],
          onTap: onTapSpecies,
          status: speciesStatus ?? [],
        ),
        SizedBox(height: 24.h),

        // 상태 필터
        // 관리자 데이터 승인, 일반에서 사용
        if (type != 1)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('상태', style: Palette.h5SemiBoldSecondary),
              SizedBox(height: 16.h),
              FilterRow(
                filterList: statusList ?? [],
                onTap: onTapstatus,
                status: statusStatus ?? [],
              ),
              SizedBox(height: 24.h),
            ],
          ),

        // 정렬 순서
        // 모든 필터에서 사용
        Text('정렬 순서', style: Palette.h5SemiBoldSecondary),
        SizedBox(height: 16.h),

        FilterRow(
          filterList: sortList ?? [],
          onTap: onTapSort,
          status: sortStatus ?? [],
        ),
        SizedBox(height: 32.h),

        // 조회 버튼
        MainButton(
          width: double.infinity,
          height: 72.h,
          text: '조회',
          onPressed: checkedFilter ? onPressedFilterSave : null,
        ),

        const CustomDivider(height: 16),
      ],
    );
  }
}
