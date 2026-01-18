class GetOneAuto {
  bool? status;
  String? message;
  Res? res;

  GetOneAuto({this.status, this.message, this.res});

  GetOneAuto.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    res = json['res'] != null ? Res.fromJson(json['res']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (res != null) {
      data['res'] = res!.toJson();
    }
    return data;
  }
}

class Res {
  int? start;
  String? body;
  int? interval;
  String? charset;
  String? subject;
  int? stop;
  String? from;
  int? isHtml;

  Res(
      {this.start,
        this.body,
        this.interval,
        this.charset,
        this.subject,
        this.stop,
        this.from,
        this.isHtml});

  Res.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    body = json['body'];
    interval = json['interval'];
    charset = json['charset'];
    subject = json['subject'];
    stop = json['stop'];
    from = json['from'];
    isHtml = json['is_html'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['body'] = body;
    data['interval'] = interval;
    data['charset'] = charset;
    data['subject'] = subject;
    data['stop'] = stop;
    data['from'] = from;
    data['is_html'] = isHtml;
    return data;
  }
}
