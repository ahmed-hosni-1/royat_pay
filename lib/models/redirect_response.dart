class RedirectResponse {
  RedirectResponse({
      this.result, 
      this.transId, 
      this.url,});

  RedirectResponse.fromJson(dynamic json) {
    result = json['result'];
    transId = json['trans_id'];
    url = json['url'];
  }
  String? result;
  String? transId;
  String? url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['result'] = result;
    map['trans_id'] = transId;
    map['url'] = url;
    return map;
  }

}