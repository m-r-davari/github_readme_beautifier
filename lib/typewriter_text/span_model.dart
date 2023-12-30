class SpanModel {
  List<Span>? spans;

  SpanModel({this.spans});

  SpanModel.fromJson(Map<String, dynamic> json) {
    if (json['spans'] != null) {
      spans = <Span>[];
      json['spans'].forEach((v) {
        spans!.add(new Span.fromJson(v));
      });
    }
  }

  SpanModel.fromDynamicListJson(List<dynamic> json) {
    spans = <Span>[];
    json.forEach((v) {
      spans!.add(new Span.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.spans != null) {
      data['spans'] = this.spans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Span {
  String? insert;
  Attributes? attributes;

  Span({this.insert, this.attributes});

  Span.fromJson(Map<String, dynamic> json) {
    insert = json['insert'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['insert'] = this.insert;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    else{
      data['attributes'] = Attributes(bold: false,italic: false,size: '',color: '',background: '',header: 1);
    }
    return data;
  }
}

class Attributes {
  String? size;
  bool? bold;
  bool? italic;
  String? color;
  String? background;
  int? header;

  Attributes(
      {this.size,
        this.bold,
        this.italic,
        this.color,
        this.background,
        this.header});

  Attributes.fromJson(Map<String, dynamic> json) {
    size = json['size'] ?? '';
    bold = json['bold'] ?? false;
    italic = json['italic'] ?? false;
    color = json['color'] ?? '';
    background = json['background'] ?? '';
    header = json['header'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['size'] = this.size;
    data['bold'] = this.bold;
    data['italic'] = this.italic;
    data['color'] = this.color;
    data['background'] = this.background;
    data['header'] = this.header;
    return data;
  }
}
