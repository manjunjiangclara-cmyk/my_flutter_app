import 'package:flutter/material.dart';
import 'package:my_flutter_app/features/journal/presentation/widgets/timeline_indicator.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';
import 'package:my_flutter_app/features/memory/presentation/providers/memory_provider.dart';
import 'package:my_flutter_app/features/memory/presentation/widgets/memory_card.dart';
import 'package:provider/provider.dart';

class ComposeScreen extends StatelessWidget {
  const ComposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Memories'),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              // Action for adding a new memory
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _MemoryHeader(),
            SizedBox(height: 16),
            Expanded(child: _MemoryList()),
          ],
        ),
      ),
    );
  }
}

/// Displays the header for the memory list, showing the current month and year.
class _MemoryHeader extends StatelessWidget {
  const _MemoryHeader();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'August, 2025',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

/// Renders a list of memories with a vertical timeline indicator.
class _MemoryList extends StatelessWidget {
  const _MemoryList();

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoryData>(
      builder: (BuildContext context, MemoryData memoryData, Widget? child) {
        return ListView.builder(
          itemCount: memoryData.memories.length,
          itemBuilder: (BuildContext context, int index) {
            final MemoryCardModel memory = memoryData.memories[index];
            final Color primaryColor = Theme.of(context).colorScheme.primary;
            final bool isFirst = index == 0;
            final bool isLast = index == memoryData.memories.length - 1;

            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TimelineIndicator(
                    isFirst: isFirst,
                    isLast: isLast,
                    dotColor: primaryColor,
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: MemoryCard(memoryCardModel: memory)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
