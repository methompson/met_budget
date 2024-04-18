import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:met_budget/global_state/data_provider.dart';

import 'package:met_budget/global_state/logging_provider.dart';
import 'package:met_budget/utils/type_checker.dart';

import 'package:met_budget/data_models/config.dart';

class ConfigProvider extends ChangeNotifier {
  Map<String, ConfigOption> _config = {};

  static final ConfigProvider _instance = ConfigProvider._();

  static ConfigProvider get instance => _instance;

  ConfigProvider._();

  Map<String, ConfigOption> get defaultConfig {
    return {
      'debugMode': ConfigOption.newConfigOption(
        key: 'debugMode',
        value: false,
      ),
    };
  }

  Future<void> init() async {
    try {
      final dp = DataProvider.instance;
      final configStr = await dp.getData('config');

      if (configStr == null) {
        _config = {...defaultConfig};
        return;
      }

      final rawConfig = isTypeError<List>(jsonDecode(configStr));

      final Map<String, ConfigOption> configMap = {};

      for (final conf in rawConfig) {
        final config = ConfigOption.fromJson(conf);
        configMap[config.key] = config;
      }

      _config = {
        ...defaultConfig,
        ...configMap,
      };
    } catch (e) {
      LoggingProvider.instance.logError('Error initializing config: $e');
    }
  }

  Future<void> saveConfig() async {
    try {
      final dp = DataProvider.instance;

      final configStr = jsonEncode(_config.values.toList());

      await dp.setData('config', configStr);
    } catch (e) {
      LoggingProvider.instance.logError('Error saving config: $e');
    }
  }

  void setConfig(String key, dynamic value) {
    final config = ConfigOption.newConfigOption(key: key, value: value);

    _config[key] = config;

    saveConfig();

    notifyListeners();
  }

  ConfigOption getConfig(String key) {
    return _config[key] ?? ConfigOption.emptyConfigOption(key);
  }
}
