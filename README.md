# GradePredictor ✨

> Aplikacja Flutter, która pomaga ogarnąć oceny, przedmioty, egzaminy i przewidywanie wyników bez chaosu.
> Prosto, czytelnie i pod szkołę.

## Dlaczego warto 📚

- logowanie i synchronizacja danych użytkownika
- lista przedmiotów, ocen i egzaminów
- statystyki oraz średnie z przedmiotów
- prognozowanie ocen
- kalendarz terminów
- synchronizacja z systemami szkolnymi
- przełączanie języka: polski, angielski, niemiecki
- jasny i ciemny motyw

## Co siedzi pod spodem 🛠️

- Flutter
- Riverpod
- Supabase
- fl_chart
- intl
- google_fonts
- shared_preferences

## Jak uruchomić 🚀

```bash
flutter pub get
```

```bash
flutter run
```

Jeśli chcesz odpalić appkę na konkretnym emulatorze:

```bash
flutter run -d emulator-5554
```

## Jak to jest zorganizowane 🧩

- `lib/main.dart` - start aplikacji i konfiguracja motywu oraz lokalizacji
- `lib/screens/` - ekrany aplikacji
- `lib/providers/` - stan aplikacji i logika Riverpod
- `lib/services/` - integracje z Supabase i systemami szkolnymi
- `lib/widgets/` - współdzielone komponenty UI
- `lib/l10n/` - tłumaczenia aplikacji

## Na koniec 💡

Projekt jest prywatny i nie jest publikowany na pub.dev. 