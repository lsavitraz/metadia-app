class ReportMetaResult {
  final String metaId;
  final String nome;
  final int objetivo;
  final int totalNoPeriodo;
  final int totalGeral;
  final double percentualPeriodo;
  final double percentualGeral;
  final DateTime dataInicial;
  final DateTime dataFinal;

  ReportMetaResult({
    required this.metaId,
    required this.nome,
    required this.objetivo,
    required this.totalNoPeriodo,
    required this.totalGeral,
    required this.percentualPeriodo,
    required this.percentualGeral,
    required this.dataInicial,
    required this.dataFinal,
  });
}