import "dart:io";
import "package:path/path.dart" as p;

/// Compute the next export file path with pattern:
///   nextbid_{CREW}_{YYYY-MM}_{NN}.jss
/// - [crew] defaults to "USER"
/// - [month] defaults to current yyyy-MM if not provided
/// - [baseDir] defaults to project/exports (desktop-friendly)
Future<File> nextExportFilePath({
  String crew = "USER",
  String? month,
  Directory? baseDir,
}) async {
  final m = month ?? _yyyyMm(DateTime.now());
  final dir = baseDir ?? Directory(p.join(Directory.current.path, "exports"));
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
  final patternPrefix = "nextbid_${crew}_${m}_";
  final entries = await dir.list().toList();
  var maxSeq = 0;
  for (final e in entries) {
    final name = p.basename(e.path);
    if (name.startsWith(patternPrefix) && name.toLowerCase().endsWith(".jss")) {
      final stem = name.substring(0, name.length - 4); // drop .jss
      final lastUnderscore = stem.lastIndexOf("_");
      if (lastUnderscore > 0 && lastUnderscore < stem.length - 1) {
        final seqStr = stem.substring(lastUnderscore + 1);
        final n = int.tryParse(seqStr);
        if (n != null && n > maxSeq) maxSeq = n;
      }
    }
  }
  final next = (maxSeq + 1).toString().padLeft(2, "0");
  final filename = "nextbid_${crew}_${m}_$next.jss";
  return File(p.join(dir.path, filename));
}

String _yyyyMm(DateTime d) => "${d.year}-${d.month.toString().padLeft(2, "0")}";
