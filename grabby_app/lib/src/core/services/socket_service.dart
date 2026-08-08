import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:flutter/foundation.dart';
import '../constants/api_endpoints.dart';

class SocketService {
  io.Socket? _socket;

  bool get isConnected => _socket?.connected ?? false;

  void connect(String token) {
    if (_socket != null && _socket!.connected) {
      debugPrint('Socket already connected');
      return;
    }

    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      // Use 'id' if 'userId' is null, as seen in previous logic
      final String userId = decodedToken['userId']  ?? '';
      final String role = decodedToken['role'] ?? '';

      debugPrint('Connecting to socket at ${ApiEndpoints.baseUrl} with userId: $userId, role: $role');

      _socket = io.io(
        ApiEndpoints.baseUrl,
        io.OptionBuilder()
            .setTransports(['websocket']) // Use websocket first
            // .setAuth({'token': token})    // Many servers require token in auth
            .enableAutoConnect()
            .setQuery({
              'id': userId,
              'role': role,
            })
            .build(),
      );

      _socket!.onConnect((_) {
        debugPrint('Socket connected successfully');
      });

      _socket!.onDisconnect((data) {
        debugPrint('Socket disconnected: $data');
      });

      _socket!.onConnectError((err) {
        debugPrint('Socket connect error: $err');
      });

      _socket!.onError((err) {
        debugPrint('Socket error: $err');
      });

      // _socket!.onConnectTimeout((data) {
      //   debugPrint('Socket connection timeout: $data');
      // });

      _socket!.connect();
    } catch (e) {
      debugPrint('Error initializing socket: $e');
    }
  }

  void emit(String event, dynamic data) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit(event, data);
    } else {
      debugPrint('Cannot emit $event, socket not connected. Current status: ${_socket?.connected}');
      // Optional: try to reconnect if not connected
      if (_socket == null || !_socket!.connected) {
        debugPrint('Attempting to reconnect...');
        _socket?.connect();
      }
    }
  }

  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  void off(String event) {
    _socket?.off(event);
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
    debugPrint('Socket service disconnected manually');
  }
}
