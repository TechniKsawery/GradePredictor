import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import 'grade_provider.dart';

class Account {
  final String email;
  final String password;
  final String? displayName;

  Account({required this.email, required this.password, this.displayName});

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'displayName': displayName,
  };

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    email: json['email'],
    password: json['password'],
    displayName: json['displayName'],
  );
}

final accountsProvider = StateNotifierProvider<AccountsNotifier, List<Account>>((ref) {
  return AccountsNotifier();
});

class AccountsNotifier extends StateNotifier<List<Account>> {
  final SupabaseClient _supabase = Supabase.instance.client;

  AccountsNotifier() : super([]) {
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('saved_accounts');
    if (jsonStr != null) {
      final List<dynamic> list = jsonDecode(jsonStr);
      state = list.map((item) => Account.fromJson(item)).toList();
    }

    // Sync current user's name from Supabase profile
    await _syncCurrentUserName();
  }

  /// Fetches the logged-in user's display_name from Supabase and updates
  /// the matching entry in the local account list.
  Future<void> _syncCurrentUserName() async {
    final currentUser = _supabase.auth.currentUser;
    if (currentUser == null || currentUser.email == null) return;

    try {
      final data = await _supabase
          .from('profiles')
          .select('display_name')
          .eq('id', currentUser.id)
          .maybeSingle();

      if (data != null) {
        String? name = data['display_name'] as String?;
        final email = currentUser.email!;

        // Use email prefix as fallback if name equals full email or is empty
        if (name == null || name.isEmpty || name == email) {
          name = email.split('@')[0];
        }

        // Update or add the current account in the list
        if (state.any((a) => a.email == email)) {
          state = state.map((a) => a.email == email
              ? Account(email: a.email, password: a.password, displayName: name)
              : a).toList();
        }
        await _saveAccounts();
      }
    } catch (_) {}
  }

  Future<void> addAccount(String email, String password, String? name) async {
    final newAccount = Account(email: email, password: password, displayName: name);
    if (!state.any((a) => a.email == email)) {
      state = [...state, newAccount];
      await _saveAccounts();
    }
  }

  Future<void> addCurrentUser(String email, String password, String? name) async {
    if (!state.any((a) => a.email == email)) {
      state = [...state, Account(email: email, password: password, displayName: name)];
      await _saveAccounts();
    }
  }

  Future<void> signUpAndAddAccount(String email, String password, String name) async {
    await _supabase.auth.signUp(email: email, password: password, data: {'display_name': name});
    await addAccount(email, password, name);
  }

  Future<void> switchAccount(Account account, WidgetRef ref) async {
    await _supabase.auth.signInWithPassword(
      email: account.email,
      password: account.password,
    );
    // Invalidate ALL data so fresh data is fetched for the new user
    ref.invalidate(subjectsProvider);
    // Sync new user's name from Supabase into local account list
    await _syncCurrentUserName();
  }

  Future<void> removeAccount(String email) async {
    state = state.where((a) => a.email != email).toList();
    await _saveAccounts();
  }

  Future<void> updateAccountName(String email, String newName) async {
    state = state.map((a) => a.email == email
        ? Account(email: a.email, password: a.password, displayName: newName)
        : a).toList();
    await _saveAccounts();
  }

  /// Updates the stored email for an account (e.g. after Supabase email change).
  Future<void> updateAccountEmail(String oldEmail, String newEmail) async {
    state = state.map((a) => a.email == oldEmail
        ? Account(email: newEmail, password: a.password, displayName: a.displayName)
        : a).toList();
    await _saveAccounts();
  }

  Future<void> _saveAccounts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = jsonEncode(state.map((a) => a.toJson()).toList());
    await prefs.setString('saved_accounts', jsonStr);
  }
}
