class PerfilAgente {
  String telefono;
  String fechaDeNacimiento;
  String genero;
  String? facebook;
  String? linkedin;
  String? instagram;

  PerfilAgente({
    required this.telefono,
    required this.fechaDeNacimiento,
    required this.genero,
    this.facebook,
    this.linkedin,
    this.instagram,
  });

  // Recibiendo datos desde el server
  factory PerfilAgente.fromMap(map) {
    return PerfilAgente(
      telefono: map['telefono'],
      fechaDeNacimiento: map['fechaDeNacimiento'],
      genero: map['genero'],
      facebook: map['facebook'],
      linkedin: map['linkedin'],
      instagram: map['instagram'],
    );
  }

  // Enviando datos al server
  Map<String, dynamic> toMap() {
    return {
      'telefono': telefono,
      'fechaDeNacimiento': fechaDeNacimiento,
      'genero': genero,
      'facebook': facebook,
      'linkedin': linkedin,
      'instagram': instagram,
    };
  }
}
