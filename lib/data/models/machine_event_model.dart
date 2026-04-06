class MachineEventModel {
  const MachineEventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
  });

  final int id;
  final String title;
  final String description;
  final String severity;

  factory MachineEventModel.fromApi(Map<String, dynamic> map) {
    return MachineEventModel(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      title: map['title']?.toString() ?? 'Workshop update received',
      description:
          map['description']?.toString() ??
          'A new machine event was received from the remote API.',
      severity: map['severity']?.toString() ?? 'Info',
    );
  }

  factory MachineEventModel.fromMap(Map<String, dynamic> map) {
    return MachineEventModel(
      id: map['id'] as int? ?? 0,
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      severity: map['severity']?.toString() ?? 'Info',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'severity': severity,
    };
  }
}
