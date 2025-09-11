import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:cpanal/constants/app_colors.dart';
import 'package:cpanal/constants/app_strings.dart';
import 'package:cpanal/controller/request_controller/request_controller.dart';
import 'package:just_audio/just_audio.dart';

class RequestDetailsSendComment extends StatefulWidget {
  final String id;
  RequestDetailsSendComment(this.id);

  @override
  _RequestDetailsSendCommentState createState() =>
      _RequestDetailsSendCommentState();
}

class _RequestDetailsSendCommentState extends State<RequestDetailsSendComment> {
  final _audioRecorder = AudioRecorder();
  String? _recordedFilePath;
  bool _isRecording = false;
  Timer? _timer;
  int _elapsedTime = 0;

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/recorded_audio.m4a';

        await _audioRecorder.start(
          RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
          path: path,
        );

        setState(() {
          _isRecording = true;
          _elapsedTime = 0;
          _timer = Timer.periodic(Duration(seconds: 1), (timer) {
            setState(() {
              _elapsedTime++;
            });
          });
        });
      }
    } catch (e) {
      print("Error starting recording: $e");
    }
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
    return Consumer<RequestController>(
      builder: (context, value, child) {
        if(value.isAddCommentSuccess == true){
          print("ADDED SUCCESS");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            value.getRequestComment(context, widget.id);
          });
          value.isAddCommentSuccess = false;
        }
        Future<void> _stopRecording() async {
          try {
            final path = await _audioRecorder.stop();
            if (path != null) {
              final file = File(path);
              if (await file.exists()) {
                Duration? duration = await _getAudioDuration(path);
                if (duration != null && duration.inSeconds > 0) {
                  print("Audio Duration: ${duration.inSeconds} seconds");
                  value.addComment(context, id: widget.id, voicePath: path);
                } else {
                  print("Error: Recorded audio has zero duration!");
                }
              } else {
                print("Error: Recorded file does not exist.");
              }
            }
          } catch (e) {
            print("Error stopping recording: $e");
          } finally {
            setState(() {
              _isRecording = false;
              _timer?.cancel();
            });
          }
        }

        return Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.75,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: _isRecording
                        ? MediaQuery.of(context).size.width * 0.48
                        : MediaQuery.of(context).size.width * 0.54,
                    child: TextField(
                      controller: value.contentController,
                      decoration: InputDecoration(
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: AppStrings.typeYourMessage.tr().toUpperCase(),
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                            color: Color(0xff5E5E5E)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
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
                            images: value.listXAttachmentPersonalImage);
                      }
                    },
                    child: SvgPicture.asset("assets/images/svg/image.svg", color: Color(AppColors.primary),),
                  ),
                  SizedBox(width: 15),
                  GestureDetector(
                    onTap: _isRecording ? () => _stopRecording() : null,
                    onLongPress: _isRecording ? () => _stopRecording() : _startRecording,
                    onLongPressUp: () => _stopRecording(),
                    child: _isRecording
                        ? Text(
                      '$_elapsedTime s',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: Color(AppColors.primary)),
                    )
                        : SvgPicture.asset("assets/images/svg/voice.svg", color: Color(AppColors.primary)),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            CircleAvatar(
              backgroundColor: Color(0xFFE93F81),
              radius: 24,
              child: GestureDetector(
                onTap: () {
                  value.addComment(context, id: widget.id);
                },
                child: (value.isAddCommentLoading == false)
                    ? SvgPicture.asset("assets/images/svg/send.svg", color: Color(0xffFFFFFF))
                    : Padding(
                  padding: const EdgeInsets.all(3.0),
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

