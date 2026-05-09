import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/school_integration_service.dart';
import '../providers/grade_provider.dart';
import '../l10n/app_localizations.dart';

class SchoolSyncScreen extends ConsumerStatefulWidget {
  const SchoolSyncScreen({super.key});

  @override
  ConsumerState<SchoolSyncScreen> createState() => _SchoolSyncScreenState();
}

class _SchoolSyncScreenState extends ConsumerState<SchoolSyncScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  SchoolProvider _selectedProvider = SchoolProvider.librus;
  bool _isLoading = false;
  SchoolSyncResult? _result;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _startSync() async {
    setState(() => _isLoading = true);
    
    final service = SchoolIntegrationService(
      email: _emailController.text,
      password: _passwordController.text,
      provider: _selectedProvider,
    );

    try {
      final result = await service.sync();
      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Błąd synchronizacji: $e')),
        );
      }
    }
  }

  Future<void> _importData() async {
    if (_result == null) return;

    setState(() => _isLoading = true);
    
    final subjectsNotifier = ref.read(subjectsProvider.notifier);
    final subjects = ref.read(subjectsProvider);

    for (var rawSub in _result!.subjects) {
      final name = rawSub['name'];
      if (!subjects.any((s) => s.name.toLowerCase() == name.toLowerCase())) {
        await subjectsNotifier.addSubject(name);
      }
    }

    // Refresh subjects to get IDs
    await subjectsNotifier.loadSubjects();
    final updatedSubjects = ref.read(subjectsProvider);

    for (var rawGrade in _result!.grades) {
      final sub = updatedSubjects.firstWhere(
        (s) => s.name.toLowerCase() == rawGrade['subject_name'].toString().toLowerCase(),
      );
      
      await ref.read(gradesProvider(sub.id).notifier).addGrade(
        rawGrade['grade'],
        rawGrade['weight'],
        rawGrade['type'],
        points: rawGrade['points'],
        maxPoints: rawGrade['max_points'],
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dane zaimportowane pomyślnie!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import z e-dziennika'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _result == null ? _buildLoginForm(l10n) : _buildSummaryView(l10n),
          ),
    );
  }

  Widget _buildLoginForm(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.sync_alt, size: 80, color: Color(0xFF6366F1)),
        const SizedBox(height: 24),
        Text(
          'Połącz się ze swoim e-dziennikiem, aby automatycznie pobrać oceny i sprawdziany.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
        const SizedBox(height: 32),
        SegmentedButton<SchoolProvider>(
          segments: const [
            ButtonSegment(value: SchoolProvider.librus, label: Text('Librus'), icon: Icon(Icons.school)),
            ButtonSegment(value: SchoolProvider.vulcan, label: Text('Vulcan'), icon: Icon(Icons.business)),
          ],
          selected: {_selectedProvider},
          onSelectionChanged: (set) => setState(() => _selectedProvider = set.first),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: _selectedProvider == SchoolProvider.librus ? 'Login (Librus)' : 'Token (Vulcan)',
            prefixIcon: const Icon(Icons.person_outline),
            hintText: _selectedProvider == SchoolProvider.vulcan ? 'np. 3H6K9...' : null,
          ),
        ),
        const SizedBox(height: 16),
        if (_selectedProvider == SchoolProvider.vulcan) ...[
          const TextField(
            decoration: InputDecoration(
              labelText: 'Symbol (Vulcan)',
              prefixIcon: Icon(Icons.domain),
              hintText: 'np. powiat-warszawski',
            ),
          ),
          const SizedBox(height: 16),
        ],
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: _selectedProvider == SchoolProvider.librus ? 'Hasło' : 'Kod PIN',
            prefixIcon: const Icon(Icons.lock_outline),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _startSync,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Rozpocznij synchronizację'),
        ),
        const SizedBox(height: 16),
        Text(
          'Twoje dane są bezpieczne i używane wyłącznie do pobrania ocen. Nie przechowujemy Twojego hasła.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildSummaryView(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Znaleziono dane do importu:',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _summaryRow(Icons.subject, 'Przedmioty', _result!.subjects.length.toString()),
                const Divider(),
                _summaryRow(Icons.grade, 'Oceny', _result!.grades.length.toString()),
                const Divider(),
                _summaryRow(Icons.event, 'Sprawdziany', _result!.exams.length.toString()),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Szczegóły ocen (automatycznie wykryte):',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _result!.grades.length,
          itemBuilder: (context, index) {
            final grade = _result!.grades[index];
            return ListTile(
              title: Text('${grade['subject_name']}: ${grade['grade']}'),
              subtitle: Text('Typ: ${grade['type']} | Waga: ${grade['weight']} | Pkt: ${grade['points'] ?? '-'}/${grade['max_points'] ?? '-'}'),
              leading: CircleAvatar(
                backgroundColor: _getTypeColor(grade['type']),
                child: Text(grade['grade'].toString().substring(0, 1), style: const TextStyle(color: Colors.white)),
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: _importData,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Zatwierdź i importuj'),
        ),
        TextButton(
          onPressed: () => setState(() => _result = null),
          child: const Text('Anuluj i wróć'),
        ),
      ],
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF6366F1)),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 16)),
        const Spacer(),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'test': return Colors.red;
      case 'quiz': return Colors.orange;
      case 'homework': return Colors.blue;
      default: return Colors.grey;
    }
  }
}
