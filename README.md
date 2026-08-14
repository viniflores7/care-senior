# Care Senior

Aplicativo de acompanhamento de idosos em clínicas/instituições de longa
permanência, conectando a **equipe da clínica** (colaboradores) e os
**responsáveis** (familiares) de cada idoso.

Este repositório contém apenas o **app Flutter** (protótipo funcional com
dados mockados, sem backend real). Este README documenta as entidades,
relações e features implementadas no app para orientar a construção do
backend em **Node.js + NestJS**.

## Stack

| Camada                            | Tecnologia                 |
| --------------------------------- | -------------------------- |
| App                               | Flutter (este repositório) |
| Backend                           | Node.js + NestJS           |
| Banco de dados                    | PostgreSQL                 |
| Armazenamento de arquivos (fotos) | AWS S3                     |
| Hospedagem / deploy               | A definir (em estudo)      |

> No app, todo o acesso a dados passa por `Repository` → `Service` →
> `ViewModel`, hoje implementado com `lib/data/mock/mock_data.dart` como
> única fonte de dados falsos. Ao integrar o backend real, basta substituir
> a implementação `Mock*Repository` por uma que consuma a API NestJS,
> mantendo a mesma interface (`abstract class *Repository`).

## Papéis de usuário

- **Staff (colaborador)** — funcionário de uma clínica (`role: 'staff'`).
  Gerencia a agenda da clínica, registra saúde e vincula responsáveis.
- **Guardian (responsável)** — familiar de um ou mais idosos
  (`role: 'guardian'`). Acompanha em modo leitura.

## Entidades e relações

### Clinic (clínica)

| Campo               | Tipo        | Observação                                                                                    |
| ------------------- | ----------- | --------------------------------------------------------------------------------------------- |
| id                  | string (PK) |                                                                                               |
| name                | string      |                                                                                               |
| address             | string      |                                                                                               |
| phone               | string      |                                                                                               |
| operatingHours      | string      | texto livre (ex.: "Segunda a domingo, 24 horas")                                              |
| activities          | string[]    | lista de atividades/serviços oferecidos pela clínica                                          |
| responsiblePeople   | string      | texto livre com o responsável técnico                                                         |
| whatsappPhone       | string      | usado só para o responsável iniciar contato via WhatsApp (não é um fluxo de mensagens do app) |
| latitude, longitude | double      | usados no preview de mapa (hoje mockado)                                                      |
| photoPath           | string?     | referência a arquivo (S3 no backend real)                                                     |

Relações: **1 Clinic → N Resident**, **1 Clinic → N StaffMember**,
**1 Clinic → N Activity**.

### StaffMember (colaborador)

| Campo     | Tipo                 | Observação                                                                                                              |
| --------- | -------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| id        | string (PK)          |                                                                                                                         |
| name      | string               |                                                                                                                         |
| email     | string               | login                                                                                                                   |
| role      | string               | cargo em texto livre hoje (ex.: "Enfermeira", "Cuidador", "Coordenadora") — vale virar enum/tabela de cargos no backend |
| clinicId  | string (FK → Clinic) | colaborador pertence a **uma única** clínica                                                                            |
| photoPath | string?              |                                                                                                                         |
| cpf       | string?              | dado sensível — **deve ser criptografado em repouso no backend**                                                        |

### Guardian (responsável)

| Campo               | Tipo        | Observação                                                                                                                    |
| ------------------- | ----------- | ------------------------------------------------------------------------------------------------------------------------------ |
| id                  | string (PK) |                                                                                                                                |
| name                | string      |                                                                                                                                |
| email               | string      | login                                                                                                                          |
| residentIds         | string[]    | idosos sob sua responsabilidade                                                                                               |
| photoPath           | string?     | opcional — pode ser definida/alterada em qualquer cadastro (autocadastro, cadastro pela equipe ou depois em Segurança)       |
| cpf                 | string      | **obrigatório em todo cadastro de responsável** (autocadastro ou pela equipe) — dado sensível, **deve ser criptografado em repouso no backend** |
| contactedClinicIds  | string[]    | clínicas que o responsável já contatou enquanto não tem nenhum idoso vinculado — ver seção de autocadastro abaixo             |

