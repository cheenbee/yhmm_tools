import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yhmm/services/mdf_service.dart';
import 'package:yhmm/utils/utils.dart';

class HomeProvider extends ChangeNotifier {
  final MdfService mdfService = MdfService();

  final Map<String, int> currentNumMap = {};

  onClickMdf() async {
    // var response = await mdfService
    //     .getWebHtmlString('https://stripe-club.com/ap/item/i/A1CC00009LT8');
    // print(response);
  }

  String orderRemarkCountText = '';

  handleOrderExcel() async {
    // var file = 'assets/data/orders.xlsx';

    try {
      var result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        allowMultiple: false,
      );
      if (result == null) return;

      Utils.showToast(msg: '正在处理...');

      Uint8List? fileBytes = result.files.first.bytes;
      // String fileName = result.files.first.name;
      if (fileBytes == null) return;
      var excel = Excel.decodeBytes(fileBytes);

      currentNumMap.clear();
      for (var table in excel.tables.keys) {
        Sheet? sheet = excel.tables[table];
        if (sheet == null) continue;

        for (int row = 0; row < sheet.maxRows; row++) {
          // 买家备注
          var cellA = sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row));
          if (cellA.value == null) continue;
          // 卖家备注
          var cellB = sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row));
          // 买家昵称
          var cellC = sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row));

          // col去重
          if (row > 0 && cellC.value != null) {
            var cellAPre = sheet.cell(
                CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row - 1));
            var cellCPre = sheet.cell(
                CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row - 1));
            // 买家昵称和备注都相同，去重
            if (cellCPre.value == cellC.value &&
                cellAPre.value == cellA.value &&
                cellA.value.toString().length > 4) {
              continue;
            }
          }

          // 正则查找 买家备注
          var matchStringListA = _findThreeNumber(cellA.value.toString());
          // 添加匹配成功的数字到字典中
          _addMatchNum2Map(matchStringListA);

          // 正则查找 卖家备注
          var matchStringListB = _findThreeNumber(cellB.value.toString());
          // 去除cellB中和cellA中相同的元素
          var tempBList = List.from(matchStringListB);
          for (var bNumValue in tempBList) {
            if (matchStringListA.contains(bNumValue)) {
              matchStringListB.remove(bNumValue);
            }
          }
          // 添加卖家备注匹配成功的数字到字典中
          _addMatchNum2Map(matchStringListB);
        }

        var str = '';
        for (var key in currentNumMap.keys.toList()..sort()) {
          int numCount = currentNumMap[key] ?? 1;
          if (numCount > 1) {
            str += '$key：$numCount\n';
          }
        }
        orderRemarkCountText = str;

        notifyListeners();
        await _copyCount2ClipBoard();
        Utils.showToast(msg: '统计结果已复制到粘贴板');
      }
    } catch (e) {
      Utils.showToast(msg: e.toString());
    }
  }

  _copyCount2ClipBoard() async {
    await Clipboard.setData(ClipboardData(text: orderRemarkCountText));
  }

  _addMatchNum2Map(List<String> matchValues) {
    for (var numValue in matchValues) {
      if (currentNumMap.containsKey(numValue)) {
        int num = currentNumMap[numValue] ?? 1;
        currentNumMap[numValue] = num + 1;
      } else {
        currentNumMap[numValue] = 1;
      }
    }
  }

  List<String> _findThreeNumber(String value) {
    RegExp numReg = RegExp(r'\d{3}');
    var matches = numReg.allMatches(value).map((e) => e.group(0)).toList();
    var list = <String>[];
    for (var match in matches) {
      if (match == null) continue;
      list.add(match);
    }
    return list;
  }
}
