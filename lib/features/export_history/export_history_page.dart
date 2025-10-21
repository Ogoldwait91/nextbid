import "dart:io";
import "package:flutter/material.dart";
import "package:path/path.dart" as p;

class ExportHistoryPage extends StatelessWidget {
  const ExportHistoryPage({super.key});

  Future<List<FileSystemEntity>> _load() async {
    final dir = Directory(p.join(Directory.current.path, "exports"));
    if (!await dir.exists()) return const <FileSystemEntity>[];
    final files = await dir.list().toList();
    files.sort((a, b) {
      final ta = (a.statSync().modified);
      final tb = (b.statSync().modified);
      return tb.compareTo(ta); // newest first
    });
    return files.where((f) => f.path.toLowerCase().endsWith(".jss")).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Export History")),
      body: FutureBuilder<List<FileSystemEntity>>(
        future: _load(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snap.data!;
          if (items.isEmpty) {
            return const Center(child: Text("No exports yet."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final f = items[i] as File;
              final stat = f.statSync();
              final name = p.basename(f.path);
              final kb = (stat.size / 1024).toStringAsFixed(1);
              return ListTile(
                title: Text(name),
                subtitle: Text("${stat.modified}  •  ${kb}KB"),
                trailing: IconButton(
                  icon: const Icon(Icons.folder_open),
                  onPressed: () {
                    // Open folder cross-platform-ish. On Windows, this opens Explorer.
                    Process.start(
                      Platform.isWindows ? "explorer.exe" : "open",
                      [Platform.isWindows ? "/e," : "", p.dirname(f.path)],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