Relação real: **Guardian ↔ Resident é N:N** (um responsável pode acompanhar
mais de um idoso; um idoso pode ter mais de um responsável cadastrado) —
modelar como tabela de junção `guardian_resident`, mesmo que o fluxo atual
do app (`add_guardian_screen`) só crie um par Guardian+Resident por vez.

### Resident (idoso)

| Campo         | Tipo                  | Observação                                                                     |
| ------------- | --------------------- | ------------------------------------------------------------------------------- |
| id            | string (PK)           |                                                                                 |
| name          | string                |                                                                                 |
| age           | int                   |                                                                                 |
| healthNotes   | string                | texto livre (condições/observações gerais)                                     |
| clinicId      | string? (FK → Clinic) | **nulo enquanto o idoso não estiver vinculado a nenhuma clínica** — ver abaixo |
| roomNumber    | string?               | só existe depois do vínculo com uma clínica                                    |
| mood          | string?               | humor/temperamento geral — ver enum `ResidentMood` abaixo                       |
| peculiarities | string?               | preferências, manias, gatilhos — texto livre                                    |
| photoPath     | string?               |                                                                                 |

Relações: **N:N com Guardian**, **1:N com HealthRecord**, **N:N com
Activity** (via ActivityParticipant).

> **Autocadastro do responsável (nova feature):** um responsável pode se
> cadastrar sozinho, antes de qualquer contato com uma clínica —
> preenchendo seus próprios dados e os do idoso (saúde, humor,
> peculiaridades, medicamentos), tudo com `clinicId`/`roomNumber` nulos.
> Quando uma clínica aceita o vínculo (fluxo ainda não implementado neste
> repositório — ver "Fora do escopo atual"), ela só precisa preencher
> `clinicId`/`roomNumber` no registro já existente; nenhum dado é
> redigitado. Enquanto o idoso estiver não vinculado:
> - O app do responsável mostra só 2 abas (Clínicas, Perfil) em vez de 3 —
>   não existe "Meus idosos" porque não há para onde navegar ainda.
> - A aba "Clínicas" é uma busca (filtrando as já contatadas, ver
>   `Guardian.contactedClinicIds`); depois do vínculo, vira só as
>   informações da clínica do idoso, sem busca.
> - O menu de Perfil não mostra "Notificações" (não há o que notificar
>   antes do vínculo).
> - A tela de Segurança ganha um atalho para editar os dados do idoso
>   (incluindo medicamentos) — só disponível enquanto não vinculado; depois
>   do vínculo, quem mantém esses dados passa a ser a equipe da clínica.

### Activity (atividade da clínica)

| Campo         | Tipo                  | Observação                                                                |
| ------------- | --------------------- | ------------------------------------------------------------------------- |
| id            | string (PK)           |                                                                           |
| clinicId      | string (FK → Clinic)  |                                                                           |
| type          | string                | ver enum `ActivityType` abaixo — vale virar enum/lookup no backend        |
| title         | string                |                                                                           |
| scheduledTime | datetime              |                                                                           |
| detail        | string?               | complemento livre (ex.: qual fisioterapia, descrição da confraternização) |
| photoPath     | string?               | anexo opcional (ex.: comprovante de medicação)                            |
| participants  | ActivityParticipant[] | ver abaixo                                                                |

Uma atividade é **compartilhada por vários idosos da mesma clínica** (ex.:
"Roda de música" com dois participantes) — não é mais 1 atividade = 1 idoso.

### ActivityParticipant (participação — entidade de junção)

Vínculo entre uma `Activity` e um `Resident`, com status individual de
presença/execução para aquele idoso naquela atividade. No backend deve virar
uma tabela própria (`activity_participant`), não um array embutido.

