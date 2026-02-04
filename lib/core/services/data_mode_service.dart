import 'package:flutter/foundation.dart';

enum DataMode { testData, connectedData }

class DataModeService extends ChangeNotifier {
  DataModeService._();
  static final DataModeService instance = DataModeService._();

  DataMode _currentMode = DataMode.testData;

  DataMode get currentMode => _currentMode;
  bool get isTestDataMode => _currentMode == DataMode.testData;
  bool get isConnectedDataMode => _currentMode == DataMode.connectedData;

  void setMode(DataMode mode) {
    if (_currentMode != mode) {
      _currentMode = mode;
      notifyListeners();
    }
  }

  void enableTestDataMode() => setMode(DataMode.testData);
  void enableConnectedDataMode() => setMode(DataMode.connectedData);
}
