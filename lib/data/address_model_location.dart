/// service : {"name":"address","version":"2.0","operation":"GetAddress","time":"6(ms)"}
/// status : "OK"
/// input : {"point":{"x":"127.05855","y":"37.60168"},"crs":"","type":"PARCEL"}
/// result : [{"zipcode":"02789","type":"parcel","text":"서울특별시 성북구 석관동 409","structure":{"level0":"대한민국","level1":"서울특별시","level2":"성북구","level3":"","level4L":"석관동","level4LC":"1129013900","level4A":"석관동","level4AC":"1129081000","level5":"409임","detail":""}}]

class AddressModelForLocation {
  AddressModelForLocation({
      Service? service, 
      String? status, 
      Input? input, 
      List<Result>? result,}){
    _service = service;
    _status = status;
    _input = input;
    _result = result;
}

  AddressModelForLocation.fromJson(dynamic json) {
    _service = json['service'] != null ? Service.fromJson(json['service']) : null;
    _status = json['status'];
    _input = json['input'] != null ? Input.fromJson(json['input']) : null;
    if (json['result'] != null) {
      _result = [];
      json['result'].forEach((v) {
        _result?.add(Result.fromJson(v));
      });
    }
  }
  Service? _service;
  String? _status;
  Input? _input;
  List<Result>? _result;

  Service? get service => _service;
  String? get status => _status;
  Input? get input => _input;
  List<Result>? get result => _result;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_service != null) {
      map['service'] = _service?.toJson();
    }
    map['status'] = _status;
    if (_input != null) {
      map['input'] = _input?.toJson();
    }
    if (_result != null) {
      map['result'] = _result?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// zipcode : "02789"
/// type : "parcel"
/// text : "서울특별시 성북구 석관동 409"
/// structure : {"level0":"대한민국","level1":"서울특별시","level2":"성북구","level3":"","level4L":"석관동","level4LC":"1129013900","level4A":"석관동","level4AC":"1129081000","level5":"409임","detail":""}

class Result {
  Result({
      String? zipcode, 
      String? type, 
      String? text, 
      Structure? structure,}){
    _zipcode = zipcode;
    _type = type;
    _text = text;
    _structure = structure;
}

  Result.fromJson(dynamic json) {
    _zipcode = json['zipcode'];
    _type = json['type'];
    _text = json['text'];
    _structure = json['structure'] != null ? Structure.fromJson(json['structure']) : null;
  }
  String? _zipcode;
  String? _type;
  String? _text;
  Structure? _structure;

  String? get zipcode => _zipcode;
  String? get type => _type;
  String? get text => _text;
  Structure? get structure => _structure;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['zipcode'] = _zipcode;
    map['type'] = _type;
    map['text'] = _text;
    if (_structure != null) {
      map['structure'] = _structure?.toJson();
    }
    return map;
  }

}

/// level0 : "대한민국"
/// level1 : "서울특별시"
/// level2 : "성북구"
/// level3 : ""
/// level4L : "석관동"
/// level4LC : "1129013900"
/// level4A : "석관동"
/// level4AC : "1129081000"
/// level5 : "409임"
/// detail : ""

class Structure {
  Structure({
      String? level0, 
      String? level1, 
      String? level2, 
      String? level3, 
      String? level4L, 
      String? level4LC, 
      String? level4A, 
      String? level4AC, 
      String? level5, 
      String? detail,}){
    _level0 = level0;
    _level1 = level1;
    _level2 = level2;
    _level3 = level3;
    _level4L = level4L;
    _level4LC = level4LC;
    _level4A = level4A;
    _level4AC = level4AC;
    _level5 = level5;
    _detail = detail;
}

  Structure.fromJson(dynamic json) {
    _level0 = json['level0'];
    _level1 = json['level1'];
    _level2 = json['level2'];
    _level3 = json['level3'];
    _level4L = json['level4L'];
    _level4LC = json['level4LC'];
    _level4A = json['level4A'];
    _level4AC = json['level4AC'];
    _level5 = json['level5'];
    _detail = json['detail'];
  }
  String? _level0;
  String? _level1;
  String? _level2;
  String? _level3;
  String? _level4L;
  String? _level4LC;
  String? _level4A;
  String? _level4AC;
  String? _level5;
  String? _detail;

  String? get level0 => _level0;
  String? get level1 => _level1;
  String? get level2 => _level2;
  String? get level3 => _level3;
  String? get level4L => _level4L;
  String? get level4LC => _level4LC;
  String? get level4A => _level4A;
  String? get level4AC => _level4AC;
  String? get level5 => _level5;
  String? get detail => _detail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['level0'] = _level0;
    map['level1'] = _level1;
    map['level2'] = _level2;
    map['level3'] = _level3;
    map['level4L'] = _level4L;
    map['level4LC'] = _level4LC;
    map['level4A'] = _level4A;
    map['level4AC'] = _level4AC;
    map['level5'] = _level5;
    map['detail'] = _detail;
    return map;
  }

}

/// point : {"x":"127.05855","y":"37.60168"}
/// crs : ""
/// type : "PARCEL"

class Input {
  Input({
      Point? point, 
      String? crs, 
      String? type,}){
    _point = point;
    _crs = crs;
    _type = type;
}

  Input.fromJson(dynamic json) {
    _point = json['point'] != null ? Point.fromJson(json['point']) : null;
    _crs = json['crs'];
    _type = json['type'];
  }
  Point? _point;
  String? _crs;
  String? _type;

  Point? get point => _point;
  String? get crs => _crs;
  String? get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_point != null) {
      map['point'] = _point?.toJson();
    }
    map['crs'] = _crs;
    map['type'] = _type;
    return map;
  }

}

/// x : "127.05855"
/// y : "37.60168"

class Point {
  Point({
      String? x, 
      String? y,}){
    _x = x;
    _y = y;
}

  Point.fromJson(dynamic json) {
    _x = json['x'];
    _y = json['y'];
  }
  String? _x;
  String? _y;

  String? get x => _x;
  String? get y => _y;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['x'] = _x;
    map['y'] = _y;
    return map;
  }

}

/// name : "address"
/// version : "2.0"
/// operation : "GetAddress"
/// time : "6(ms)"

class Service {
  Service({
      String? name, 
      String? version, 
      String? operation, 
      String? time,}){
    _name = name;
    _version = version;
    _operation = operation;
    _time = time;
}

  Service.fromJson(dynamic json) {
    _name = json['name'];
    _version = json['version'];
    _operation = json['operation'];
    _time = json['time'];
  }
  String? _name;
  String? _version;
  String? _operation;
  String? _time;

  String? get name => _name;
  String? get version => _version;
  String? get operation => _operation;
  String? get time => _time;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['version'] = _version;
    map['operation'] = _operation;
    map['time'] = _time;
    return map;
  }

}