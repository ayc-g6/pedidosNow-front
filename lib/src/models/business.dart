class Business {
  final String _id;
  final String _name;
  final String _address;

  Business(String id, String name, String address)
      : _id = id,
        _name = name,
        _address = address;

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(json['id'], json['business_name'], json['address']);
  }

  String get id => _id;
  String get name => _name;
  String get address => _address;
}
