import 'package:flutter/foundation.dart';
import '../models/memory.dart';
import '../utils/storage_manager.dart';

class MemoryProvider extends ChangeNotifier {
  List<Memory> _memories = [];

  List<Memory> get memories => _memories;

  // Load memories from storage
  Future<void> loadMemories() async {
    try {
      // print('Loading memories from storage...');
      _memories = await StorageManager().getMemories();

      // Uncomment this line to use mock data for testing:
      // _memories = [Memory(id: '1', title: 'Test Memory', description: 'This is a test')];

      // print('Memories loaded: $_memories');
      // notifyListeners();
    } catch (e) {
      print('Error loading memories: $e');
      rethrow; // Ensure the FutureBuilder catches this error
    }
  }

  // Add a new memory
  void addMemory(Memory memory) {
    _memories.add(memory);
    StorageManager().saveMemory(memory);
    notifyListeners();
  }

  // Update an existing memory (e.g., update unlock date or status)
  void updateMemory(Memory updatedMemory) {
    int index = _memories.indexWhere((memory) => memory.id == updatedMemory.id);
    if (index != -1) {
      _memories[index] = updatedMemory;
      StorageManager().saveMemory(updatedMemory); // Update the storage as well
      notifyListeners();
    }
  }

  // Delete a memory from both in-memory list and storage
  void deleteMemory(String memoryId) {
    int index = _memories.indexWhere((memory) => memory.id == memoryId);
    if (index != -1) {
      _memories.removeAt(index);
      StorageManager().deleteMemory(
          memoryId); // Ensure memory is deleted from storage as well
      notifyListeners();
    }
  }
}
