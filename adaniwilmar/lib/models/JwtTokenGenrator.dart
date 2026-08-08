import 'dart:convert';
import 'dart:math';
import 'package:adaniwilmar/gmcore/network/GMLogger.dart';
import 'package:crypto/crypto.dart';

class JwtTokenGenrator {
  static Map<String, String> generate({
    required String clientId,
    required String clientSecret,
  }) {
    // Unix timestamp in milliseconds
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Generate 16 random bytes
    final random = Random.secure();
    final nonceBytes = List<int>.generate(
      16,
          (_) => random.nextInt(256),
    );

    // Convert bytes to hex
    final nonce = bytesToHex(nonceBytes);
    GMLogger.v("clientIdData${clientId +"Secret"+clientSecret}");

    // Create message
    final message = '$clientId:$timestamp:$nonce';

    // HMAC SHA256 signature
    final key = utf8.encode(clientSecret);
    final bytes = utf8.encode(message);

    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);

    final signature = digest.toString();

    return {
      'timestamp': timestamp.toString(),
      'nonce': nonce,
      'signature': signature,
    };
  }

  static String bytesToHex(List<int> bytes) {
    final buffer = StringBuffer();
    for (final byte in bytes) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}