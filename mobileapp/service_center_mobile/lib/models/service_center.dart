class ServiceCenter {
  final int id;
  final String name;
  final double latitude;
  final double longitude;

  ServiceCenter({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory ServiceCenter.fromJson(Map<String, dynamic> json) {
    return ServiceCenter(
      id: json['id'],
      name: json['name'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}