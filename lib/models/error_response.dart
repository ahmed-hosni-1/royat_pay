class ErrorResponse {
  ErrorResponse({
    this.result,
    this.errorCode,
    this.errorMessage,
    this.errors,
  });

  ErrorResponse.fromJson(dynamic json) {
    result = json['result'];
    errorCode = json['error_code'];
    errorMessage = json['error_message'];
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(Errors.fromJson(v));
      });
    }
  }
  dynamic? result;
  num? errorCode;
  String? errorMessage;
  List<Errors>? errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['result'] = result;
    map['error_code'] = errorCode;
    map['error_message'] = errorMessage;
    if (errors != null) {
      map['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Errors {
  Errors({
    this.errorCode,
    this.errorMessage,
  });

  Errors.fromJson(dynamic json) {
    errorCode = json['error_code'];
    errorMessage = json['error_message'];
  }
  num? errorCode;
  String? errorMessage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error_code'] = errorCode;
    map['error_message'] = errorMessage;
    return map;
  }
}
