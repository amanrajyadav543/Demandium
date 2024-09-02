class ForgetPasswordBody {
  String? identity;
  String? identityType;
  String? otp;
  int? fromUrl;

  ForgetPasswordBody(
      {this.identity, this.identityType, this.otp, this.fromUrl});

  ForgetPasswordBody.fromJson(Map<String, dynamic> json) {
    identity = json['identity'];
    identityType = json['identity_type'];
    otp = json['otp'];
    fromUrl = json['from_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identity'] = identity;
    data['identity_type'] = identityType;
    data['otp'] = otp;
    data['from_url'] = fromUrl;
    return data;
  }
}