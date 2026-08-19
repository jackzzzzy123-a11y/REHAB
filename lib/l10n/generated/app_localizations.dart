import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale('zh', 'HK')
  ];

  /// 應用標題
  ///
  /// In zh_HK, this message translates to:
  /// **'康復醫療'**
  String get appTitle;

  /// 登入按鈕 / 頁面標題
  ///
  /// In zh_HK, this message translates to:
  /// **'登入'**
  String get login;

  /// 患者總覽頁面標題
  ///
  /// In zh_HK, this message translates to:
  /// **'患者總覽'**
  String get patientDashboard;

  /// 電子檔案詳情頁面標題
  ///
  /// In zh_HK, this message translates to:
  /// **'電子檔案'**
  String get ehrDetail;

  /// 數據可視化頁面標題
  ///
  /// In zh_HK, this message translates to:
  /// **'數據趨勢'**
  String get dataViz;

  /// 醫患溝通頁面標題
  ///
  /// In zh_HK, this message translates to:
  /// **'醫患溝通'**
  String get communication;

  /// 設定頁面標題
  ///
  /// In zh_HK, this message translates to:
  /// **'設定'**
  String get settings;

  /// 輔助工具免責聲明
  ///
  /// In zh_HK, this message translates to:
  /// **'僅供參考，不替代醫生診症'**
  String get onlyForReference;

  /// 登入頁角色選擇提示
  ///
  /// In zh_HK, this message translates to:
  /// **'選擇身份'**
  String get selectRole;

  /// 角色：醫生
  ///
  /// In zh_HK, this message translates to:
  /// **'醫生'**
  String get roleDoctor;

  /// 角色：患者或家屬
  ///
  /// In zh_HK, this message translates to:
  /// **'患者 / 家屬'**
  String get rolePatient;

  /// 帳號欄位標籤
  ///
  /// In zh_HK, this message translates to:
  /// **'帳號'**
  String get username;

  /// 密碼欄位標籤
  ///
  /// In zh_HK, this message translates to:
  /// **'密碼'**
  String get password;

  /// 生物辨識登入按鈕
  ///
  /// In zh_HK, this message translates to:
  /// **'使用生物辨識登入'**
  String get biometricLogin;

  /// PDPO 個人資料收集同意聲明
  ///
  /// In zh_HK, this message translates to:
  /// **'我已閱讀並同意《個人資料收集聲明》（依據香港《個人資料（私隱）條例》）'**
  String get consentText;

  /// 未勾選同意書的提示
  ///
  /// In zh_HK, this message translates to:
  /// **'請先同意個人資料收集聲明'**
  String get consentRequired;

  /// 患者首頁標題
  ///
  /// In zh_HK, this message translates to:
  /// **'我的康復'**
  String get patientHomeTitle;

  /// 患者搜尋框提示
  ///
  /// In zh_HK, this message translates to:
  /// **'搜尋 姓名 / 床號 / 康復階段'**
  String get searchPatients;

  /// 空清單提示
  ///
  /// In zh_HK, this message translates to:
  /// **'暫無患者資料'**
  String get noPatients;

  /// 登出按鈕
  ///
  /// In zh_HK, this message translates to:
  /// **'登出'**
  String get logout;

  /// 患者本人康復階段
  ///
  /// In zh_HK, this message translates to:
  /// **'康復階段'**
  String get myStage;

  /// 下次覆診時間
  ///
  /// In zh_HK, this message translates to:
  /// **'下次覆診'**
  String get nextAppointment;

  /// 康復進度
  ///
  /// In zh_HK, this message translates to:
  /// **'康復進度'**
  String get myProgress;

  /// 聯絡醫生按鈕
  ///
  /// In zh_HK, this message translates to:
  /// **'聯絡醫生'**
  String get contactDoctor;

  /// 查看本人紀錄按鈕
  ///
  /// In zh_HK, this message translates to:
  /// **'查看我的紀錄'**
  String get viewRecords;

  /// 詳情頁佔位提示
  ///
  /// In zh_HK, this message translates to:
  /// **'個案詳情（開發中）'**
  String get detailPlaceholder;

  /// 床號標籤
  ///
  /// In zh_HK, this message translates to:
  /// **'床號'**
  String get bedNo;

  /// 匯入頁標題
  ///
  /// In zh_HK, this message translates to:
  /// **'匯入康復資料'**
  String get importTitle;

  /// 總覽頁匯入按鈕
  ///
  /// In zh_HK, this message translates to:
  /// **'匯入資料'**
  String get importEntry;

  /// 匯入選檔按鈕
  ///
  /// In zh_HK, this message translates to:
  /// **'選擇檔案'**
  String get pickFile;

  /// 匯入頁格式提示
  ///
  /// In zh_HK, this message translates to:
  /// **'支援 JSON / CSV 格式的已分析康復資料檔'**
  String get importHint;

  /// 匯入進行中
  ///
  /// In zh_HK, this message translates to:
  /// **'匯入中…'**
  String get importing;

  /// 步驟：選擇檔案
  ///
  /// In zh_HK, this message translates to:
  /// **'選擇檔案'**
  String get stepSelectFile;

  /// 步驟：解析
  ///
  /// In zh_HK, this message translates to:
  /// **'解析內容'**
  String get stepParse;

  /// 步驟：驗證
  ///
  /// In zh_HK, this message translates to:
  /// **'驗證資料'**
  String get stepValidate;

  /// 步驟：存入本地
  ///
  /// In zh_HK, this message translates to:
  /// **'存入本地'**
  String get stepSave;

  /// 匯入成功標題
  ///
  /// In zh_HK, this message translates to:
  /// **'匯入成功'**
  String get importSuccess;

  /// 匯入成功顯示患者名稱
  ///
  /// In zh_HK, this message translates to:
  /// **'患者：{name}'**
  String importPatient(String name);

  /// 匯入成功筆數
  ///
  /// In zh_HK, this message translates to:
  /// **'已匯入 {count} 筆康復資料'**
  String importRecordCount(int count);

  /// 匯入失敗標題
  ///
  /// In zh_HK, this message translates to:
  /// **'匯入失敗'**
  String get importFailed;

  /// 重試按鈕
  ///
  /// In zh_HK, this message translates to:
  /// **'重試'**
  String get retry;

  /// 匯入完成返回總覽
  ///
  /// In zh_HK, this message translates to:
  /// **'返回總覽'**
  String get backToOverview;

  /// 分析面板空資料提示
  ///
  /// In zh_HK, this message translates to:
  /// **'暫無資料'**
  String get analyticsNoData;

  /// 無 summary 時的降級提示
  ///
  /// In zh_HK, this message translates to:
  /// **'未提供概覽摘要，顯示最近批次指標'**
  String get degradeNote;

  /// 概覽完成率標籤
  ///
  /// In zh_HK, this message translates to:
  /// **'運動完成率'**
  String get completionRateLabel;

  /// 風險等級標籤
  ///
  /// In zh_HK, this message translates to:
  /// **'風險'**
  String get riskLabel;

  /// 縱向趨勢標題
  ///
  /// In zh_HK, this message translates to:
  /// **'趨勢'**
  String get trendTitle;

  /// 趨勢上升
  ///
  /// In zh_HK, this message translates to:
  /// **'改善'**
  String get trendUp;

  /// 趨勢下降
  ///
  /// In zh_HK, this message translates to:
  /// **'退步'**
  String get trendDown;

  /// 趨勢持平
  ///
  /// In zh_HK, this message translates to:
  /// **'持平'**
  String get trendFlat;

  /// 概覽備註標籤
  ///
  /// In zh_HK, this message translates to:
  /// **'備註'**
  String get noteLabel;

  /// 不計算原則提示
  ///
  /// In zh_HK, this message translates to:
  /// **'本 App 不自行計算指標，僅視覺化外部分析結果'**
  String get analyticsNoSummaryHint;

  /// 分布柱圖標題
  ///
  /// In zh_HK, this message translates to:
  /// **'運動分布'**
  String get distributionTitle;

  /// 歷次測試標題
  ///
  /// In zh_HK, this message translates to:
  /// **'歷次測試'**
  String get historyTitle;

  /// 輔助媒體標題
  ///
  /// In zh_HK, this message translates to:
  /// **'輔助媒體'**
  String get mediaTitle;

  /// 無趨勢指標提示
  ///
  /// In zh_HK, this message translates to:
  /// **'暫無可繪製的趨勢指標'**
  String get analyticsNoTrend;

  /// 趨勢指標選擇提示
  ///
  /// In zh_HK, this message translates to:
  /// **'選擇指標'**
  String get selectMetric;

  /// 雷達圖標題
  ///
  /// In zh_HK, this message translates to:
  /// **'能力雷達'**
  String get radarTitle;

  /// 批次標籤
  ///
  /// In zh_HK, this message translates to:
  /// **'批次'**
  String get batchLabel;

  /// 評估日期標籤
  ///
  /// In zh_HK, this message translates to:
  /// **'評估日期'**
  String get testDateLabel;

  /// 指標數量標籤
  ///
  /// In zh_HK, this message translates to:
  /// **'指標數'**
  String get metricsCount;

  /// 批次對比標題
  ///
  /// In zh_HK, this message translates to:
  /// **'批次對比'**
  String get compareTitle;

  /// 指標名稱欄
  ///
  /// In zh_HK, this message translates to:
  /// **'指標'**
  String get metricLabel;

  /// 對比變化欄
  ///
  /// In zh_HK, this message translates to:
  /// **'變化'**
  String get deltaLabel;

  /// 最近批次徽章
  ///
  /// In zh_HK, this message translates to:
  /// **'最近'**
  String get latestBadge;

  /// 無對比資料提示
  ///
  /// In zh_HK, this message translates to:
  /// **'無可比對資料'**
  String get noCompareData;

  /// 媒體樁提示
  ///
  /// In zh_HK, this message translates to:
  /// **'暫無輔助媒體（P2 填充）'**
  String get noMedia;

  /// 空清單引導
  ///
  /// In zh_HK, this message translates to:
  /// **'請匯入已分析檔案，或載入內置範例資料以預覽看板'**
  String get seedOrImportHint;

  /// 載入 demo 種子按鈕
  ///
  /// In zh_HK, this message translates to:
  /// **'載入範例'**
  String get loadDemo;

  /// 設定頁主題區標題
  ///
  /// In zh_HK, this message translates to:
  /// **'主題'**
  String get themeTitle;

  /// 設定頁主題區副標題
  ///
  /// In zh_HK, this message translates to:
  /// **'明暗模式'**
  String get themeSubtitle;

  /// 主題模式：淺色
  ///
  /// In zh_HK, this message translates to:
  /// **'淺色'**
  String get themeModeLight;

  /// 主題模式：深色
  ///
  /// In zh_HK, this message translates to:
  /// **'深色'**
  String get themeModeDark;

  /// 主題模式：跟隨系統
  ///
  /// In zh_HK, this message translates to:
  /// **'跟隨系統'**
  String get themeModeSystem;

  /// 設定頁長者模式標題
  ///
  /// In zh_HK, this message translates to:
  /// **'長者模式'**
  String get elderTitle;

  /// 長者模式副標題
  ///
  /// In zh_HK, this message translates to:
  /// **'自動 + 手動 + 可調'**
  String get elderSubtitle;

  /// 長者模式自動判斷說明
  ///
  /// In zh_HK, this message translates to:
  /// **'自動：系統字體較大時開啟（滿 65 歲規則 P2 接 PII）'**
  String get elderAutoHint;

  /// 長者模式重設按鈕
  ///
  /// In zh_HK, this message translates to:
  /// **'重設為自動'**
  String get elderResetAuto;

  /// 字號倍率滑桿標籤
  ///
  /// In zh_HK, this message translates to:
  /// **'字號倍率'**
  String get elderScaleLabel;

  /// 高對比開關
  ///
  /// In zh_HK, this message translates to:
  /// **'高對比'**
  String get elderContrastLabel;

  /// 簡化導航開關
  ///
  /// In zh_HK, this message translates to:
  /// **'簡化導航'**
  String get elderSimplifyLabel;

  /// 設定頁安全鎖標題
  ///
  /// In zh_HK, this message translates to:
  /// **'安全鎖'**
  String get lockTitle;

  /// 安全鎖副標題
  ///
  /// In zh_HK, this message translates to:
  /// **'前台切回 / 超時後重驗（生物辨識）'**
  String get lockSubtitle;

  /// 啟用安全鎖開關
  ///
  /// In zh_HK, this message translates to:
  /// **'啟用安全鎖'**
  String get lockEnableLabel;

  /// 鎖定逾時標籤
  ///
  /// In zh_HK, this message translates to:
  /// **'鎖定逾時'**
  String get lockTimeoutLabel;

  /// 鎖定逾時：1 分鐘
  ///
  /// In zh_HK, this message translates to:
  /// **'1 分鐘'**
  String get lockTimeoutMin1;

  /// 鎖定逾時：3 分鐘
  ///
  /// In zh_HK, this message translates to:
  /// **'3 分鐘'**
  String get lockTimeoutMin3;

  /// 鎖定逾時：5 分鐘
  ///
  /// In zh_HK, this message translates to:
  /// **'5 分鐘'**
  String get lockTimeoutMin5;

  /// 鎖定逾時：10 分鐘
  ///
  /// In zh_HK, this message translates to:
  /// **'10 分鐘'**
  String get lockTimeoutMin10;

  /// 鎖屏標題
  ///
  /// In zh_HK, this message translates to:
  /// **'應用已鎖定'**
  String get lockScreenTitle;

  /// 鎖屏提示
  ///
  /// In zh_HK, this message translates to:
  /// **'驗證身份以繼續'**
  String get lockScreenHint;

  /// 解鎖按鈕
  ///
  /// In zh_HK, this message translates to:
  /// **'解鎖'**
  String get unlockButton;

  /// 解鎖密碼欄位標籤
  ///
  /// In zh_HK, this message translates to:
  /// **'密碼'**
  String get unlockPasswordLabel;

  /// 解鎖密碼兜底提示
  ///
  /// In zh_HK, this message translates to:
  /// **'生物辨識不可用，輸入密碼（至少 6 位）'**
  String get unlockPasswordHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'HK':
            return AppLocalizationsZhHk();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
