import "dart:io";
import "package:flutter_test/flutter_test.dart";
import "package:nextbid_demo/utils/file_naming.dart";
import "package:path/path.dart" as p;

void main() {
  test(
    "nextExportFilePath auto-increments sequence per crew + month",
    () async {
      final tmp = await Directory.systemTemp.createTemp("nextbid_naming_");
      final dir = Directory(p.join(tmp.path, "exports"));
      await dir.create(recursive: true);

      // Seed existing files
      final crew = "OLIVE";
      final month = "2025-10";
      await File(
        p.join(dir.path, "nextbid_${crew}_${month}_01.jss"),
      ).writeAsString("x");
      await File(
        p.join(dir.path, "nextbid_${crew}_${month}_02.jss"),
      ).writeAsString("x");

      // Ask for the next one
      final next = await nextExportFilePath(
        crew: crew,
        month: month,
        baseDir: dir,
      );
      expect(p.basename(next.path), "nextbid_${crew}_${month}_03.jss");

      // Different month should restart at 01
      final nextMonth = await nextExportFilePath(
        crew: crew,
        month: "2025-11",
        baseDir: dir,
      );
      expect(p.basename(nextMonth.path), "nextbid_${crew}_2025-11_01.jss");

      // Different crew should have independent sequence
      final otherCrew = await nextExportFilePath(
        crew: "BOSS",
        month: month,
        baseDir: dir,
      );
      expect(p.basename(otherCrew.path), "nextbid_BOSS_${month}_01.jss");
    },
  );
}
