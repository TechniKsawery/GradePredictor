import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';

class LocalizedDateFormatter {
  static String formatDate(DateTime date, AppLocalizations l10n) {
    return '${_getDay(date.weekday, l10n)} ${date.day} ${_getMonth(date.month, l10n, short: true)} ${date.year}';
  }

  static String formatDateShort(DateTime date, AppLocalizations l10n) {
    return '${date.day} ${_getMonth(date.month, l10n, short: true)} ${date.year}';
  }

  static String formatDateWithWeekday(DateTime date, AppLocalizations l10n) {
    return '${_getDay(date.weekday, l10n)}, ${date.day} ${_getMonth(date.month, l10n)} ${date.year}';
  }

  static String _getMonth(int month, AppLocalizations l10n, {bool short = false}) {
    if (short) {
      return switch (month) {
        1 => l10n.monthShortJanuary,
        2 => l10n.monthShortFebruary,
        3 => l10n.monthShortMarch,
        4 => l10n.monthShortApril,
        5 => l10n.monthShortMay,
        6 => l10n.monthShortJune,
        7 => l10n.monthShortJuly,
        8 => l10n.monthShortAugust,
        9 => l10n.monthShortSeptember,
        10 => l10n.monthShortOctober,
        11 => l10n.monthShortNovember,
        12 => l10n.monthShortDecember,
        _ => '',
      };
    }
    return switch (month) {
      1 => l10n.monthJanuary,
      2 => l10n.monthFebruary,
      3 => l10n.monthMarch,
      4 => l10n.monthApril,
      5 => l10n.monthMay,
      6 => l10n.monthJune,
      7 => l10n.monthJuly,
      8 => l10n.monthAugust,
      9 => l10n.monthSeptember,
      10 => l10n.monthOctober,
      11 => l10n.monthNovember,
      12 => l10n.monthDecember,
      _ => '',
    };
  }

  static String _getDay(int weekday, AppLocalizations l10n, {bool short = false}) {
    if (short) {
      return switch (weekday) {
        1 => l10n.dayShortMonday,
        2 => l10n.dayShortTuesday,
        3 => l10n.dayShortWednesday,
        4 => l10n.dayShortThursday,
        5 => l10n.dayShortFriday,
        6 => l10n.dayShortSaturday,
        7 => l10n.dayShortSunday,
        _ => '',
      };
    }
    return switch (weekday) {
      1 => l10n.dayMonday,
      2 => l10n.dayTuesday,
      3 => l10n.dayWednesday,
      4 => l10n.dayThursday,
      5 => l10n.dayFriday,
      6 => l10n.daySaturday,
      7 => l10n.daySunday,
      _ => '',
    };
  }
}
