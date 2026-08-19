// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '康復醫療';

  @override
  String get login => '登入';

  @override
  String get patientDashboard => '患者總覽';

  @override
  String get ehrDetail => '電子檔案';

  @override
  String get dataViz => '數據趨勢';

  @override
  String get communication => '醫患溝通';

  @override
  String get settings => '設定';

  @override
  String get onlyForReference => '僅供參考，不替代醫生診症';

  @override
  String get selectRole => '選擇身份';

  @override
  String get roleDoctor => '醫生';

  @override
  String get rolePatient => '患者 / 家屬';

  @override
  String get username => '帳號';

  @override
  String get password => '密碼';

  @override
  String get biometricLogin => '使用生物辨識登入';

  @override
  String get consentText => '我已閱讀並同意《個人資料收集聲明》（依據香港《個人資料（私隱）條例》）';

  @override
  String get consentRequired => '請先同意個人資料收集聲明';

  @override
  String get patientHomeTitle => '我的康復';

  @override
  String get searchPatients => '搜尋 姓名 / 床號 / 康復階段';

  @override
  String get noPatients => '暫無患者資料';

  @override
  String get logout => '登出';

  @override
  String get myStage => '康復階段';

  @override
  String get nextAppointment => '下次覆診';

  @override
  String get myProgress => '康復進度';

  @override
  String get contactDoctor => '聯絡醫生';

  @override
  String get viewRecords => '查看我的紀錄';

  @override
  String get detailPlaceholder => '個案詳情（開發中）';

  @override
  String get bedNo => '床號';

  @override
  String get importTitle => '导入康复数据';

  @override
  String get importEntry => '导入数据';

  @override
  String get pickFile => '选择文件';

  @override
  String get importHint => '支持 JSON / CSV 格式的已分析康复数据文件';

  @override
  String get importing => '导入中…';

  @override
  String get stepSelectFile => '选择文件';

  @override
  String get stepParse => '解析内容';

  @override
  String get stepValidate => '校验数据';

  @override
  String get stepSave => '存入本地';

  @override
  String get importSuccess => '导入成功';

  @override
  String importPatient(String name) {
    return '患者：$name';
  }

  @override
  String importRecordCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '已导入 $countString 笔康复数据';
  }

  @override
  String get importFailed => '导入失败';

  @override
  String get retry => '重试';

  @override
  String get backToOverview => '返回总览';

  @override
  String get analyticsNoData => '暫無資料';

  @override
  String get degradeNote => '未提供概覽摘要，顯示最近批次指標';

  @override
  String get completionRateLabel => '運動完成率';

  @override
  String get riskLabel => '風險';

  @override
  String get trendTitle => '趨勢';

  @override
  String get trendUp => '改善';

  @override
  String get trendDown => '退步';

  @override
  String get trendFlat => '持平';

  @override
  String get noteLabel => '備註';

  @override
  String get analyticsNoSummaryHint => '本 App 不自行計算指標，僅視覺化外部分析結果';

  @override
  String get distributionTitle => '運動分布';

  @override
  String get historyTitle => '歷次測試';

  @override
  String get mediaTitle => '輔助媒體';

  @override
  String get analyticsNoTrend => '暫無可繪製的趨勢指標';

  @override
  String get selectMetric => '選擇指標';

  @override
  String get radarTitle => '能力雷達';

  @override
  String get batchLabel => '批次';

  @override
  String get testDateLabel => '評估日期';

  @override
  String get metricsCount => '指標數';

  @override
  String get compareTitle => '批次對比';

  @override
  String get metricLabel => '指標';

  @override
  String get deltaLabel => '變化';

  @override
  String get latestBadge => '最近';

  @override
  String get noCompareData => '無可比對資料';

  @override
  String get noMedia => '暫無輔助媒體（P2 填充）';

  @override
  String get seedOrImportHint => '請匯入已分析檔案，或載入內置範例資料以預覽看板';

  @override
  String get loadDemo => '載入範例';

  @override
  String get themeTitle => '主题';

  @override
  String get themeSubtitle => '明暗模式';

  @override
  String get themeModeLight => '浅色';

  @override
  String get themeModeDark => '深色';

  @override
  String get themeModeSystem => '跟随系统';

  @override
  String get elderTitle => '长者模式';

  @override
  String get elderSubtitle => '自动 + 手动 + 可调';

  @override
  String get elderAutoHint => '自动：系统字体较大时开启（满 65 岁规则 P2 接 PII）';

  @override
  String get elderResetAuto => '重置为自动';

  @override
  String get elderScaleLabel => '字号倍率';

  @override
  String get elderContrastLabel => '高对比';

  @override
  String get elderSimplifyLabel => '简化导航';

  @override
  String get lockTitle => '安全锁';

  @override
  String get lockSubtitle => '前台切回 / 超时后重验（生物识别）';

  @override
  String get lockEnableLabel => '启用安全锁';

  @override
  String get lockTimeoutLabel => '锁定超时';

  @override
  String get lockTimeoutMin1 => '1 分钟';

  @override
  String get lockTimeoutMin3 => '3 分钟';

  @override
  String get lockTimeoutMin5 => '5 分钟';

  @override
  String get lockTimeoutMin10 => '10 分钟';

  @override
  String get lockScreenTitle => '应用已锁定';

  @override
  String get lockScreenHint => '验证身份以继续';

  @override
  String get unlockButton => '解锁';

  @override
  String get unlockPasswordLabel => '密码';

  @override
  String get unlockPasswordHint => '生物识别不可用，输入密码（至少 6 位）';
}

/// The translations for Chinese, as used in Hong Kong (`zh_HK`).
class AppLocalizationsZhHk extends AppLocalizationsZh {
  AppLocalizationsZhHk() : super('zh_HK');

