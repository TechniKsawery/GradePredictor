import 'package:flutter/material.dart';
import '../utils/subject_translator.dart';

class TranslatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final bool enableOnlineFallback;

  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.enableOnlineFallback = true,
  });

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  Future<String>? _future;
  String? _lastRequestKey;

  void _prepareOnlineFallback() {
    if (!widget.enableOnlineFallback) {
      _future = null;
      _lastRequestKey = null;
      return;
    }

    final locale = Localizations.localeOf(context).languageCode;
    final syncResult = SubjectTranslator.translate(context, widget.text);
    if (locale == 'pl' || syncResult != widget.text) {
      _future = null;
      _lastRequestKey = null;
      return;
    }

    final normalized = widget.text.toLowerCase().trim();
    final requestKey = '${locale}_$normalized';
    if (_lastRequestKey == requestKey && _future != null) return;

    _lastRequestKey = requestKey;
    _future = SubjectTranslator.translateAsync(context, widget.text);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _prepareOnlineFallback();
  }

  @override
  void didUpdateWidget(covariant TranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.enableOnlineFallback != widget.enableOnlineFallback) {
      _prepareOnlineFallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    final syncResult = SubjectTranslator.translate(context, widget.text);

    if (syncResult != widget.text || _future == null) {
      return Text(
        syncResult == widget.text ? widget.text : syncResult,
        style: widget.style,
        textAlign: widget.textAlign,
        overflow: widget.overflow,
      );
    }

    return FutureBuilder<String>(
      future: _future,
      initialData: widget.text,
      builder: (context, snapshot) {
        return Text(
          snapshot.data ?? widget.text,
          style: widget.style,
          textAlign: widget.textAlign,
          overflow: widget.overflow,
        );
      },
    );
  }
}
