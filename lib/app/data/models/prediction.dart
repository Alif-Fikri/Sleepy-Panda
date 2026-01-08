enum PredictionLabel { insomnia, normal, sleepApnea }

enum PredictionPeriod { daily, weekly, monthly }

extension PredictionLabelMapper on PredictionLabel {
  String get name {
    switch (this) {
      case PredictionLabel.insomnia:
        return 'Insomnia';
      case PredictionLabel.normal:
        return 'Normal';
      case PredictionLabel.sleepApnea:
        return 'Sleep Apnea';
    }
  }

  int get resultCode {
    switch (this) {
      case PredictionLabel.insomnia:
        return 0;
      case PredictionLabel.normal:
        return 1;
      case PredictionLabel.sleepApnea:
        return 2;
    }
  }

  static PredictionLabel fromApiValue(String value) {
    final mapping = {
      'Insomnia': PredictionLabel.insomnia,
      'Normal': PredictionLabel.normal,
      'Sleep Apnea': PredictionLabel.sleepApnea,
    };

    final label = mapping[value];
    if (label == null) {
      throw ArgumentError('Label prediksi tidak dikenal: $value');
    }
    return label;
  }
}

PredictionLabel parsePredictionLabel(dynamic value) {
  if (value is PredictionLabel) {
    return value;
  }
  if (value is String) {
    return PredictionLabelMapper.fromApiValue(value);
  }
  throw ArgumentError('Label prediksi tidak valid: $value');
}

PredictionLabel? tryParsePredictionLabel(dynamic value) {
  try {
    return parsePredictionLabel(value);
  } catch (_) {
    return null;
  }
}

extension PredictionPeriodLabel on PredictionPeriod {
  String get routeKey {
    switch (this) {
      case PredictionPeriod.daily:
        return 'daily';
      case PredictionPeriod.weekly:
        return 'weekly';
      case PredictionPeriod.monthly:
        return 'monthly';
    }
  }
}
