import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shonenx/core/anilist/services/anilist_service.dart';
import 'package:shonenx/core/models/anilist/anilist_media_list.dart';
import 'package:shonenx/core/utils/app_logger.dart';
import 'package:shonenx/providers/anilist/anilist_user_provider.dart';

class AnimeListState {
  final Map<String, List<MediaListGroup>> mediaListGroups;
  final bool isLoading;
  final Map<String, String?> errors;
  final List<Media> favorites;
  final Set<String> fetchedStatuses; // Track which statuses have been fetched

  AnimeListState({
    this.mediaListGroups = const {},
    this.isLoading = false,
    this.errors = const {},
    this.favorites = const [],
    this.fetchedStatuses = const {},
  });

  AnimeListState copyWith({
    Map<String, List<MediaListGroup>>? mediaListGroups,
    bool? isLoading,
    Map<String, String?>? errors,
    List<Media>? favorites,
    Set<String>? fetchedStatuses,
  }) {
    return AnimeListState(
      mediaListGroups: mediaListGroups ?? this.mediaListGroups,
      isLoading: isLoading ?? this.isLoading,
      errors: errors ?? this.errors,
      favorites: favorites ?? this.favorites,
      fetchedStatuses: fetchedStatuses ?? this.fetchedStatuses,
    );
  }
}

class AnimeListNotifier extends StateNotifier<AnimeListState> {
  final AnilistService _anilistService;
  final String accessToken;
  final String userId;

  AnimeListNotifier({
    required AnilistService anilistService,
    required this.accessToken,
    required this.userId,
  })  : _anilistService = anilistService,
        super(AnimeListState()) {
    if (accessToken.isEmpty || userId.isEmpty) {
      AppLogger.w('Access token or user ID is empty in AnimeListNotifier');
    }
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    AppLogger.d('Fetching initial data for anime lists and favorites');
    await Future.wait([
      fetchAllAnimeLists(),
      fetchFavorites(),
    ]);
  }

  Future<void> fetchAnimeListByStatus(String status) async {
    state = state.copyWith(
      isLoading: true,
      errors: {...state.errors, status: null},
    );

    try {
      if (accessToken.isEmpty || userId.isEmpty) {
        AppLogger.w('Access token or user ID is empty for status: $status');
      }
      final data = await _anilistService.getUserAnimeList(
        accessToken: accessToken,
        userId: userId,
        type: 'ANIME',
        status: status,
      );

      state = state.copyWith(
        mediaListGroups: {
          ...state.mediaListGroups,
          status: data.lists,
        },
        isLoading: false,
        fetchedStatuses: {...state.fetchedStatuses, status},
      );
      AppLogger.d('Successfully fetched anime list for status: $status');
    } catch (e, stackTrace) {
      state = state.copyWith(
        isLoading: false,
        errors: {...state.errors, status: e.toString()},
        fetchedStatuses: {...state.fetchedStatuses, status},
      );
      AppLogger.e(
          'Error fetching anime list for status: $status', e, stackTrace);
    }
  }

  Future<void> fetchAllAnimeLists() async {
    if (state.isLoading) {
      AppLogger.d('Skipping fetchAllAnimeLists due to ongoing fetch');
      return;
    }

    state = state.copyWith(isLoading: true, errors: {});
    AppLogger.d('Fetching all anime lists');

    final statuses = ['CURRENT', 'COMPLETED', 'PAUSED', 'DROPPED', 'PLANNING'];
    await Future.wait(
      statuses.map((status) => fetchAnimeListByStatus(status)),
    );
  }

  Future<void> fetchFavorites() async {
    try {
      AppLogger.d('Fetching favorites for userId: $userId');
      final favorites = await _anilistService.getFavorites(
        userId: int.parse(userId),
        accessToken: accessToken,
      );
      state = state.copyWith(
        favorites: favorites?.anime ?? [],
      );
      AppLogger.d('Successfully fetched favorites');
    } catch (e, stackTrace) {
      AppLogger.e(
          'Error fetching favorites for userId: $userId', e, stackTrace);
    }
  }

  // Method to refresh a specific status
  Future<void> refreshStatus(String status) async {
    AppLogger.d('Refreshing anime list for status: $status');
    state = state.copyWith(
      fetchedStatuses: state.fetchedStatuses.difference({status}),
    );
    await fetchAnimeListByStatus(status);
  }

