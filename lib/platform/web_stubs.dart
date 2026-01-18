// Stub file for non-web platforms
// This file provides empty implementations for web-specific functionality

class PlatformWebStubs {
  static void registerViewFactory(String viewType, dynamic Function(int) factoryMethod) {
    // No-op on non-web platforms
    throw UnsupportedError('platformViewRegistry is only supported on web');
  }
}

class WindowStubs {
  static void open(String url, String target) {
    throw UnsupportedError('window.open is only supported on web');
  }
  
  static void alert(String message) {
    throw UnsupportedError('window.alert is only supported on web');
  }
  
  static NavigatorStubs get navigator => NavigatorStubs();
}

class NavigatorStubs {
  MediaDevicesStubs? get mediaDevices => MediaDevicesStubs();
}

class MediaDevicesStubs {
  Future<dynamic> getUserMedia(Map<String, dynamic> constraints) async {
    throw UnsupportedError('getUserMedia is only supported on web');
  }
}

class NotificationStubs {
  static String get permission => 'denied';
  
  static Future<String> requestPermission() async {
    throw UnsupportedError('Notification.requestPermission is only supported on web');
  }
}

class BlobStubs {
  BlobStubs(List<dynamic> parts, [String? type]);
}

class UrlStubs {
  static String createObjectUrlFromBlob(dynamic blob) {
    throw UnsupportedError('Url.createObjectUrlFromBlob is only supported on web');
  }
  
  static void revokeObjectUrl(String url) {
    throw UnsupportedError('Url.revokeObjectUrl is only supported on web');
  }
}

class AnchorElementStubs {
  AnchorElementStubs({String? href});
  
  void setAttribute(String name, String value) {
    throw UnsupportedError('AnchorElement.setAttribute is only supported on web');
  }
  
  void click() {
    throw UnsupportedError('AnchorElement.click is only supported on web');
  }
}

class MediaRecorderStubs {
  MediaRecorderStubs(dynamic stream);
  
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

class BlobEventStubs {
  dynamic get data => null;
}

class FileReaderStubs {
  dynamic get result => null;
  Stream get onLoadEnd => const Stream.empty();
  
  void readAsArrayBuffer(dynamic blob) {
    throw UnsupportedError('FileReader.readAsArrayBuffer is only supported on web');
  }
}

class IFrameElementStubs {
  String? src;
  IFrameStyleStubs get style => IFrameStyleStubs();
}

class IFrameStyleStubs {
  String? border;
  String? width;
  String? height;
}
