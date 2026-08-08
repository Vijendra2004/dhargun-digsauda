import 'dart:developer' as dev;

class GMLogger {
  // Disabled in release mode by default; enable in dev if needed.
  static bool enabled = true;

  static void d(Object? message) {
    if (enabled) {
      dev.log(message?.toString() ?? '');
    }
  }

  static void v(Object? message) {
    if (enabled) {
      dev.log(message?.toString() ?? '');
    }
  }

  // Masks common header keys and token patterns inside arbitrary strings.
  static String _maskSensitive(String input) {
    String out = input;

    // Mask Authorization values "Basic <base64>" and "Bearer <token>"
    //out = out.replaceAllMapped(RegExp(r'(?i)(Basic\s+)[A-Za-z0-9+/=]+'), (m) => '${m[1]}[REDACTED]');
    out = out.replaceAllMapped(RegExp(r'(?i)(Bearer\s+)[A-Za-z0-9\-\._~\+/=]+'), (m) => '${m[1]}[REDACTED]');

    // Mask JSON-style fields: "authorization": "..."
    out = out.replaceAllMapped(RegExp(r'(?i)("authorization"\s*:\s*")([^"]+)(")'), (m) => '${m[1]}[REDACTED]${m[3]}');

    // Mask Content-Type / Accept JSON fields: "content-type": "...", "accept": "..."
    out = out.replaceAllMapped(RegExp(r'(?i)("content-type"\s*:\s*")([^"]+)(")'), (m) => '${m[1]}[REDACTED]${m[3]}');
    out = out.replaceAllMapped(RegExp(r'(?i)("accept"\s*:\s*")([^"]+)(")'), (m) => '${m[1]}[REDACTED]${m[3]}');

    // Mask header-style lines: Content-Type: application/json
    out = out.replaceAllMapped(RegExp(r'(?i)(content-type\s*[:=]\s*)([^\s,;]+)'), (m) => '${m[1]}[REDACTED]');
    out = out.replaceAllMapped(RegExp(r'(?i)(accept\s*[:=]\s*)([^\s,;]+)'), (m) => '${m[1]}[REDACTED]');
    out = out.replaceAllMapped(RegExp(r'(?i)(authorization\s*[:=]\s*)([^\s,;]+)'), (m) => '${m[1]}[REDACTED]');

    // If a whole header map is printed as Map or Headers, also try to hide tokens like "token":"..."
    out = out.replaceAllMapped(RegExp(r'(?i)("token"\s*:\s*")([^"]+)(")'), (m) => '${m[1]}[REDACTED]${m[3]}');

    return out;
  }
}
