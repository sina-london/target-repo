import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:nekoflow/data/models/onboarding/onboarding_model.dart';

class OnboardingBox {
  static const boxName = 'onboarding';
  late Box<OnboardingModel> _box;
  late OnboardingModel _onboardingModel;

  /// Initializes the box and sets the onboarding status.
  Future<void> init() async {
    try {
      _box = Hive.box<OnboardingModel>(boxName);
      // Load the onboarding data from the box, or create a new one if it doesn't exist.
      _onboardingModel = _box.get(0, defaultValue: OnboardingModel(isOnboardingCompleted: false))!;
      await _box.put(0, _onboardingModel); // Ensure the default value is stored
    } catch (e) {
      // Handle potential Hive errors, e.g., corrupted data or initialization issues
      debugPrint('Error initializing onboarding box: $e');
    }
  }

  /// Marks the onboarding as completed and saves the updated state.
  Future<void> updateBoarding() async {
    try {
      _onboardingModel.isOnboardingCompleted = true;
      await _box.put(0, _onboardingModel);
    } catch (e) {
      debugPrint('Error updating onboarding status: $e');
    }
  }

  /// Checks if the onboarding process is completed.
  bool checkBoarded() {
    return _onboardingModel.isOnboardingCompleted;
  }

  /// Closes the box when it's no longer needed to free up resources.
  Future<void> close() async {
    await _box.close();
  }
}
