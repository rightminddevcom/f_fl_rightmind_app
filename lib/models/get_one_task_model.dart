class GetOneTaskModel {
  bool? status;
  String? message;
  Task? task;

  GetOneTaskModel({this.status, this.message, this.task});

  GetOneTaskModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    task = json['task'] != null ? Task.fromJson(json['task']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (task != null) {
      data['task'] = task!.toJson();
    }
    return data;
  }
}

class Task {
  int? id;
  int? progress;
  String? title;
  String? content;
  String? icon;
  List<AssignTo>? assignTo;
  List<SubTasks>? subTasks;
  String? dueDate;
  String? createAt;
  String? status;

  Task(
      {this.id,
        this.title,
        this.progress,
        this.content,
        this.icon,
        this.assignTo,
        this.subTasks,
        this.createAt,
        this.dueDate,
        this.status});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    progress = json['progress'];
    title = json['title'];
    content = json['content'];
    icon = json['icon'];
    if (json['assignTo'] != null) {
      assignTo = <AssignTo>[];
      json['assignTo'].forEach((v) {
        assignTo!.add(AssignTo.fromJson(v));
      });
    }
    if (json['subTasks'] != null) {
      subTasks = <SubTasks>[];
      json['subTasks'].forEach((v) {
        subTasks!.add(SubTasks.fromJson(v));
      });
    }
    dueDate = json['dueDate'];
    createAt = json['createdAt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['icon'] = icon;
    if (assignTo != null) {
      data['assignTo'] = assignTo!.map((v) => v.toJson()).toList();
    }
    if (subTasks != null) {
      data['subTasks'] = subTasks!.map((v) => v.toJson()).toList();
    }
    data['dueDate'] = dueDate;
    data['status'] = status;
    return data;
  }
}

class AssignTo {
  int? id;
  String? name;

  AssignTo({this.id, this.name});

  AssignTo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class SubTasks {
  String? name;
  bool? status;

  SubTasks({this.name, this.status});

  SubTasks.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['status'] = status;
    return data;
  }
}