| Campo        | Tipo                   | Observação                                                                                                                |
| ------------ | ---------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| residentId   | string (FK → Resident) |                                                                                                                           |
| status       | string                 | ver enum `ActivityStatus` abaixo                                                                                          |
| completedAt  | datetime?              | timestamp da última mudança de status (iniciar/concluir/pular) — no backend, um nome mais preciso seria `statusChangedAt` |
| notes        | string?                | motivo de ter sido pulada — visível ao responsável                                                                        |
| registeredBy | string?                | hoje é o **nome** do colaborador em texto livre — no backend deve ser `staffMemberId` (FK)                                |
| rating       | int?                   | nota de 1 a 5 dada pela equipe ao concluir                                                                                |
| comment      | string?                | comentário livre dado ao concluir                                                                                         |

> **Regra de privacidade (RF novo):** `rating` e `comment` são exibidos ao
> responsável — é o feedback sobre como foi a atividade para o idoso. Já
> `registeredBy` **nunca deve ser retornado numa resposta de API consumida
> por um usuário `guardian`**, só é usado internamente por consistência e
> auditoria (quem lançou o quê). Isso precisa ser filtrado no backend (ex.:
> um DTO de saída distinto por papel), não só escondido na UI — o app
> Flutter hoje já esconde o campo na tela para responsável, mas um backend
> real não pode depender só disso.

> **Ações em lote:** iniciar uma `Activity` inicia **todos** os
> participantes ainda não iniciados de uma vez (não é mais um a um). Ao
> concluir/pular, a equipe pode selecionar vários idosos e aplicar a mesma
> nota/comentário ou o mesmo motivo de pulo ao grupo inteiro, ou registrar
> cada um individualmente — ambos os caminhos continuam disponíveis. No
> backend, isso é só N chamadas ao endpoint de conclusão/pulo por
> participante; não precisa de um endpoint de lote dedicado, mas a API
> deve aceitar bem várias chamadas em sequência/paralelo sem exigir estado
> de sessão entre elas.

### Medication (medicamento — prescrição estruturada)

Entidade nova nesta rodada. Antes, "medicação" era só um `Activity` de
título livre (ex.: "Losartana 50mg"); agora existe uma prescrição
estruturada por trás, separada da agenda:

| Campo        | Tipo                   | Observação                                                                                                                                                       |
| ------------ | ---------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id           | string (PK)            |                                                                                                                                                                  |
| residentId   | string (FK → Resident) |                                                                                                                                                                  |
| name         | string                 | nome do medicamento                                                                                                                                              |
| dosage       | string                 | ex.: "50mg" — considerar separar valor + unidade no backend                                                                                                      |
| form         | string                 | ver enum `MedicationForm` abaixo                                                                                                                                 |
| frequency    | string                 | texto livre hoje (ex.: "A cada 8 horas") — candidato a virar estruturado (intervalo em horas + horários fixos) se o app crescer para gerar lembretes automáticos |
| instructions | string?                | cuidados da prescrição (ex.: "tomar em jejum")                                                                                                                   |
| prescribedBy | string?                | médico prescritor — texto livre                                                                                                                                  |
| startDate    | datetime               |                                                                                                                                                                  |
| endDate      | datetime?              | nulo enquanto for tratamento contínuo                                                                                                                            |
| active       | bool                   |                                                                                                                                                                  |

Relação: **1 Medication → N Activity** (cada dose agendada é uma `Activity`
do tipo `medication` que referencia a prescrição via `Activity.medicationId`
— ver campo abaixo). Dado sensível: mesma recomendação de cuidado do
`HealthRecord` (não logar valores em texto claro, considerar criptografia
em repouso).

**Campo novo em `Activity`:** `medicationId` (string?, FK → Medication) —
só preenchido quando `type == 'medication'`; liga a dose agendada à
prescrição estruturada.

