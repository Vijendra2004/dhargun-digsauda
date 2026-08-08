class ZonalTrader {
  final int id;
  final String name;

  ZonalTrader({
    required this.id,
    required this.name,
  });

  factory ZonalTrader.fromJson(Map<String, dynamic> json) {
    return ZonalTrader(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?)?.trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class StateTrader {
  final int id;
  final String name;

  StateTrader({
    required this.id,
    required this.name,
  });

  factory StateTrader.fromJson(Map<String, dynamic> json) {
    return StateTrader(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?)?.trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Distributor {
  final int id;
  final String employeeName;

  Distributor({
    required this.id,
    required this.employeeName,
  });

  factory Distributor.fromJson(Map<String, dynamic> json) {
    return Distributor(
      id: (json['id'] as num?)?.toInt() ?? 0,
      employeeName: (json['employeeName'] as String?)?.trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employeeName': employeeName,
    };
  }
}