  @override
  String get appTitle => '康復醫療';

  @override
  String get login => '登入';

  @override
  String get patientDashboard => '患者總覽';

  @override
  String get ehrDetail => '電子檔案';

  @override
  String get dataViz => '數據趨勢';

  @override
  String get communication => '醫患溝通';

  @override
  String get settings => '設定';

  @override
  String get onlyForReference => '僅供參考，不替代醫生診症';

  @override
  String get selectRole => '選擇身份';

  @override
  String get roleDoctor => '醫生';

  @override
  String get rolePatient => '患者 / 家屬';

  @override
  String get username => '帳號';

  @override
  String get password => '密碼';

  @override
  String get biometricLogin => '使用生物辨識登入';

  @override
  String get consentText => '我已閱讀並同意《個人資料收集聲明》（依據香港《個人資料（私隱）條例》）';

  @override
  String get consentRequired => '請先同意個人資料收集聲明';

  @override
  String get patientHomeTitle => '我的康復';

  @override
  String get searchPatients => '搜尋 姓名 / 床號 / 康復階段';

  @override
  String get noPatients => '暫無患者資料';

  @override
  String get logout => '登出';

  @override
  String get myStage => '康復階段';

  @override
  String get nextAppointment => '下次覆診';

  @override
  String get myProgress => '康復進度';

  @override
  String get contactDoctor => '聯絡醫生';

  @override
  String get viewRecords => '查看我的紀錄';

  @override
  String get detailPlaceholder => '個案詳情（開發中）';

  @override
  String get bedNo => '床號';

  @override
  String get importTitle => '匯入康復資料';

  @override
  String get importEntry => '匯入資料';

  @override
  String get pickFile => '選擇檔案';

  @override
  String get importHint => '支援 JSON / CSV 格式的已分析康復資料檔';

  @override
  String get importing => '匯入中…';

  @override
  String get stepSelectFile => '選擇檔案';

  @override
  String get stepParse => '解析內容';

  @override
  String get stepValidate => '驗證資料';

  @override
  String get stepSave => '存入本地';

  @override
  String get importSuccess => '匯入成功';

  @override
  String importPatient(String name) {
    return '患者：$name';
  }

  @override
  String importRecordCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '已匯入 $countString 筆康復資料';
  }

  @override
  String get importFailed => '匯入失敗';

  @override
  String get retry => '重試';

  @override
  String get backToOverview => '返回總覽';

  @override
  String get analyticsNoData => '暫無資料';

  @override
  String get degradeNote => '未提供概覽摘要，顯示最近批次指標';

  @override
  String get completionRateLabel => '運動完成率';

  @override
  String get riskLabel => '風險';

  @override
  String get trendTitle => '趨勢';

  @override
  String get trendUp => '改善';

  @override
  String get trendDown => '退步';

  @override
  String get trendFlat => '持平';

  @override
  String get noteLabel => '備註';

  @override
  String get analyticsNoSummaryHint => '本 App 不自行計算指標，僅視覺化外部分析結果';

  @override
  String get distributionTitle => '運動分布';

  @override
  String get historyTitle => '歷次測試';

  @override
  String get mediaTitle => '輔助媒體';

  @override
  String get analyticsNoTrend => '暫無可繪製的趨勢指標';

  @override
  String get selectMetric => '選擇指標';

  @override
  String get radarTitle => '能力雷達';

  @override
  String get batchLabel => '批次';

  @override
  String get testDateLabel => '評估日期';

  @override
  String get metricsCount => '指標數';

  @override
  String get compareTitle => '批次對比';

  @override
  String get metricLabel => '指標';

  @override
  String get deltaLabel => '變化';

  @override
  String get latestBadge => '最近';

  @override
  String get noCompareData => '無可比對資料';

  @override
  String get noMedia => '暫無輔助媒體（P2 填充）';

  @override
  String get seedOrImportHint => '請匯入已分析檔案，或載入內置範例資料以預覽看板';

  @override
  String get loadDemo => '載入範例';

  @override
  String get themeTitle => '主題';

  @override
  String get themeSubtitle => '明暗模式';

  @override
  String get themeModeLight => '淺色';

  @override
  String get themeModeDark => '深色';

  @override
  String get themeModeSystem => '跟隨系統';

  @override
  String get elderTitle => '長者模式';

  @override
  String get elderSubtitle => '自動 + 手動 + 可調';

  @override
  String get elderAutoHint => '自動：系統字體較大時開啟（滿 65 歲規則 P2 接 PII）';

  @override
  String get elderResetAuto => '重設為自動';

  @override
  String get elderScaleLabel => '字號倍率';

  @override
  String get elderContrastLabel => '高對比';

  @override
  String get elderSimplifyLabel => '簡化導航';

  @override
  String get lockTitle => '安全鎖';

  @override
  String get lockSubtitle => '前台切回 / 超時後重驗（生物辨識）';

  @override
  String get lockEnableLabel => '啟用安全鎖';

  @override
  String get lockTimeoutLabel => '鎖定逾時';

  @override
  String get lockTimeoutMin1 => '1 分鐘';

  @override
  String get lockTimeoutMin3 => '3 分鐘';

  @override
  String get lockTimeoutMin5 => '5 分鐘';

  @override
  String get lockTimeoutMin10 => '10 分鐘';

  @override
  String get lockScreenTitle => '應用已鎖定';

  @override
  String get lockScreenHint => '驗證身份以繼續';

  @override
  String get unlockButton => '解鎖';

  @override
  String get unlockPasswordLabel => '密碼';

  @override
  String get unlockPasswordHint => '生物辨識不可用，輸入密碼（至少 6 位）';
}