> **Cadastro de medicamento durante o cadastro do idoso:** tanto o
> autocadastro do responsável quanto o cadastro pela equipe agora permitem
> adicionar medicamentos antes mesmo de o idoso existir — no app isso é só
> um `MedicationDraft` em memória (mesmos campos de `Medication`, sem
> `id`/`residentId`/`startDate` ainda), persistido como `Medication` de
> verdade assim que o idoso é criado. Não precisa de uma tabela própria no
> backend: é só um detalhe de UX do formulário, resolvido com N chamadas ao
> mesmo endpoint de criação de medicamento logo após criar o idoso.

### HealthRecord (registro de saúde)

| Campo      | Tipo                   | Observação                                                                                                                                         |
| ---------- | ---------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| id         | string (PK)            |                                                                                                                                                    |
| residentId | string (FK → Resident) |                                                                                                                                                    |
| type       | string                 | ex.: "Pressão arterial", "Glicose", "Frequência cardíaca" — texto livre hoje, vale virar enum/lookup                                               |
| value      | string                 | ex.: "130/85 mmHg" — no backend, considerar separar valor numérico + unidade para permitir alertas automáticos (ver `AppNotification.healthAlert`) |
| recordedAt | datetime               |                                                                                                                                                    |
| recordedBy | string                 | hoje é o **nome** do colaborador em texto livre — no backend deve ser `staffMemberId` (FK)                                                         |

### UserFeedback (feedback — RF-009)

Enviado por colaborador **ou** responsável.

| Campo      | Tipo        | Observação                                                          |
| ---------- | ----------- | ------------------------------------------------------------------- |
| id         | string (PK) |                                                                     |
| authorId   | string      | FK polimórfica → StaffMember **ou** Guardian, conforme `authorRole` |
| authorName | string      |                                                                     |
| authorRole | string      | `'staff'` ou `'guardian'`                                           |
| rating     | int         | 1 a 5                                                               |
| message    | string      |                                                                     |
| sentAt     | datetime    |                                                                     |

### AppNotification (notificação — nova feature)

| Campo     | Tipo        | Observação                                                                                                                                                                                                                                                                                                                          |
| --------- | ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id        | string (PK) |                                                                                                                                                                                                                                                                                                                                     |
| type      | string      | ver enum `NotificationType` abaixo                                                                                                                                                                                                                                                                                                  |
| title     | string      |                                                                                                                                                                                                                                                                                                                                     |
| message   | string      |                                                                                                                                                                                                                                                                                                                                     |
| createdAt | datetime    |                                                                                                                                                                                                                                                                                                                                     |
| read      | bool        |                                                                                                                                                                                                                                                                                                                                     |
| audience  | string?     | `'staff'`, `'guardian'` ou `null` (ambos) — **simplificação do mock**; no backend real, `read` é por usuário, então o correto é uma notificação com destinatário explícito (`recipientId`/`recipientRole`) ou uma tabela de junção `notification_recipient (notification_id, user_id, read_at)`, não um campo de audiência genérico |

## Enums a formalizar no backend

- **ActivityType**: `medication`, `meal`, `physicalActivity`,
  `socialGathering`, `vitalSigns`, `hygiene`, `sleep`, `other`
- **ActivityStatus** (por participante): `pending`, `inProgress`,
  `completed`, `late`, `cancelled`, `skipped` — `pending`/`inProgress`/`late`
  são os estados "em aberto" (ainda aceitam ação da equipe)
- **MedicationForm**: `tablet`, `liquid`, `injection`, `cream`, `other`
- **ResidentMood**: `cheerful`, `calm`, `anxious`, `irritable`, `sad`,
  `confused`, `variable`
- **NotificationType**: `medicationOverdue`, `medicationUpcoming`,
  `upcomingEvent`, `healthAlert`, `general`
- **UserRole / ViewerRole**: `staff`, `guardian`

## Features implementadas (o que o backend precisa suportar)

