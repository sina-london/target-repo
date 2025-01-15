import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:nekoflow/data/models/download/download_model.dart';
import 'package:nekoflow/data/services/download_service.dart';

class DownloadBox {
  static const String boxName = 'download';
  late Box<DownloadTasks> _box;
  late DownloadService _downloadService;
  DownloadTasks? _downloadTasks;

  // Get listenable for the box
  ValueListenable<Box<DownloadTasks>> listenable() => _box.listenable();

  Future<void> init() async {
    _downloadService = DownloadService();
    _box = await Hive.openBox<DownloadTasks>(boxName);
    _downloadTasks = _box.get(0) ?? DownloadTasks(tasks: []);
    await _box.put(0, _downloadTasks!);
  }

  // Add a new download task
  Future<void> addDownloadTask(DownloadTask task) async {
    final existingTaskIndex = _downloadTasks?.tasks
        .indexWhere((item) => item.episodeId == task.episodeId);

    if (existingTaskIndex == null || existingTaskIndex == -1) {
      _downloadTasks?.tasks.add(task);
      await _box.put(0, _downloadTasks!);

      try {
        await _downloadService.downloadFile(
          task.url, 
          task.fileName,
          (received, total) async {
            if (total <= 0) return;
            final progress = ((received / total) * 100).floor();
            await updateDownloadTask(
              task.id,
              status: DownloadTask.statusDownloading,
              progress: progress,
            );
          }
        );
        
        await updateDownloadTask(
          task.id, 
          status: DownloadTask.statusCompleted,
          progress: 100
        );
      } catch (e) {
        await updateDownloadTask(
          task.id,
          status: DownloadTask.statusFailed,
        );
        rethrow;
      }
    } else {
      final existingTask = _downloadTasks!.tasks[existingTaskIndex];
      if (existingTask.isFailed || existingTask.isCancelled) {
        await updateDownloadTask(
          existingTask.id,
          status: DownloadTask.statusQueued
        );
      }
    }
  }

  // Update an existing download task's status or progress
  Future<void> updateDownloadTask(String id,
      {String? status, int? progress}) async {
    final taskIndex = _downloadTasks?.tasks.indexWhere((task) => task.id == id);
    if (taskIndex != null && taskIndex != -1) {
      final task = _downloadTasks!.tasks[taskIndex];
      if (status != null) task.updateStatus(status);
      if (progress != null) task.updateProgress(progress);
      await _box.put(0, _downloadTasks!);
    }
  }

  // Remove a download task by id
  Future<void> removeDownloadTask(String id) async {
    _downloadTasks?.tasks.removeWhere((task) => task.id == id);
    await _box.put(0, _downloadTasks!);
  }

  // Get all tasks
  List<DownloadTask> getAllTasks() {
    return _downloadTasks?.tasks ?? [];
  }

  // Get tasks by status
  List<DownloadTask> getTasksByStatus(String status) {
    return _downloadTasks?.tasks
            .where((task) => task.status == status)
            .toList() ??
        [];
  }
}
