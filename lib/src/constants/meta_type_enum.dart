enum MetaType {
  simples(nome: 'Simples'),
  composta(nome: 'Composta');

  final String nome;

  const MetaType({required this.nome});

  static MetaType fromName(String nome) {
    return MetaType.values.firstWhere((tipo) => tipo.nome == nome);
  }
}