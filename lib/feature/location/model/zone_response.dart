class ZoneResponseModel {
  final bool _isSuccess;
  final String _zoneId;
  final String? _message;
  final int? _totalServiceCount;
  ZoneResponseModel(this._isSuccess, this._message, this._zoneId, this._totalServiceCount);

  String? get message => _message;
  String get zoneIds => _zoneId;
  bool get isSuccess => _isSuccess;
  int? get totalServiceCount=> _totalServiceCount;
}
