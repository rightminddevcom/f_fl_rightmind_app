// Stub implementation for non-web platforms
import 'dart:typed_data';

class PlatformWebRegistry {
  void registerViewFactory(String viewType, dynamic Function(int) factoryMethod) {
    throw UnsupportedError('platformViewRegistry is only supported on web');
  }
}

final platformViewRegistry = PlatformWebRegistry();

class WindowHelper {
  void open(String url, String target) {
    throw UnsupportedError('window.open is only supported on web');
  }
  
  void alert(String message) {
    throw UnsupportedError('window.alert is only supported on web');  
  }
  
  NavigatorHelper get navigator => NavigatorHelper();
}

final window = WindowHelper();

class NavigatorHelper {
  MediaDevicesHelper? get mediaDevices => MediaDevicesHelper();
}

class MediaDevicesHelper {
  Future<MediaStreamHelper?> getUserMedia(Map<String, dynamic> constraints) async {
    throw UnsupportedError('getUserMedia is only supported on web');
  }
}

class MediaStreamHelper {
  List<dynamic> getTracks() => [];
}

class NotificationHelper {
  static String get permission => 'denied';
  
  static Future<String> requestPermission() async {
    throw UnsupportedError('Notification.requestPermission is only supported on web');
  }
}

class Notification {
  static String get permission => NotificationHelper.permission;
  static Future<String> requestPermission() => NotificationHelper.requestPermission();
}

class Blob {
  Blob(List<dynamic> parts, [String? type]);
}

class Url {
  static String createObjectUrlFromBlob(dynamic blob) {
    throw UnsupportedError('Url.createObjectUrlFromBlob is only supported on web');
  }
  
  static void revokeObjectUrl(String url) {
    throw UnsupportedError('Url.revokeObjectUrl is only supported on web');
  }
}

class AnchorElement {
  AnchorElement({String? href});
  
  void setAttribute(String name, String value) {
    throw UnsupportedError('AnchorElement.setAttribute is only supported on web');
  }
  
  void click() {
    throw UnsupportedError('AnchorElement.click is only supported on web');
  }
}

class MediaRecorder {
  MediaRecorder(dynamic stream);
  
  void addEventListener(String event, Function callback) {
    throw UnsupportedError('MediaRecorder.addEventListener is only supported on web');
  }
  
  void start() {
    throw UnsupportedError('MediaRecorder.start is only supported on web');
  }
  
  void stop() {
    throw UnsupportedError('MediaRecorder.stop is only supported on web');
  }
}

class BlobEvent {
  dynamic get data => null;
}

class FileReader {
  dynamic get result => null;
  Stream get onLoadEnd => const Stream.empty();
  
  void readAsArrayBuffer(dynamic blob) {
    throw UnsupportedError('FileReader.readAsArrayBuffer is only supported on web');
  }
}

class IFrameElement {
  String? src;
  IFrameStyle get style => IFrameStyle();
}

class IFrameStyle {
  String? border;
  String? width;
  String? height;
}
