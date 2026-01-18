// Web implementation - re-exports from dart:html and dart:ui_web
export 'dart:html' show window, Notification, Blob, Url, AnchorElement, MediaRecorder, BlobEvent, FileReader, IFrameElement;
import 'dart:ui_web' as ui_web;

// Re-export platformViewRegistry from dart:ui_web
final platformViewRegistry = ui_web.platformViewRegistry;
