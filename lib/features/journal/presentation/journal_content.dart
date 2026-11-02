import 'package:peria_app/features/journal/data/models/journal_entry.dart';

class JournalContentView {
  const JournalContentView({required this.text, required this.images});

  final String text;
  final List<String> images;
}

final _imageTag = RegExp(r'(?:🖼️\s*)?\[image:([^\]]+)\]');

JournalContentView journalContentView(JournalEntry entry) {
  final images = <String>[...entry.attachments];
  final text = entry.content.replaceAllMapped(_imageTag, (match) {
    final path = match.group(1)?.trim();
    if (path != null && path.isNotEmpty && !images.contains(path)) {
      images.add(path);
    }
    return '';
  }).trim();
  return JournalContentView(text: text, images: images);
}
