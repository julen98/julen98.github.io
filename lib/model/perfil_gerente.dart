class PerfilGerente {
  String telefono;
  String? facebook;
  String? linkedin;
  String? instagram;

  PerfilGerente({
    required this.telefono,
    this.facebook,
    this.linkedin,
    this.instagram,
  });

  // Recibiendo datos desde el server
  factory PerfilGerente.fromMap(map) {
    return PerfilGerente(
      telefono: map['telefono'],
      facebook: map['facebook'],
      linkedin: map['linkedin'],
      instagram: map['instagram'],
    );
  }

  // Enviando datos al server
  Map<String, dynamic> toMap() {
    return {
      'telefono': telefono,
      'facebook': facebook,
      'linkedin': linkedin,
      'instagram': instagram,
    };
  }
}
