import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/memory.dart';

class StorageManager {
  /// Get the file path for storing memories.
  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/memories.json';
  }

  /// Save a new memory to the file.
  Future<void> saveMemory(Memory memory) async {
    try {
      final file = File(await _getFilePath());
      final contents = file.existsSync() ? await file.readAsString() : '[]';

      // Decode the JSON contents into a list of memories.
      List<Memory> memories = (json.decode(contents) as List<dynamic>)
          .map((e) => Memory.fromJson(e))
          .toList();

      // Add the new memory to the list.
      memories.add(memory);

      // Write the updated list back to the file.
      await file.writeAsString(
        json.encode(memories.map((e) => e.toJson()).toList()),
      );

      print('Memory saved successfully: ${memory.toJson()}');
    } catch (e) {
      print('Error saving memory: $e');
    }
  }

  /// Get all memories from the file.
  Future<List<Memory>> getMemories() async {
    try {
      final file = File(await _getFilePath());

      // If the file does not exist, return an empty list.
      if (!file.existsSync()) {
        print('Memory file does not exist. Returning empty list.');
        return [];
      }

      // Read the file contents and decode into a list of memories.
      final contents = await file.readAsString();
      List<dynamic> jsonData = json.decode(contents);
      print('Memories loaded: $jsonData');
      return jsonData.map((e) => Memory.fromJson(e)).toList();
    } catch (e) {
      // Handle errors and reset the file if necessary.
      print('Error reading memories. Resetting file. Error: $e');
      await File(await _getFilePath()).writeAsString('[]');
      return [];
    }
  }

  /// Delete a memory by its ID.
  Future<void> deleteMemory(String memoryId) async {
    try {
      final file = File(await _getFilePath());
      final contents = file.existsSync() ? await file.readAsString() : '[]';

      // Decode the JSON contents into a list of memories.
      List<Memory> memories = (json.decode(contents) as List<dynamic>)
          .map((e) => Memory.fromJson(e))
          .toList();

      // Remove the memory with the specified ID.
      memories.removeWhere((memory) => memory.id == memoryId);

      // Write the updated list back to the file.
      await file.writeAsString(
        json.encode(memories.map((e) => e.toJson()).toList()),
      );

      print('Memory with ID $memoryId deleted successfully.');
    } catch (e) {
      print('Error deleting memory: $e');
    }
  }
}
