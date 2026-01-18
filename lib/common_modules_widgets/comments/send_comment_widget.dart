import 'dart:async';
import 'package:cpanal/common_modules_widgets/comments/record_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cpanal/common_modules_widgets/comments/logic/view_model.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import '../../../platform/web_imports.dart' as web_platform;

class SendCommentWidget extends StatefulWidget {
  final String id;
  final String slug;
  const SendCommentWidget(this.id, this.slug, {super.key});

  @override
  _SendCommentWidgetState createState() =>
      _SendCommentWidgetState();
}

class _SendCommentWidgetState extends State<SendCommentWidget> {
  final _audioRecorder = AudioRecorder();
  String? _recordedFilePath;
  bool _isRecording = false;
  late RecordingService? recordingService;

  Timer? _timer;
  int _elapsedTime = 0;
  web_platform.MediaRecorder? _webRecorder;
  final List<web_platform.Blob> _audioChunks = [];
  @override
  void initState() {
    recordingService = RecordingService();
    super.initState();
  }


  Future<void> _startWebRecording() async {
    final stream = await web_platform.window.navigator.mediaDevices?.getUserMedia({'audio': true});
    if (stream == null) return;

    // 🧹 تأكد من تنظيف القديم قبل بدء تسجيل جديد
    _audioChunks.clear();
    _webRecorder?.stop();
    _webRecorder = null;

    _webRecorder = web_platform.MediaRecorder(stream);
    _webRecorder!.addEventListener('dataavailable', (event) {
      final e = event as web_platform.BlobEvent;
      if (e.data != null) _audioChunks.add(e.data!);
    });

    _webRecorder!.addEventListener('stop', (_) {
      // عند الإيقاف، نوقف كل الميكروفونات المفتوحة
      for (var track in stream.getTracks()) {
        track.stop();
      }
    });

    _webRecorder!.start();
    print("🎙️ Web recording started");
  }

  Future<Uint8List?> _stopWebRecording() async {
    final completer = Completer<Uint8List>();
    if (_webRecorder == null) return null;

    _webRecorder!.addEventListener('stop', (_) async {
      final blob = web_platform.Blob(_audioChunks, 'audio/webm');
      _audioChunks.clear(); // ✅ تنظيف الذاكرة بعد كل تسجيل
      final reader = web_platform.FileReader();
      reader.readAsArrayBuffer(blob);
      reader.onLoadEnd.listen((_) {
        completer.complete(reader.result as Uint8List);
      });

      _webRecorder = null; // ✅ مهم جدًا لإعادة التهيئة في التسجيل القادم
    });

    _webRecorder!.stop();
    print("🛑 Web recording stopped");
    return completer.future;
  }


  Future<void> _startRecording() async {
    if (_isRecording) return;
    _elapsedTime = 0;

    if (kIsWeb) {
      await _startWebRecording();
    } else {
      await recordingService!.start();
    }

    setState(() {
      _isRecording = true;
    });

    // ⏱️ تشغيل العداد
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsedTime++;
      });
    });
  }
  Future<Duration?> _getAudioDuration(String filePath) async {
    try {
      final player = AudioPlayer();
      await player.setFilePath(filePath);
      Duration? duration = player.duration;
      await player.dispose();
      return duration;
    } catch (e) {
      print("Error getting duration: $e");
      return null;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(
      builder: (context, value, child) {
        if(value.isAddCommentSuccess == true){
          print("ADDED SUCCESS");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(const Duration(seconds: 1), () {
              value.getComment(context, widget.slug, widget.id, pages: 1);
            });
          });
          value.isAddCommentSuccess = false;

        }
        Future<void> stopRecording() async {
          if (!_isRecording) return;
          _timer?.cancel();

          if (kIsWeb) {
            final bytes = await _stopWebRecording();
            if (bytes != null && bytes.isNotEmpty) {
              print("✅ Web voice recorded ${bytes.length} bytes");
              await Provider.of<CommentProvider>(context, listen: false).addComment(
                context,
                id: widget.id,
                slug: "csrequests",
                voiceBytes: bytes,
              );
            } else {
              print("⚠️ Empty audio on web!");
            }
          } else {
            final result = await recordingService!.stop();
            if (result?.path != null) {
              print("✅ Mobile voice recorded: ${result!.path}");
              await Provider.of<CommentProvider>(context, listen: false).addComment(
                context,
                id: widget.id,
                slug: "csrequests",
                voicePath: result.path,
              );
            }
          }

          setState(() {
            _isRecording = false;
            _elapsedTime = 0;
          });
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: !kIsWeb?MediaQuery.of(context).size.width * 0.75:MediaQuery.of(context).size.width * 0.5,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width:!kIsWeb? _isRecording
                        ? MediaQuery.of(context).size.width * 0.48
                        : MediaQuery.of(context).size.width * 0.54:
                    _isRecording
                        ? MediaQuery.of(context).size.width * 0.4
                        : MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      controller: value.contentController,
                      decoration: InputDecoration(
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: AppStrings.typeYourMessage.tr().toUpperCase(),
                        hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xff5E5E5E)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      value.listAttachmentPersonalImage = [];
                      value.listXAttachmentPersonalImage = [];
                      await value.getImage(
                          context,
                          image1: value.attachmentPersonalImage,
                          image2: value.XImageFileAttachmentPersonal,
                          list2: value.listXAttachmentPersonalImage,
                          one: false,
                          list: value.listAttachmentPersonalImage);
                      if (value.listXAttachmentPersonalImage.isNotEmpty) {
                        value.addComment(context,
                            id: widget.id,
                            slug: "csrequests",
                            images: value.listXAttachmentPersonalImage);
                      }
                    },
                    child: SvgPicture.asset("assets/images/svg/image.svg", color: Color(AppColors.primary),),
                  ),
                  const SizedBox(width: 15),
                  GestureDetector(
                    onLongPressStart: (_) => _startRecording(),
                    onLongPressEnd: (_) => stopRecording(),
                    child: _isRecording
                        ? Text(
                      '${_elapsedTime}s',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(AppColors.primary),
                      ),
                    )
                        : SvgPicture.asset(
                      "assets/images/svg/voice.svg",
                      color: Color(AppColors.primary),
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Color(AppColors.primary),
              radius: 24,
              child: GestureDetector(
                onTap: () {
                  value.addComment(context, id: widget.id, slug: "csrequests",);
                },
                child: (value.isAddCommentLoading == false)
                    ? SvgPicture.asset("assets/images/svg/send.svg", color: const Color(0xffFFFFFF))
                    : const Padding(
                  padding: EdgeInsets.all(3.0),
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

