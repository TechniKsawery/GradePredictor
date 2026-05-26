import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;

import '../models/exam.dart';

class GoogleCalendarService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarEventsScope],
  );

  Future<bool> addExamToCalendar(Exam exam, String summary) async {
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        return false;
      }

      final authClient = await _googleSignIn.authenticatedClient();
      if (authClient == null) {
        return false;
      }

      final calendarApi = calendar.CalendarApi(authClient);
      final event = calendar.Event(
        summary: summary,
        description: exam.title,
        start: calendar.EventDateTime(
          dateTime: exam.date,
          timeZone: 'Europe/Warsaw',
        ),
        end: calendar.EventDateTime(
          dateTime: exam.date.add(const Duration(hours: 1)),
          timeZone: 'Europe/Warsaw',
        ),
      );

      await calendarApi.events.insert(event, 'primary');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}