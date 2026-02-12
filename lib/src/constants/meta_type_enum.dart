enum MetaType {
  simples(nome: 'Simples'),
  composta(nome: 'Composta'),
  acumulativa(nome: 'Acumulativa');

  final String nome;

  const MetaType({required this.nome});

  static MetaType fromName(String nome) {
    return MetaType.values.firstWhere((tipo) => tipo.nome == nome);
  }
}