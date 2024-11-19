import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/memory.dart';
import '../providers/memory_provider.dart';

class EditMemoryScreen extends StatelessWidget {
  final Memory memory;

  const EditMemoryScreen({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: memory.title);
    final descriptionController =
        TextEditingController(text: memory.description);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Memory'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Create an updated Memory object, preserving other properties
                final updatedMemory = Memory(
                  id: memory.id,
                  title: titleController.text,
                  description: descriptionController.text,
                  unlockDate:
                      memory.unlockDate, // Preserve original unlock date
                  imagePath: memory.imagePath, // Preserve original image path
                  isLocked: memory.isLocked, // Preserve original lock status
                );

                // Call updateMemory with the updated Memory object
                Provider.of<MemoryProvider>(context, listen: false)
                    .updateMemory(updatedMemory);

                // Navigate back after saving changes
                Navigator.pop(context);
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
