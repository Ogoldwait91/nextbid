import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BuildBidPage extends StatefulWidget {
  const BuildBidPage({super.key});
  @override
  State<BuildBidPage> createState() => _BuildBidPageState();
}

class _BuildBidPageState extends State<BuildBidPage> {
  final _groups = <String>["Long-haul", "Europe", "Domestic"];
  final _controller = TextEditingController();

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  void _addGroup() {
    final t = _controller.text.trim();
    if (t.isEmpty) return;
    setState(() { _groups.add(t); _controller.clear(); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build Bid'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/pre-process'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Add group',
                    ),
                    onSubmitted: (_) => _addGroup(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _addGroup, child: const Text('Add')),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: _groups.length,
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = _groups.removeAt(oldIndex);
                    _groups.insert(newIndex, item);
                  });
                },
                itemBuilder: (context, i) => Card(
                  key: ValueKey(_groups[i]),
                  child: ListTile(
                    title: Text(_groups[i]),
                    trailing: const Icon(Icons.drag_handle),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
