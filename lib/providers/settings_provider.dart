import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GradingScale {
  final double grade2;
  final double grade3;
  final double grade4;
  final double grade5;
  final double grade6;

  GradingScale({
    this.grade2 = 30,
    this.grade3 = 50,
    this.grade4 = 75,
    this.grade5 = 90,
    this.grade6 = 96,
  });

  Map<String, dynamic> toJson() => {
    'grade2': grade2,
    'grade3': grade3,
    'grade4': grade4,
    'grade5': grade5,
    'grade6': grade6,
  };

  factory GradingScale.fromJson(Map<String, dynamic> json) => GradingScale(
    grade2: json['grade2'] ?? 30,
    grade3: json['grade3'] ?? 50,
    grade4: json['grade4'] ?? 75,
    grade5: json['grade5'] ?? 90,
    grade6: json['grade6'] ?? 96,
  );
}

class SettingsNotifier extends StateNotifier<GradingScale> {
  SettingsNotifier() : super(GradingScale()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('grading_scale');
    if (jsonStr != null) {
      state = GradingScale.fromJson(jsonDecode(jsonStr));
    }
  }

  Future<void> updateScale(GradingScale newScale) async {
    state = newScale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('grading_scale', jsonEncode(newScale.toJson()));
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, GradingScale>((ref) {
  return SettingsNotifier();
});
