class SpanModel {
  List<Span>? spans;

  SpanModel({this.spans});

  SpanModel.fromJson(Map<String, dynamic> json) {
    if (json['spans'] != null) {
      spans = <Span>[];
      json['spans'].forEach((v) {
        spans!.add(Span.fromJson(v));
      });
    }
  }

  SpanModel.fromDynamicListJson(List<dynamic> json) {
    spans = <Span>[];
    json.forEach((v) {
      spans!.add(Span.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
    insert = json['insert'] ?? '';
    attributes = json['attributes'] != null
        ? Attributes.fromJson(json['attributes'])
        : Attributes(bold: false,italic: false,size: 16,color: '#FF000000',);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['insert'] = this.insert;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    else{
      this.attributes = Attributes(bold: false,italic: false,size: 16,color: '#FF000000',);
      data['attributes'] = this.attributes!.toJson();
    }
    return data;
  }
}

class Attributes {
  int? size;
  bool? bold;
  bool? italic;
  String? color;

  Attributes(
      {this.size,
        this.bold,
        this.italic,
        this.color,});

  Attributes.fromJson(Map<String, dynamic> json) {
    size = json['size'] ?? 16;
    bold = json['bold'] ?? false;
    italic = json['italic'] ?? false;
    color = json['color'] ?? '#FF000000';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['size'] = this.size ?? 16;
    data['bold'] = this.bold ?? false;
    data['italic'] = this.italic ?? false;
    data['color'] = this.color ?? '#FF000000';
    return data;
  }
}
