// lib/utils/test_helper.dart

import 'package:flutter/material.dart';

class AuthTestHelper {
  static void printTestResult(String testName, bool success, String message) {
    debugPrint('TEST: $testName');
    debugPrint('RESULT: ${success ? 'PASSED ✅' : 'FAILED ❌'}');
    debugPrint('MESSAGE: $message');
    debugPrint('------------------------');
  }
}
