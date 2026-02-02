enum Meses {
  janeiro(id: 1, nome: 'Janeiro'),
  fevereiro(id: 2, nome: 'Fevereiro'),
  marco(id: 3, nome: 'Março'),
  abril(id: 4, nome: 'Abril'),
  maio(id: 5, nome: 'Maio'),
  junho(id: 6, nome: 'Junho'),
  julho(id: 7, nome: 'Julho'),
  agosto(id: 8, nome: 'Agosto'),
  setembro(id: 9, nome: 'Setembro'),
  outubro(id: 10, nome: 'Outubro'),
  novembro(id: 11, nome: 'Novembro'),
  dezembro(id: 12, nome: 'Dezembro');

  final int id;
  final String nome;

  const Meses({required this.id, required this.nome});

  static Meses fromId(int id) {
    return Meses.values.firstWhere((mes) => mes.id == id);
  }
}