  // Method to refresh all data
  Future<void> refreshAll() async {
    AppLogger.d('Refreshing all anime list data');
    state = state.copyWith(fetchedStatuses: {});
    await fetchInitialData();
  }

  // Method to add or remove a favorite
  Future<void> toggleFavoritesStatic(List<Media> favorites) async {
    AppLogger.d('Toggling favorites: ${favorites.map((m) => m.id).toList()}');
    final currentFavorites = state.favorites.toSet();

    for (var media in favorites) {
      if (currentFavorites.contains(media)) {
        currentFavorites.remove(media);
      } else {
        currentFavorites.add(media);
      }
    }

    state = state.copyWith(favorites: currentFavorites.toList());
    AppLogger.d(
        'Updated favorites: ${currentFavorites.map((m) => m.id).toList()}');
  }

  /// Toggle the status of a Media item locally without fetching from the server
  void toggleStatusStatic({
    required Media media,
    required String? newStatus, // Null means removal
    int? entryId, // Optional, needed for removal or initial entry
    int? progress, // Optional, to preserve or update progress
    int? score, // Optional, to preserve or update score
  }) {
    final currentGroups =
        Map<String, List<MediaListGroup>>.from(state.mediaListGroups);
    MediaList? existingEntry;

    // Step 1: Find and remove the media from its current status (if it exists)
    for (var status in currentGroups.keys) {
      final groupList = List<MediaListGroup>.from(currentGroups[status] ?? []);
      for (var group in groupList) {
        final entries = List<MediaList>.from(group.entries);
        existingEntry = entries.firstWhere(
          (entry) => entry.media.id == media.id,
          orElse: () =>
              MediaList(media: media, status: '', score: 0, progress: 0),
        );
        if (existingEntry.media.id != null) {
          entries.remove(existingEntry);
          if (entries.isEmpty) {
            groupList.remove(group);
          }
          currentGroups[status] = groupList;
          break;
        }
      }
    }

    // Step 2: Add the media to the new status (if newStatus is provided)
    if (newStatus != null) {
      final newGroupList =
          List<MediaListGroup>.from(currentGroups[newStatus] ?? []);
      final existingGroup = newGroupList.firstWhere(
        (group) => group.name == newStatus,
        orElse: () => MediaListGroup(name: newStatus, entries: []),
      );

      final updatedEntry = MediaList(
        media: media,
        status: newStatus,
        score: score ?? existingEntry?.score ?? 0,
        progress: progress ?? existingEntry?.progress ?? 0,
      );

      final updatedEntries = List<MediaList>.from(existingGroup.entries)
        ..add(updatedEntry);
      final updatedGroup =
          MediaListGroup(name: newStatus, entries: updatedEntries);

      if (newGroupList.contains(existingGroup)) {
        newGroupList[newGroupList.indexOf(existingGroup)] = updatedGroup;
      } else {
        newGroupList.add(updatedGroup);
      }
      currentGroups[newStatus] = newGroupList;
    }

    // Step 3: Update the state
    state = state.copyWith(mediaListGroups: currentGroups);
    AppLogger.d(
        'Toggled status for ${media.title?.english ?? media.id} to $newStatus');
  }

  // Convenience method for single status toggle
  void toggleStatusStaticSingle(
    Media media,
    String? newStatus, {
    int? entryId,
    int? progress,
    int? score,
  }) {
    AppLogger.d(
        'Toggling status for ${media.title?.english ?? media.id} to $newStatus');
    toggleStatusStatic(
      media: media,
      newStatus: newStatus,
      entryId: entryId,
      progress: progress,
      score: score,
    );
  }
}

final animeListProvider =
    StateNotifierProvider<AnimeListNotifier, AnimeListState>((ref) {
  final userState = ref.watch(userProvider);

  if (userState == null ||
      userState.accessToken.isEmpty ||
      userState.id == null) {
    AppLogger.w('User state is invalid for animeListProvider');
    return AnimeListNotifier(
      anilistService: AnilistService(),
      accessToken: '',
      userId: '',
    );
  }

  return AnimeListNotifier(
    anilistService: AnilistService(),
    accessToken: userState.accessToken,
    userId: userState.id.toString(),
  );
});
