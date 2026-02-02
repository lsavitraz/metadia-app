enum DiasSemana {
  segunda(id: 1, nome: 'Segunda-feira'),
  terca(id: 2, nome: 'Terça-feira'),
  quarta(id: 3, nome: 'Quarta-feira'),
  quinta(id: 4, nome: 'Quinta-feira'),
  sexta(id: 5, nome: 'Sexta-feira'),
  sabado(id: 6, nome: 'Sábado'),
  domingo(id: 7, nome: 'Domingo');
  final int id;
  final String nome;

  const DiasSemana({required this.id, required this.nome});

  static DiasSemana fromId(int id) {
    return DiasSemana.values.firstWhere((dia) => dia.id == id);
  }
}
