abstract class LookupMessages {
  String prefixAgo();
  String prefixFromNow();
  String suffixAgo();
  String suffixFromNow();
  String lessThanOneMinute(int seconds);
  String aboutAMinute(int minutes);
  String minutes(int minutes);
  String aboutAnHour(int minutes);
  String hours(int hours);
  String aDay(int hours);
  String days(int days);
  String aboutAMonth(int days);
  String months(int months);
  String aboutAYear(int year);
  String years(int years);
  String wordSeparator() => ' ';
}

class ArMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => 'من الآن';
  @override
  String lessThanOneMinute(int seconds) => 'قبل ثواني';
  @override
  String aboutAMinute(int minutes) => 'قبل دقيقة';
  @override
  String minutes(int minutes) {
    if (minutes == 1) {
      return 'منذ دقيقة';
    } else if (minutes == 2) {
      return 'منذ دقيقتين';
    } else if (minutes > 2 && minutes < 11) {
      return ' منذ $minutes دقائق ';
    } else if (minutes > 10) {
      return ' منذ $minutes دقيقة ';
    }

    return ' منذ $minutes دقائق ';
  }

  @override
  String aboutAnHour(int minutes) => 'قبل حوالي الساعة';
  @override
  String hours(int hours) {
    if (hours == 1) {
      return 'منذ ساعة';
    } else if (hours == 2) {
      return 'منذ ساعتين';
    } else if (hours > 2 && hours < 11) {
      return ' منذ $hours ساعات ';
    } else if (hours > 10) {
      return ' منذ $hours ساعة ';
    }

    return ' منذ $hours ساعات ';
  }

  @override
  String aDay(int hours) => 'قبل يوم';
  @override
  String days(int days) {
    if (days == 1) {
      return 'منذ يوم';
    } else if (days == 2) {
      return 'منذ يومين';
    } else if (days > 2 && days < 11) {
      return ' منذ $days ايام ';
    } else if (days > 10) {
      return ' منذ $days يوم ';
    }
    return ' منذ $days ايام ';
  }

  @override
  String aboutAMonth(int days) => 'قبل حوالي شهر';
  @override
  String months(int months) {
    if (months == 1) {
      return 'منذ شهر';
    } else if (months == 2) {
      return 'منذ شهرين';
    } else if (months > 2 && months < 11) {
      return ' منذ $months اشهر ';
    } else if (months > 10) {
      return ' منذ $months شهر ';
    }
    return ' منذ $months شهور ';
  }

  @override
  String aboutAYear(int year) => 'قبل سنة';
  @override
  String years(int years) {
    if (years == 1) {
      return 'منذ سنة';
    } else if (years == 2) {
      return 'منذ سنتين';
    } else if (years > 2 && years < 11) {
      return ' منذ $years سنوات ';
    } else if (years > 10) {
      return ' منذ $years سنة ';
    }

    return ' منذ $years سنوات ';
  }

  @override
  String wordSeparator() => ' ';
}

class ArShortMessages implements LookupMessages {
  @override
  String prefixAgo() => '';
  @override
  String prefixFromNow() => '';
  @override
  String suffixAgo() => '';
  @override
  String suffixFromNow() => '';
  @override
  String lessThanOneMinute(int seconds) => 'الأن';
  @override
  String aboutAMinute(int minutes) => 'دقيقة واحدة';
  @override
  String minutes(int minutes) => '$minutes د';
  @override
  String aboutAnHour(int minutes) => '~1 س';
  @override
  String hours(int hours) => '$hours س';
  @override
  String aDay(int hours) => '~1 ي';
  @override
  String days(int days) => '$days ي';
  @override
  String aboutAMonth(int days) => '~1 ش';
  @override
  String months(int months) => '$months ش';
  @override
  String aboutAYear(int year) => '~1 س';
  @override
  String years(int years) => '$years س';
  @override
  String wordSeparator() => ' ';
}

Map<String, LookupMessages> _lookupMessagesMap = {
  'ar': ArMessages(),
  'ar_short': ArShortMessages(),
};

/// Sets a [locale] with the provided [lookupMessages] to be available when
/// using the [format] function.
///
/// Example:
/// ```dart
/// setLocaleMessages('fr', FrMessages())
/// ```
///
/// If you want to define locale message implement [LookupMessages] interface
/// with the desired messages
///
void setLocaleMessages(String locale, LookupMessages lookupMessages) {
  assert(locale != null, '[locale] must not be null');
  assert(lookupMessages != null, '[lookupMessages] must not be null');
  _lookupMessagesMap[locale] = lookupMessages;
}

/// Formats provided [date] to a fuzzy time like 'a moment ago'
///
/// - If [locale] is passed will look for message for that locale, if you want
///   to add or override locales use [setLocaleMessages]. Defaults to 'en'
/// - If [clock] is passed this will be the point of reference for calculating
///   the elapsed time. Defaults to DateTime.now()
/// - If [allowFromNow] is passed, format will use the From prefix, ie. a date
///   5 minutes from now in 'en' locale will display as "5 minutes from now"
String format(DateTime date,
    {String locale, DateTime clock, bool allowFromNow}) {
  final _locale = locale ?? 'ar';
  final _allowFromNow = allowFromNow ?? false;
  final messages = _lookupMessagesMap[_locale] ?? ArMessages();
  final _clock = clock ?? DateTime.now();
  var elapsed = _clock.millisecondsSinceEpoch - date.millisecondsSinceEpoch;

  String prefix, suffix;

  if (_allowFromNow && elapsed < 0) {
    elapsed = date.isBefore(_clock) ? elapsed : elapsed.abs();
    prefix = messages.prefixFromNow();
    suffix = messages.suffixFromNow();
  } else {
    prefix = messages.prefixAgo();
    suffix = messages.suffixAgo();
  }

  final num seconds = elapsed / 1000;
  final num minutes = seconds / 60;
  final num hours = minutes / 60;
  final num days = hours / 24;
  final num months = days / 30;
  final num years = days / 365;

  String result;
  if (seconds < 45) {
    result = messages.lessThanOneMinute(seconds.round());
  } else if (seconds < 90) {
    result = messages.aboutAMinute(minutes.round());
  } else if (minutes < 45) {
    result = messages.minutes(minutes.round());
  } else if (minutes < 90) {
    result = messages.aboutAnHour(minutes.round());
  } else if (hours < 24) {
    result = messages.hours(hours.round());
  } else if (hours < 48) {
    result = messages.aDay(hours.round());
  } else if (days < 30) {
    result = messages.days(days.round());
  } else if (days < 60) {
    result = messages.aboutAMonth(days.round());
  } else if (days < 365) {
    result = messages.months(months.round());
  } else if (years < 2) {
    result = messages.aboutAYear(months.round());
  } else {
    result = messages.years(years.round());
  }

  return [prefix, result, suffix]
      .where((str) => str != null && str.isNotEmpty)
      .join(messages.wordSeparator());
}
