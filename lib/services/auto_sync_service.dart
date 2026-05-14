import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'school_integration_service.dart';

class AutoSyncStatus {
  final bool isSyncing;
  final bool isEnabled;
  final DateTime? lastSync;
  final String? lastError;
  final int newGradesCount;
  final int newExamsCount;

  const AutoSyncStatus({
    this.isSyncing = false,
    this.isEnabled = false,
    this.lastSync,
    this.lastError,
    this.newGradesCount = 0,
    this.newExamsCount = 0,
  });

  AutoSyncStatus copyWith({
    bool? isSyncing,
    bool? isEnabled,
    DateTime? lastSync,
    String? lastError,
    int? newGradesCount,
    int? newExamsCount,
  }) => AutoSyncStatus(
    isSyncing: isSyncing ?? this.isSyncing,
    isEnabled: isEnabled ?? this.isEnabled,
    lastSync: lastSync ?? this.lastSync,
    lastError: lastError ?? this.lastError,
    newGradesCount: newGradesCount ?? this.newGradesCount,
    newExamsCount: newExamsCount ?? this.newExamsCount,
  );
}

class AutoSyncNotifier extends StateNotifier<AutoSyncStatus> {
  Timer? _timer;
  static const Duration _syncInterval = Duration(minutes: 15);

  static const String _prefEmail = 'librus_email';
  static const String _prefPassword = 'librus_password';
  static const String _prefEnabled = 'librus_auto_sync';
  static const String _prefProvider = 'librus_provider';

  AutoSyncNotifier() : super(const AutoSyncStatus()) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(_prefEnabled) ?? false;
    if (enabled) {
      state = state.copyWith(isEnabled: true);
      _startTimer();
    }
  }

  Future<void> saveCredentials({
    required String email,
    required String password,
    required SchoolProvider provider,
    required bool enableAutoSync,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefEmail, email);
    await prefs.setString(_prefPassword, password);
    await prefs.setBool(_prefEnabled, enableAutoSync);
    await prefs.setString(_prefProvider, provider.name);

    state = state.copyWith(isEnabled: enableAutoSync);

    if (enableAutoSync) {
      _startTimer();
    } else {
      _stopTimer();
    }
  }

  Future<(String?, String?, SchoolProvider)> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_prefEmail);
    final password = prefs.getString(_prefPassword);
    final providerName = prefs.getString(_prefProvider) ?? 'librus';
    final provider = providerName == 'vulcan' ? SchoolProvider.vulcan : SchoolProvider.librus;
    return (email, password, provider);
  }

  Future<bool> hasCredentials() async {
    final (email, password, _) = await loadCredentials();
    return email != null && email.isNotEmpty && password != null && password.isNotEmpty;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(_syncInterval, (_) => syncNow());
    // Schedule first sync shortly after start to avoid blocking startup
    Future.delayed(const Duration(seconds: 2), () {
      if (state.isEnabled) syncNow();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<SchoolSyncResult?> syncNow() async {
    if (state.isSyncing) return null;

    final (email, password, provider) = await loadCredentials();
    if (email == null || password == null) return null;

    state = state.copyWith(isSyncing: true, lastError: null);
    try {
      final service = SchoolIntegrationService(
        email: email,
        password: password,
        provider: provider,
      );
      final result = await service.sync();

      state = state.copyWith(
        isSyncing: false,
        lastSync: DateTime.now(),
        newGradesCount: result.grades.length,
        newExamsCount: result.exams.length,
      );
      return result;
    } catch (e) {
      state = state.copyWith(
        isSyncing: false,
        lastError: e.toString(),
      );
      debugPrint('[AutoSync] Error: $e');
      return null;
    }
  }

  Future<void> disableAutoSync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefEnabled, false);
    _stopTimer();
    state = state.copyWith(isEnabled: false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final autoSyncProvider = StateNotifierProvider<AutoSyncNotifier, AutoSyncStatus>((ref) {
  return AutoSyncNotifier();
});
