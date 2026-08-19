// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'RehabMed';

  @override
  String get login => 'Login';

  @override
  String get patientDashboard => 'Patient Dashboard';

  @override
  String get ehrDetail => 'EHR Detail';

  @override
  String get dataViz => 'Trends';

  @override
  String get communication => 'Communication';

  @override
  String get settings => 'Settings';

  @override
  String get onlyForReference =>
      'For reference only, not a substitute for in-person consultation';

  @override
  String get selectRole => 'Select role';

  @override
  String get roleDoctor => 'Doctor';

  @override
  String get rolePatient => 'Patient / Family';

  @override
  String get username => 'Account';

  @override
  String get password => 'Password';

  @override
  String get biometricLogin => 'Sign in with biometrics';

  @override
  String get consentText =>
      'I have read and accept the Personal Data Collection Statement (under Hong Kong\'s PDPO)';

  @override
  String get consentRequired =>
      'Please accept the personal data collection statement';

  @override
  String get patientHomeTitle => 'My Rehab';

  @override
  String get searchPatients => 'Search name / bed / stage';

  @override
  String get noPatients => 'No patient records';

  @override
  String get logout => 'Log out';

  @override
  String get myStage => 'Rehab stage';

  @override
  String get nextAppointment => 'Next appointment';

  @override
  String get myProgress => 'My progress';

  @override
  String get contactDoctor => 'Contact doctor';

  @override
  String get viewRecords => 'View my records';

  @override
  String get detailPlaceholder => 'Case detail (in progress)';

  @override
  String get bedNo => 'Bed no.';

  @override
  String get importTitle => 'Import rehab data';

  @override
  String get importEntry => 'Import data';

  @override
  String get pickFile => 'Select file';

  @override
  String get importHint => 'Supports JSON / CSV analyzed rehab data files';

  @override
  String get importing => 'Importing…';

  @override
  String get stepSelectFile => 'Select file';

  @override
  String get stepParse => 'Parsing';

  @override
  String get stepValidate => 'Validating';

  @override
  String get stepSave => 'Saving locally';

  @override
  String get importSuccess => 'Import successful';

  @override
  String importPatient(String name) {
    return 'Patient: $name';
  }

  @override
  String importRecordCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return 'Imported $countString rehab records';
  }

  @override
  String get importFailed => 'Import failed';

  @override
  String get retry => 'Retry';

  @override
  String get backToOverview => 'Back to overview';

  @override
  String get analyticsNoData => 'No data';

  @override
  String get degradeNote => 'No summary provided; showing latest batch metrics';

  @override
  String get completionRateLabel => 'Completion rate';

  @override
  String get riskLabel => 'Risk';

  @override
  String get trendTitle => 'Trend';

  @override
  String get trendUp => 'Improving';

  @override
  String get trendDown => 'Worsening';

  @override
  String get trendFlat => 'Stable';

  @override
  String get noteLabel => 'Note';

  @override
  String get analyticsNoSummaryHint =>
      'App does not compute metrics; only visualizes external analysis';

  @override
  String get distributionTitle => 'Distribution';

  @override
  String get historyTitle => 'History';

  @override
  String get mediaTitle => 'Media';

  @override
  String get analyticsNoTrend => 'No plottable trend metrics';

  @override
  String get selectMetric => 'Select metric';

  @override
  String get radarTitle => 'Capability radar';

  @override
  String get batchLabel => 'Batch';

  @override
  String get testDateLabel => 'Assessment date';

  @override
  String get metricsCount => 'Metrics';

  @override
  String get compareTitle => 'Batch comparison';

  @override
  String get metricLabel => 'Metric';

  @override
  String get deltaLabel => 'Δ';

  @override
  String get latestBadge => 'Latest';

  @override
  String get noCompareData => 'No comparable data';

  @override
  String get noMedia => 'No auxiliary media (P2)';

  @override
  String get seedOrImportHint =>
      'Import analyzed files or load built-in sample data to preview the dashboard';

  @override
  String get loadDemo => 'Load sample';

  @override
  String get themeTitle => 'Theme';

  @override
  String get themeSubtitle => 'Light & dark mode';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get themeModeSystem => 'System';

  @override
  String get elderTitle => 'Elder mode';

  @override
  String get elderSubtitle => 'Auto + manual + adjustable';

  @override
  String get elderAutoHint =>
      'Auto: enabled when system text is large (age-65 rule wired in P2)';

  @override
  String get elderResetAuto => 'Reset to auto';

  @override
  String get elderScaleLabel => 'Text scale';

  @override
  String get elderContrastLabel => 'High contrast';

  @override
  String get elderSimplifyLabel => 'Simplified navigation';

  @override
  String get lockTitle => 'Security lock';

  @override
  String get lockSubtitle => 'Re-verify on foreground return (biometric)';

  @override
  String get lockEnableLabel => 'Enable security lock';

  @override
  String get lockTimeoutLabel => 'Lock timeout';

  @override
  String get lockTimeoutMin1 => '1 min';

  @override
  String get lockTimeoutMin3 => '3 min';

  @override
  String get lockTimeoutMin5 => '5 min';

  @override
  String get lockTimeoutMin10 => '10 min';

  @override
  String get lockScreenTitle => 'App locked';

  @override
  String get lockScreenHint => 'Verify your identity to continue';

  @override
  String get unlockButton => 'Unlock';

  @override
  String get unlockPasswordLabel => 'Password';

  @override
  String get unlockPasswordHint =>
      'Biometric unavailable — enter password (at least 6 chars)';
}
