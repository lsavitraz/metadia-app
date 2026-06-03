# MetaDia

> Metas simples para o seu dia a dia.

MetaDia é um aplicativo mobile desenvolvido em Flutter para acompanhamento diário de metas, hábitos e objetivos pessoais.

O aplicativo foi concebido para oferecer uma experiência simples, rápida e privada, permitindo que qualquer pessoa acompanhe sua evolução diária sem depender de cadastros, contas, sincronizações obrigatórias ou serviços externos.

Todos os dados permanecem armazenados localmente no dispositivo através de SQLite.

---

## Visão Geral

O MetaDia nasceu com um objetivo simples:

**ajudar pessoas a transformarem objetivos em pequenas ações diárias.**

Em vez de focar apenas no resultado final, o aplicativo incentiva a construção de consistência através do registro diário de hábitos e atividades.

---

## Princípios do Produto

### Simplicidade

Registrar progresso deve levar apenas alguns segundos.

### Rapidez

O aplicativo foi pensado para ser utilizado diversas vezes ao longo do dia.

### Clareza

O progresso é apresentado de forma visual e intuitiva.

### Privacidade

Nenhum dado é enviado para servidores externos.

### Funcionamento Offline

O aplicativo funciona integralmente sem conexão com a internet.

---

# Funcionalidades

## Metas Simples

Indicadas para hábitos realizados uma única vez por dia.

### Exemplos

- Meditar
- Ler
- Caminhar
- Estudar
- Fazer oração

### Cálculo

```text
COUNT(registros)
```

---

## Metas Compostas

Indicadas para objetivos compostos por múltiplas atividades.

### Exemplos

- Projeto Saúde
- Rotina Fitness
- Desenvolvimento Pessoal
- Organização da Casa

Cada atividade pode possuir dias específicos da semana.

### Cálculo

```text
COUNT(DISTINCT data)
```

O progresso é contabilizado por dia realizado, independentemente da quantidade de atividades concluídas naquele dia.

---

## Metas Acumulativas

Indicadas para objetivos baseados em quantidade acumulada.

### Exemplos

- Copos de água
- Páginas lidas
- Minutos estudados
- Quilômetros percorridos

### Cálculo

```text
SUM(quantidade)
```

Permite incremento e decremento diário.

O card exibe:

```text
Hoje: - quantidade +
```

permitindo acompanhar claramente o valor registrado no dia atual.

---

# Recursos Disponíveis

- Cadastro de metas
- Edição de metas
- Arquivamento de metas
- Exclusão de metas
- Duplicação de metas
- Limpeza de progresso
- Calendário semanal
- Navegação entre semanas
- Relatórios por período
- Indicadores de progresso
- Percentuais de conclusão
- Histórico consolidado

---

# Regras de Negócio

## Histórico

Metas arquivadas:

- não aparecem na tela principal;
- continuam disponíveis nos relatórios.

Metas excluídas:

- são removidas definitivamente;
- deixam de aparecer nos relatórios.

---

## Edição de Metas com Histórico

Quando uma meta já possui progresso registrado:

### Permitido

- alterar nome;
- alterar descrição;
- alterar objetivo;
- alterar período;
- alterar cor;
- adicionar atividades.

### Bloqueado

- alterar o tipo da meta;
- remover atividades existentes.

Essa regra preserva a integridade do histórico já registrado.

---

# Arquitetura

```text
UI
↓
Views
↓
Controllers
↓
Repositories
↓
SQLite
```

## Princípios

- UI não acessa SQLite diretamente.
- Controllers concentram regras de tela.
- Repositories concentram persistência.
- Models representam dados.
- Banco local é a única fonte de verdade.
- Aplicação totalmente offline.

---

# Stack Tecnológica

## Framework

- Flutter

## Linguagem

- Dart

## Gerenciamento de Estado

- GetX

## Persistência

- SQLite
- sqflite

## Utilitários

- uuid
- path

## Localização

- flutter_localizations

---

# Estrutura do Projeto

```text
lib/
├── main.dart
└── src/
    ├── config/
    ├── constants/
    ├── database/
    ├── model/
    ├── pages/
    │   ├── base/
    │   ├── common_widgets/
    │   ├── create_meta/
    │   ├── home/
    │   ├── reports/
    │   └── splash/
    └── pages_route/
```

---

# Persistência

Banco local:

```text
metadia_db.db
```

Tabelas principais:

- metas
- atividades
- atividade_dias
- registros

A tabela `registros` é a fonte oficial para cálculo de progresso e relatórios.

---

# Build Android

```bash
flutter clean
flutter pub get
flutter analyze
flutter build appbundle --release
```

Application ID:

```text
br.com.appmetadia.metadia
```

Assinatura:

- Keystore corporativa da Invista Gestão e Tecnologia.
- Chave dedicada para publicação do MetaDia.

---

# Build iOS

```bash
flutter clean
flutter pub get
flutter analyze
flutter build ios --release
```

Bundle Identifier:

```text
br.com.appmetadia.metadia
```

Publicação:

- Abrir Runner.xcworkspace
- Gerar Archive
- Enviar para App Store Connect

---

# Site e Documentação

Site oficial:

https://appmetadia.com.br

Política de Privacidade:

https://appmetadia.com.br/politica-de-privacidade.html

Termos de Uso:

https://appmetadia.com.br/termos-de-uso.html

---

# Roadmap

## Versão 1.1

- ☕ Pagar um café
- ❤️ Fazer uma contribuição
- Tela de apoio ao projeto

## Versão 1.2

- Melhorias de relatórios
- Indicadores de consistência
- Comparativos de desempenho

## Versão 2.0

- Backup local
- Backup Google Drive
- Backup iCloud
- Sincronização entre dispositivos

---

# Licença

Todos os direitos reservados.

© MetaDia
