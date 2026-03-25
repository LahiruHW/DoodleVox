import 'dart:io';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

enum DawConnectionState {
  disconnected,
  connecting,
  connected,
  sending,
  sent,
  error,
}

class DVDawProvider extends ChangeNotifier {
  final _log = Logger('DVDawProvider');

  DawConnectionState _state = .disconnected;
  String? _serverUrl;
  String? _token;
  String? _errorMessage;

  DawConnectionState get state => _state;
  String? get serverUrl => _serverUrl;
  String? get errorMessage => _errorMessage;
  bool get isConnected => _state == .connected || _state == .sent;

  /// Parse the QR code URL and validate it matches the expected format.
  /// Expected: `http://ip:port?token=token`
  Uri? _parseQrUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.scheme != 'http' || !uri.queryParameters.containsKey('token')) {
        _errorMessage = 'Invalid QR code. Expected a DoodleVox DAW URL.';
        return null;
      }
      _serverUrl = '${uri.scheme}://${uri.authority}';
      _token = uri.queryParameters['token'];
      _log.info('Parsed server: $_serverUrl, token: $_token');
      return uri;
    } catch (e) {
      _log.severe('Failed to parse QR URL: $e');
      _errorMessage = 'Could not read QR code.';
      return null;
    }
  }

  /// Perform the GET handshake to establish the session.
  Future<bool> connect(String qrUrl) async {
    if (_state == .connecting) return false;

    final uri = _parseQrUrl(qrUrl);
    if (uri == null) {
      _state = .error;
      notifyListeners();
      return false;
    }

    _state = .connecting;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http
          .get(uri)
          .timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        _state = .connected;
        _log.info('Connected to DAW');
        notifyListeners();
        return true;
      } else if (response.statusCode == 403) {
        _errorMessage =
            'Invalid session token. Re-open the plugin and try again.';
        _state = .error;
        _log.warning('403 Forbidden — bad token');
        notifyListeners();
        return false;
      } else {
        _errorMessage = 'Connection failed (${response.statusCode})';
        _state = .error;
        _log.warning('Handshake failed: ${response.statusCode}');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage =
          'Could not reach the DAW. Make sure both devices are on the same Wi-Fi network.';
      _state = .error;
      _log.severe('Connection error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Send the recorded audio file to the DAW via POST.
  Future<bool> sendToDaw(String filePath) async {
    if (!isConnected || _serverUrl == null || _token == null) {
      _errorMessage = 'Not connected to DAW';
      _state = DawConnectionState.error;
      notifyListeners();
      return false;
    }

    _state = DawConnectionState.sending;
    _errorMessage = null;
    notifyListeners();

    try {
      final file = File(filePath);
      if (!await file.exists()) {
        _errorMessage = 'Recording file not found';
        _state = DawConnectionState.error;
        notifyListeners();
        return false;
      }

      final bytes = await file.readAsBytes();
      final uri = Uri.parse('$_serverUrl?token=$_token');

      final response = await http
          .post(
            uri,
            body: bytes,
            headers: {
              'Content-Type': 'application/octet-stream',
              'Content-Length': bytes.length.toString(),
            },
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        _state = DawConnectionState.sent;
        _log.info('Audio sent to DAW');
        notifyListeners();
        return true;
      } else if (response.statusCode == 403) {
        _errorMessage = 'Session expired. Please reconnect.';
        _state = DawConnectionState.error;
        _log.warning('403 during send');
        notifyListeners();
        return false;
      } else {
        _errorMessage = 'Failed to send audio (${response.statusCode})';
        _state = DawConnectionState.error;
        _log.warning('Send failed: ${response.statusCode}');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to send audio. Check your connection.';
      _state = DawConnectionState.error;
      _log.severe('Send error: $e');
      notifyListeners();
      return false;
    }
  }

  /// Disconnect and reset all state.
  void disconnect() {
    _state = DawConnectionState.disconnected;
    _serverUrl = null;
    _token = null;
    _errorMessage = null;
    _log.info('Disconnected from DAW');
    notifyListeners();
  }

  /// Reset from sent → connected so the user can send another clip.
  void resetToConnected() {
    if (_serverUrl != null && _token != null) {
      _state = DawConnectionState.connected;
      _errorMessage = null;
      notifyListeners();
    }
  }
}