**Autenticação**

- Login separado para staff e guardian (e-mail + senha) e logout.
- Tela de introdução pré-login ("Não conhece o Care Senior?"), explicando o
  app para quem ainda não escolheu se é colaborador ou responsável.
- Autocadastro do responsável (2 passos: seus dados — nome, e-mail, CPF
  **obrigatório**, foto opcional — depois os do idoso já com
  saúde/humor/peculiaridades/medicamentos) — ver nota sobre `Resident`
  acima. Login automático ao concluir.

**Staff (colaborador)** — visão centrada na clínica, não mais idoso a idoso:

- Agenda da clínica (atividades de hoje e amanhã, de todos os idosos).
- Criar atividade vinculando um ou mais idosos da clínica.
- Ciclo de vida da atividade: iniciar todos os participantes de uma vez
  (em vez de um a um) → concluir (com nota de 1 a 5 e comentário, visíveis
  ao responsável) ou pular (com motivo), individualmente ou em lote via
  seleção múltipla, com anexo de foto opcional na conclusão.
- Cadastrar medicamento estruturado (nome, dosagem, via, frequência,
  instruções, prescritor) e consultar os medicamentos ativos de um idoso —
  inclusive já durante o cadastro do idoso (ver `Cadastrar responsável +
  idoso vinculado` abaixo).
- Registrar dados de saúde de um idoso.
- Aba "Clínica" (dados da própria clínica).
- Cadastrar responsável (nome, e-mail, CPF **obrigatório**, foto opcional)
  + idoso vinculado (podendo já cadastrar os medicamentos dele no mesmo
  fluxo).

**Guardian (responsável)**

- Lista dos seus idosos (só quando já tem algum vinculado a uma clínica).
- Busca de clínicas ainda não contatadas + contato via WhatsApp (link
  externo, sem necessidade de endpoint próprio); marca a clínica como
  contatada e a move para uma seção "aguardando confirmação".
- Depois do vínculo, a aba de clínicas some a busca e passa a mostrar só
  as informações da(s) clínica(s) do(s) seu(s) idoso(s).
- Editar os dados do idoso (incluindo medicamentos) enquanto ele não
  estiver vinculado a nenhuma clínica — acessível pela tela de Segurança.

**Detalhe do idoso** (compartilhado, staff edita / guardian só visualiza)

- Aba de atividades (agendar/iniciar/concluir/pular conforme papel, com
  nota e comentário de conclusão visíveis a ambos os papéis — sem
  identificar quem da equipe registrou), aba de saúde (medicamentos +
  registros), aba de dados da clínica.

**Conta (ambos os papéis)**

- Segurança: editar foto, nome e CPF; visualizar a instituição (fixa, no
  caso do staff).
- Notificações (inbox com badge de não lidas), configurações de
  notificação, ajuda/suporte, sobre o app.
- Enviar feedback (RF-009).

## Fora do escopo atual

Itens previstos no documento de especificação original do projeto e que
**não existem** no app hoje (nem estão no roadmap definido): geolocalização
premium, anúncios, assinatura premium, conteúdos educativos (removido
propositalmente por fugir do escopo de acompanhamento na clínica),
lembretes push nativos. Ver o levantamento de requisitos para o histórico
completo dessas decisões.

Cadastro estruturado de medicamento (dosagem, via, frequência, prescritor)
**já foi implementado nesta rodada** — ver entidade `Medication` acima.

**Vínculo de um responsável autocadastrado a uma clínica (lado da
equipe):** decisão explícita de escopo — o modelo de dados já suporta
(basta preencher `clinicId`/`roomNumber` no `Resident` existente), mas a
tela/fluxo para a equipe encontrar e aceitar um responsável que já se
cadastrou e contatou a clínica ainda não existe. Hoje `AddGuardianScreen`
só cobre cadastro manual (responsável walk-in, sem app). Será um requisito
específico a implementar depois.
