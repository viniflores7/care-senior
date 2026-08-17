# Care Senior

Aplicativo de acompanhamento de idosos em clínicas/instituições de longa
permanência, conectando a **equipe da clínica** (colaboradores) e os
**responsáveis** (familiares) de cada idoso.

Este repositório contém apenas o **app Flutter** (protótipo funcional com
dados mockados, sem backend real). Este README documenta as entidades,
relações e features implementadas no app para orientar a construção do
backend em **Node.js + NestJS** — que serve **dois clientes sobre a mesma
base de dados**: este app mobile (Flutter, colaborador + responsável) e um
**web app administrativo** (React, exclusivo pra colaboradores — ver seção
própria abaixo). O web app ainda não tem código neste repositório; existe
como protótipo estático de referência visual/estrutural em
`prototipo-care-senior.html`, na raiz deste repositório.

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
  **Todo colaborador tem acesso ao web app administrativo** (ver seção
  "Web app administrativo" abaixo), independente do `StaffRole` — o que
  varia por cargo é quais **ações** ficam disponíveis dentro dele (ver
  `StaffRole` abaixo), não o login em si.
- **Guardian (responsável)** — familiar de um ou mais idosos
  (`role: 'guardian'`). Acompanha em modo leitura. Sem acesso ao web app —
  só ao app mobile.

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
**1 Clinic → N Activity**, **1 Clinic → N Room**.

### Room (quarto) — usado pelo web app

Hoje o app mobile só guarda `Resident.roomNumber` como texto solto — não
existe conceito de quarto vago, andar/ala ou histórico de ocupação. Isso é
suficiente pro mobile (só exibe/edita o número), mas a tela "Quartos" do
web app (troca de quarto, mapa de ocupação por andar) precisa de um
inventário real de quartos por clínica. Entidade nova, **sem
equivalente no app mobile — só existe pro backend/web app**.

| Campo    | Tipo                 | Observação                                                                                              |
| -------- | -------------------- | ------------------------------------------------------------------------------------------------------- |
| id       | string (PK)          |                                                                                                         |
| clinicId | string (FK → Clinic) |                                                                                                         |
| number   | string               | ex.: "12B" — mesmo valor hoje solto em `Resident.roomNumber`                                            |
| floor    | string               | ex.: "Térreo", "1º andar" — texto livre, sem enum fixo                                                  |
| wing     | string?              | ex.: "Ala A" — opcional, nem toda clínica organiza por ala                                              |
| capacity | int                  | quantos idosos cabem no quarto — hoje sempre 1 no mock, mas modelado pra suportar quarto duplo/coletivo |

Relação: **1 Room → N Resident** (0 ou mais, respeitando `capacity`).
`Resident.roomNumber` continua existindo como está no app mobile (texto
livre, sem FK) — no backend real, o valor certo é resolvê-lo a partir de
`Resident.roomId → Room.number`, mantendo `roomNumber` só como um campo
derivado/de leitura pra não quebrar o contrato que o mobile já espera. Um
quarto está **vago** quando nenhum `Resident` ativo aponta pra ele —
não é um campo armazenado, é calculado.

> **Nenhuma mudança no app Flutter é necessária** pra essa entidade — ela
> só importa pro backend e pro web app. O mobile continua enxergando
> `roomNumber` como uma string, exatamente como hoje.

### StaffMember (colaborador)

| Campo     | Tipo                 | Observação                                                                              |
| --------- | -------------------- | --------------------------------------------------------------------------------------- |
| id        | string (PK)          |                                                                                         |
| name      | string               |                                                                                         |
| email     | string               | login                                                                                   |
| role      | string               | ver enum `StaffRole` abaixo — define permissões administrativas, não só o cargo exibido |
| clinicId  | string (FK → Clinic) | colaborador pertence a **uma única** clínica                                            |
| photoPath | string?              |                                                                                         |
| cpf       | string?              | dado sensível — **deve ser criptografado em repouso no backend**                        |

### Guardian (responsável)

| Campo              | Tipo        | Observação                                                                                                                                      |
| ------------------ | ----------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| id                 | string (PK) |                                                                                                                                                 |
| name               | string      |                                                                                                                                                 |
| email              | string      | login                                                                                                                                           |
| residentIds        | string[]    | idosos sob sua responsabilidade                                                                                                                 |
| photoPath          | string?     | opcional — pode ser definida/alterada em qualquer cadastro (autocadastro, cadastro pela equipe ou depois em Segurança)                          |
| cpf                | string      | **obrigatório em todo cadastro de responsável** (autocadastro ou pela equipe) — dado sensível, **deve ser criptografado em repouso no backend** |
| contactedClinicIds | string[]    | clínicas que o responsável já contatou enquanto não tem nenhum idoso vinculado — ver seção de autocadastro abaixo                               |

Relação real: **Guardian ↔ Resident é N:N** (um responsável pode acompanhar
mais de um idoso, inclusive em clínicas diferentes; um idoso pode ter mais
de um responsável cadastrado, ex.: cônjuge + filho) — modelar como tabela
de junção `guardian_resident`. A equipe adiciona um segundo (ou terceiro)
responsável a um idoso já existente pela tela de detalhe do idoso
(`ResidentClinicTab` → "Adicionar responsável"), que reaproveita o mesmo
cadastro de `AddGuardianScreen` só escondendo os campos do idoso quando ele
já existe.

### Resident (idoso)

| Campo                 | Tipo                  | Observação                                                                     |
| --------------------- | --------------------- | ------------------------------------------------------------------------------ |
| id                    | string (PK)           |                                                                                |
| name                  | string                |                                                                                |
| age                   | int                   |                                                                                |
| healthNotes           | string                | texto livre (condições/observações gerais)                                     |
| clinicId              | string? (FK → Clinic) | **nulo enquanto o idoso não estiver vinculado a nenhuma clínica** — ver abaixo |
| roomNumber            | string?               | só existe depois do vínculo com uma clínica                                    |
| mood                  | string?               | humor/temperamento geral — ver enum `ResidentMood` abaixo                      |
| peculiarities         | string?               | preferências, manias, gatilhos — texto livre                                   |
| photoPath             | string?               |                                                                                |
| emergencyContactName  | string?               | quem a equipe deve acionar em uma emergência — nome livre                      |
| emergencyContactPhone | string?               | telefone livre, sem máscara fixa no app                                        |

Relações: **N:N com Guardian**, **1:N com HealthRecord**, **N:N com
Activity** (via ActivityParticipant), **1:N com OutingRequest**.

> **Desvinculação/alta:** a equipe pode desvincular um idoso da clínica
> (`ResidentClinicTab` → "Desvincular idoso da clínica", restrito a
> coordenadoras/enfermeiras — ver `StaffRole` abaixo) a qualquer momento,
> por alta, transferência para outra instituição ou correção de cadastro.
> A ação zera `clinicId`/`roomNumber`, voltando o idoso pro mesmo estado de
> antes de qualquer vínculo — os responsáveis e todo o histórico (saúde,
> medicamentos, atividades, mensagens) continuam existindo, só a clínica
> some. Fora de escopo: um status explícito (`ativo`/`transferido`/
> `óbito`) que distinga os motivos — hoje é só "vinculado" ou "não
> vinculado".

> **Autocadastro do responsável:** um responsável pode se cadastrar
> sozinho, antes de qualquer contato com uma clínica — preenchendo seus
> próprios dados e os do idoso (saúde, humor, peculiaridades,
> medicamentos), tudo com `clinicId`/`roomNumber` nulos. Quando o
> responsável contata uma clínica (`Guardian.contactedClinicIds`) e a
> equipe aceita o vínculo (`AddGuardianScreen` cobre o cadastro manual
> walk-in; a fila de aceite de quem já se autocadastrou é a tela de
> "Solicitações de vínculo" da equipe — ver Features abaixo), ela só
> precisa preencher `clinicId`/`roomNumber` no registro já existente;
> nenhum dado é redigitado. Enquanto o idoso estiver não vinculado:
>
> - O app do responsável mostra só 2 abas (Clínicas, Perfil) em vez de 4 —
>   não existem "Meus idosos"/"Saídas" porque não há para onde navegar
>   ainda.
> - A aba "Clínicas" é uma busca (filtrando as já contatadas, ver
>   `Guardian.contactedClinicIds`); depois do vínculo, vira só as
>   informações da clínica do idoso, sem busca.
> - A tela de Segurança ganha um atalho para editar os dados do idoso
>   (incluindo medicamentos) — só disponível enquanto não vinculado; depois
>   do vínculo, quem mantém esses dados passa a ser a equipe da clínica,
>   pelo ícone de editar na aba de saúde do detalhe do idoso (mesma tela,
>   `EditResidentScreen`, só muda o ponto de entrada).

### OutingRequest (solicitação de saída)

Pedido do responsável pra levar o idoso pra passar um período fora da
clínica (ex.: final de semana em família) — precisa de aprovação da equipe
antes de valer. Entidade nova nesta rodada.

| Campo           | Tipo                   | Observação                                                                           |
| --------------- | ---------------------- | ------------------------------------------------------------------------------------ |
| id              | string (PK)            |                                                                                      |
| residentId      | string (FK → Resident) |                                                                                      |
| guardianId      | string (FK → Guardian) | quem solicitou                                                                       |
| departureAt     | datetime               | horário de saída                                                                     |
| returnAt        | datetime               | horário de chegada/retorno previsto                                                  |
| notes           | string?                | informações extras (destino, medicação a levar, contato de emergência) — texto livre |
| status          | string                 | ver enum `OutingRequestStatus` abaixo                                                |
| createdAt       | datetime               |                                                                                      |
| respondedAt     | datetime?              | quando a equipe aprovou/recusou — nulo enquanto `pending`                            |
| rejectionReason | string?                | só preenchido quando `status == 'rejected'` — visível ao responsável                 |

Relação: **N:1 com Resident**, **N:1 com Guardian**. Um idoso pode ter
várias solicitações ao longo do tempo (histórico).

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

### Routine (rotina recorrente) — usado pelo web app

O app mobile só agenda `Activity` pontuais, uma de cada vez. A tela
"Agenda & Rotinas" do web app introduz uma camada acima disso: uma regra
de recorrência que **gera** as atividades automaticamente (ex.: "aferição
de pressão, todo dia às 7h, pra todos os idosos"), em vez da equipe
recriar a mesma atividade manualmente todo dia. Entidade nova, **sem
equivalente no app mobile — só existe pro backend/web app**.

| Campo        | Tipo                 | Observação                                                                                       |
| ------------ | -------------------- | ------------------------------------------------------------------------------------------------ |
| id           | string (PK)          |                                                                                                  |
| clinicId     | string (FK → Clinic) |                                                                                                  |
| title        | string               | ex.: "Aferição de pressão"                                                                       |
| activityType | string               | reaproveita o enum `ActivityType` já existente (medicação, refeição, sinais vitais etc.)         |
| time         | string               | horário fixo no dia, ex.: "07:00"                                                                |
| weekdays     | string[]             | dias da semana em que a rotina roda — ex.: `['mon','tue','wed','thu','fri','sat','sun']`         |
| scope        | string               | ver enum `RoutineScope` abaixo — a quem a rotina se aplica                                       |
| residentIds  | string[]?            | preenchido só quando `scope == 'specificResidents'`                                              |
| roomIds      | string[]?            | preenchido só quando `scope == 'specificRoom'`                                                   |
| instructions | string?              | complemento livre repassado pra cada `Activity` gerada (ex.: "registrar sistólica e diastólica") |
| active       | bool                 | pausar uma rotina não apaga o histórico, só para de gerar novas atividades                       |

Relação: **1 Routine → N Activity** (cada disparo da recorrência cria uma
`Activity` normal, do mesmo jeito que a equipe criaria manualmente — a
rotina não é uma tabela paralela de agenda, é só o gerador). No backend,
isso é um job agendado (cron) que roda diariamente, olha as rotinas
`active` daquele dia da semana e cria as `Activity`/`ActivityParticipant`
correspondentes — não precisa de lógica nova de exibição, a agenda do
mobile e do web continuam lendo só `Activity`.

> **Nenhuma mudança no app Flutter é necessária** pra essa entidade — o
> mobile só vê o resultado (mais atividades na agenda), nunca a rotina em
> si. Só o web app cria/edita/pausa rotinas.

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

### Message (recado sobre um idoso)

Recado pontual entre a equipe da clínica e o responsável sobre um idoso
específico (ex.: "vou chegar atrasado na visita") — não é um chat em tempo
real, só uma lista simples exibida na aba "Mensagens" do detalhe do idoso.
Entidade nova nesta rodada.

| Campo      | Tipo                   | Observação                                                            |
| ---------- | ---------------------- | --------------------------------------------------------------------- |
| id         | string (PK)            |                                                                       |
| residentId | string (FK → Resident) | ancora a conversa no idoso, mesmo padrão de `Activity`/`HealthRecord` |
| senderRole | string                 | `'staff'` ou `'guardian'` — ver `ViewerRole`                          |
| senderName | string                 | texto livre, mesmo padrão de `recordedBy`/`registeredBy`              |
| text       | string                 |                                                                       |
| sentAt     | datetime               |                                                                       |

Relação: **N:1 com Resident**. Fora de escopo por ora: anexos, grupos,
tempo real (WebSocket/push) e indicador de lida — o app só recarrega a
lista ao entrar na tela, como o resto do app.

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
- **OutingRequestStatus**: `pending`, `approved`, `rejected`
- **RoutineScope** (web app): `allResidents`, `specificResidents`,
  `specificRoom`
- **StaffRole**: `Coordenadora`, `Enfermeira`, `Cuidador` — todo
  colaborador tem login no web app; só coordenadoras e enfermeiras
  aprovam/recusam solicitações (vínculo, saída) e desvinculam idosos;
  qualquer colaborador cadastra responsável e usa a agenda/rotinas
- **UserRole / ViewerRole**: `staff`, `guardian`

## Features implementadas (o que o backend precisa suportar)

**Autenticação**

- Login separado para staff e guardian (e-mail + senha) e logout.
- Tela de introdução pré-login ("Não conhece o Care Senior?"), explicando o
  app para quem ainda não escolheu se é colaborador ou responsável.
- Autocadastro do responsável (2 passos: seus dados — nome, e-mail, CPF
  **obrigatório**, foto opcional — depois os do idoso já com
  saúde/humor/peculiaridades/**contato de emergência**/medicamentos) — ver
  nota sobre `Resident` acima. Login automático ao concluir.

**Staff (colaborador)** — visão centrada na clínica, não mais idoso a idoso:

- Lista dos idosos da clínica (aba "Clínica") — cada um abre o perfil
  completo (`ResidentDetailScreen`): agenda, saúde, responsáveis e
  mensagens.
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
  e idoso vinculado (podendo já cadastrar contato de emergência e os
  medicamentos dele no mesmo fluxo).
- **Múltiplos responsáveis por idoso:** qualquer colaborador pode adicionar
  mais um responsável a um idoso já vinculado (`ResidentClinicTab` →
  "Adicionar responsável") — reaproveita o cadastro de `AddGuardianScreen`
  sem os campos do idoso, já que ele já existe. A aba também lista todos
  os responsáveis cadastrados daquele idoso.
- **Desvinculação/alta do idoso** (só coordenadoras/enfermeiras — ver
  `StaffRole`): remove o idoso da clínica (`clinicId`/`roomNumber` voltam a
  `null`), com confirmação explícita; o idoso permanece com seu histórico
  e responsáveis, só sem clínica.
- **Solicitações de vínculo** (só coordenadoras/enfermeiras): fila de
  responsáveis autocadastrados que já contataram a clínica
  (`Guardian.contactedClinicIds`) e ainda têm idoso(s) sem `clinicId` — com
  busca por responsável ou idoso. Revisar mostra os dados do responsável e
  o perfil de cuidado já preenchido do idoso
  (saúde/humor/peculiaridades/contato de emergência/medicamentos); aceitar
  só pede o número do quarto e preenche `clinicId`/`roomNumber` no
  `Resident` já existente, sem redigitar nada.
- **Solicitações de saída** (só coordenadoras/enfermeiras): fila de pedidos
  de saída (ver `OutingRequest`) dos idosos da clínica aguardando
  aprovação, com busca por idoso ou responsável; aprovar ou recusar
  (recusa exige motivo, visível ao responsável).

**Guardian (responsável)**

- Lista dos seus idosos (só quando já tem algum vinculado a uma clínica) —
  agrupada por clínica quando o responsável tem idosos em mais de uma.
- Busca de clínicas ainda não contatadas + contato via WhatsApp (link
  externo, sem necessidade de endpoint próprio); marca a clínica como
  contatada e a move para uma seção "aguardando confirmação".
- Depois do vínculo, a aba de clínicas some a busca e passa a mostrar só
  as informações da(s) clínica(s) do(s) seu(s) idoso(s) — indicando quais
  idosos estão em cada uma quando há mais de uma clínica envolvida.
- Editar os dados do idoso (incluindo medicamentos e contato de
  emergência) enquanto ele não estiver vinculado a nenhuma clínica —
  acessível pela tela de Segurança.
- **Solicitar saída** de um idoso vinculado (aba "Saídas"): informa
  horário de saída, horário de chegada previsto e informações extras
  (destino, medicação a levar, contato de emergência etc.), escolhendo o
  idoso quando tem mais de um. Acompanha o status de cada solicitação
  (pendente/aprovada/recusada), com o motivo visível quando recusada.

**Detalhe do idoso** (compartilhado, staff edita / guardian só visualiza)

- Aba de atividades (agendar/iniciar/concluir/pular conforme papel, com
  nota e comentário de conclusão visíveis a ambos os papéis — sem
  identificar quem da equipe registrou), aba de saúde (medicamentos +
  registros + perfil do idoso editável pela equipe — ver abaixo), aba de
  dados da clínica (mostra também os responsáveis cadastrados; só a
  equipe adiciona um novo ou desvincula o idoso).
- **Editar perfil do idoso** (só a equipe, ícone de lápis na aba de saúde):
  nome, idade, foto, notas de saúde, humor, peculiaridades e contato de
  emergência — mesma tela (`EditResidentScreen`) que o responsável usa
  antes do vínculo, sem distinção de papel no código; só muda por onde se
  chega até ela.
- Aba de mensagens: recados pontuais entre equipe e responsável sobre este
  idoso (ver `Message`), com envio pelos dois papéis.

**Conta (ambos os papéis)**

- Segurança: editar foto, nome e CPF; visualizar a instituição (fixa, no
  caso do staff).
- Notificações (inbox com badge de não lidas), ajuda/suporte, sobre o app.
- Enviar feedback (RF-009).

## Web app administrativo (React) — novo, protótipo em `prototipo-care-senior.html`

Cliente novo sobre a **mesma base de dados/API** do app mobile —
**exclusivo pra colaboradores** (nenhum acesso de responsável). Cobre o
trabalho de escritório/gestão que não faz sentido em tela de celular;
o app mobile continua sendo o app de campo/beira-leito. Sem código real
ainda — o protótipo estático (HTML/CSS/JS, sem framework) na raiz do
repositório é a referência visual e estrutural pra implementação em React.

- **Acesso:** todo `StaffMember`, de qualquer `StaffRole`, pode logar —
  não é restrito a Coordenadora/Enfermeira. O que muda por cargo são as
  **ações** dentro do painel, reaproveitando exatamente a mesma regra que
  já vale no mobile (`StaffRole.canManageRequests` — ver `Resident` e
  `StaffRole` acima): Cuidador não vê/usa as filas de Solicitações nem
  desvincula idoso; qualquer colaborador cadastra responsável, mexe na
  agenda e nas rotinas.
- **Uma clínica por colaborador — decidido:** `StaffMember.clinicId`
  continua **N:1** com `Clinic` (vários colaboradores, uma única clínica
  cada) — sem seletor de clínica. A primeira versão do protótipo tinha um
  seletor no canto superior esquerdo sugerindo múltiplas clínicas por
  colaborador; foi removido do protótipo pra não sugerir um requisito que
  não existe. O cabeçalho do web app mostra o nome da clínica do
  colaborador logado, fixo.
- **Dashboard:** KPIs da clínica (idosos ativos, colaboradores, ocupação
  de quartos, solicitações pendentes), agenda do dia, fila de
  solicitações pendentes, distribuição de atividades por tipo, adesão a
  medicação.
- **Colaboradores:** cadastro, edição e cargo (`StaffRole`) — fecha a
  lacuna que ficava "fora de escopo" nas rodadas anteriores (colaboradores
  só existiam via seed/mock).
- **Idosos:** listagem e perfil completo por idoso (mesmos dados do
  detalhe do mobile), incluindo trocar de quarto e desvincular — sem
  duplicar a lógica, só reaproveitando os mesmos endpoints do mobile.
- **Quartos:** inventário por clínica (ver `Room` acima), mapa de
  ocupação por andar/ala, troca de quarto.
- **Agenda & Rotinas:** visão semanal das `Activity` da clínica +
  gerenciamento de `Routine` (ver acima) — criar, editar, pausar/retomar.
- **Solicitações:** as mesmas filas de vínculo e saída do mobile
  (`PendingLinkRequest`, `OutingRequest`), numa visão de mesa mais rica
  (tabela com busca, em vez de lista de cartões).
- **Relatórios:** adesão a medicação, conclusão de atividades por status,
  feedback recebido (`UserFeedback`), ocupação ao longo do tempo — todos
  agregações sobre entidades que já existem, nenhuma tabela nova de
  "relatório" precisa ser persistida.
- **Clínica:** edição dos dados institucionais do `Clinic` (endereço,
  horário, atividades oferecidas, responsável técnico) — hoje só leitura
  no mobile.

## Fora do escopo atual

Itens previstos no documento de especificação original do projeto e que
**não existem** no app hoje (nem estão no roadmap definido): geolocalização
premium, anúncios, assinatura premium, conteúdos educativos (removido
propositalmente por fugir do escopo de acompanhamento na clínica),
lembretes push nativos. Ver o levantamento de requisitos para o histórico
completo dessas decisões.

Cadastro estruturado de medicamento (dosagem, via, frequência, prescritor)
**já foi implementado nesta rodada** — ver entidade `Medication` acima.

Vínculo de um responsável autocadastrado a uma clínica (tela da equipe
pra buscar, revisar e aceitar, preenchendo `clinicId`/`roomNumber` no
`Resident` existente) **já foi implementado** — ver "Solicitações de
vínculo" em Features acima.

Solicitação de saída do idoso, com aprovação/recusa da equipe,
**já foi implementada nesta rodada** — ver entidade `OutingRequest` e
"Solicitações de saída"/"Solicitar saída" em Features acima. Fora do
escopo por ora: cancelamento de uma solicitação já enviada pelo
responsável e registro de que o idoso efetivamente saiu/retornou (o app
só controla o ciclo de aprovação, não o checkpoint físico de saída).

Múltiplos responsáveis por idoso, desvinculação/alta do idoso, contatos de
emergência estruturados e papéis/permissões da equipe (`StaffRole`)
**já foram implementados nesta rodada** — ver `Resident`, `StaffRole` e as
respectivas entradas em Features acima. Fora do escopo por ora:
granularidade de permissão por ação individual (hoje é só um booleano
"gerencia solicitações" por cargo), e gestão completa do responsável
(remover um responsável de um idoso, ou um idoso de um responsável, sem
apagar o histórico).

Cadastro/edição de colaboradores pelo próprio app **passa a ter escopo
definido nesta rodada** — ver "Web app administrativo" acima — mas
**ainda não tem código**, nem no app mobile nem em backend: existe só como
protótipo estático (`prototipo-care-senior.html`) e como especificação
neste README. Continua fora do app mobile (não é o cliente certo pra essa
tarefa).

Duas entidades novas foram especificadas nesta rodada só pra viabilizar o
web app — `Room` (quarto como inventário de verdade, não só uma string em
`Resident.roomNumber`) e `Routine` (rotina recorrente que gera `Activity`
automaticamente) — ver as seções correspondentes acima.
**Nenhuma delas exige mudança no app Flutter**: o mobile continua
funcionando exatamente como hoje, só o backend/web app precisam delas.

## API REST (NestJS) — mapeamento de endpoints

Endpoints necessários pra atender **os dois clientes** (mobile + web)
sobre a mesma API. "Cliente" na última coluna indica quem consome cada
rota hoje — não é uma restrição técnica, só ajuda a saber o que quebra se
o contrato mudar.

**Convenções gerais** (padrão NestJS):

- Prefixo de versão: `/api/v1/...`.
- Recursos no plural, kebab-case (`/outing-requests`, não
  `/outingRequest`).
- `GET` de lista aceita filtro via query string (`?clinicId=`,
  `?residentId=`, `?status=`, `?from=&to=`) — nunca por segmento de rota
  além do primeiro nível de aninhamento.
- Aninhamento de no máximo 1 nível, só quando o sub-recurso não existe
  sozinho fora do pai (`/residents/:id/guardians`); o resto é rota plana
  com filtro.
- `PATCH` pra atualização parcial — nunca `PUT`.
- Ação que não é CRUD puro (aprovar, iniciar, desvincular) vira sub-rota
  verbo no infinitivo: `POST /resource/:id/acao`.
- Toda rota exige `JwtAuthGuard`, exceto `/auth/*`. Rotas restritas por
  cargo usam `@Roles(StaffRole.Coordenadora, StaffRole.Enfermeira)` com um
  `RolesGuard` — a mesma regra hoje aplicada em `StaffRole` no app.
- Entrada/saída tipadas por DTO (`CreateXDto`, `UpdateXDto`,
  `XResponseDto`) com `class-validator`/`class-transformer`. O
  `XResponseDto` de `ActivityParticipant` **não inclui `registeredBy`**
  quando quem pediu é `guardian` — ver regra de privacidade na seção da
  entidade acima.
- Paginação padrão em toda lista (`?page=&limit=`), mesmo que o mock do
  app hoje não pagine nada.

### Auth

| Método | Endpoint                       | Descrição                                                                        | Cliente | Observação                                     |
| ------ | ------------------------------ | -------------------------------------------------------------------------------- | ------- | ---------------------------------------------- |
| POST   | `/auth/staff/login`            | Login de colaborador                                                             | Ambos   |                                                |
| POST   | `/auth/guardian/login`         | Login de responsável                                                             | Mobile  |                                                |
| POST   | `/auth/guardian/register`      | Autocadastro do responsável + idoso (2 passos consolidados)                      | Mobile  | ver `Resident`, autocadastro                   |
| POST   | `/auth/staff/accept-invite`    | Define a senha do colaborador recém-cadastrado (body: `token`, `password`)       | Web     | completa o `POST /staff` — ver nota abaixo     |
| POST   | `/auth/guardian/accept-invite` | Define a senha do responsável cadastrado via walk-in (body: `token`, `password`) | Ambos   | completa o `POST /guardians` — ver nota abaixo |
| POST   | `/auth/logout`                 | Invalida a sessão/token atual                                                    | Ambos   |                                                |

> **De onde vem a senha de quem não se autocadastrou:** `POST /staff` e
> `POST /guardians` (cadastro pela equipe) criam o registro **sem senha**
> — o backend deve gerar um token de convite e disparar e-mail/SMS pra
> quem foi cadastrado definir a própria senha em
> `/auth/*/accept-invite`. Até lá, a conta existe mas não consegue logar.
> Isso não tem equivalente no mock hoje: o app usa uma senha fixa
> (`123456`) pra qualquer usuário, então esse fluxo de convite nunca foi
> exercitado nem pelo mobile nem pelo protótipo web — é um requisito novo
> que só existe pensando no backend real.

### Clinics

| Método | Endpoint       | Descrição                             | Cliente | Observação              |
| ------ | -------------- | ------------------------------------- | ------- | ----------------------- |
| GET    | `/clinics`     | Lista clínicas (busca do responsável) | Mobile  | responsável pré-vínculo |
| GET    | `/clinics/:id` | Detalhe institucional                 | Ambos   |                         |
| PATCH  | `/clinics/:id` | Editar dados institucionais           | Web     | tela "Clínica"          |

### Staff

| Método | Endpoint     | Descrição                                 | Cliente | Observação                                     |
| ------ | ------------ | ----------------------------------------- | ------- | ---------------------------------------------- |
| GET    | `/staff`     | Lista colaboradores (`?clinicId=`)        | Web     | tela "Colaboradores"                           |
| POST   | `/staff`     | Cadastrar colaborador                     | Web     | fecha a lacuna de cadastro só-por-seed         |
| GET    | `/staff/me`  | Perfil do colaborador logado              | Ambos   |                                                |
| GET    | `/staff/:id` | Detalhe                                   | Web     |                                                |
| PATCH  | `/staff/me`  | Editar o próprio perfil (nome, cpf, foto) | Mobile  | tela Segurança                                 |
| PATCH  | `/staff/:id` | Editar colaborador (inclui `role`)        | Web     |                                                |
| DELETE | `/staff/:id` | Desativar colaborador                     | Web     | soft delete — nunca apagar linha com histórico |

### Guardians

| Método | Endpoint                           | Descrição                                    | Cliente | Observação                              |
| ------ | ---------------------------------- | -------------------------------------------- | ------- | --------------------------------------- |
| POST   | `/guardians`                       | Cadastro walk-in (responsável + idoso)       | Ambos   | `AddGuardianScreen` / modal web         |
| GET    | `/guardians/:id`                   | Detalhe                                      | Ambos   |                                         |
| PATCH  | `/guardians/me`                    | Editar o próprio perfil                      | Mobile  | tela Segurança                          |
| PATCH  | `/guardians/:id`                   | Editar responsável (uso administrativo)      | Web     |                                         |
| POST   | `/guardians/:id/contact-clinic`    | Marcar clínica como contatada (`?clinicId=`) | Mobile  | busca de clínicas pré-vínculo           |
| GET    | `/guardians/pending-link-requests` | Fila de vínculo pendente (`?clinicId=`)      | Ambos   | `PendingLinkRequest` — não é persistida |

### Residents

| Método | Endpoint                               | Descrição                                                           | Cliente | Observação                                       |
| ------ | -------------------------------------- | ------------------------------------------------------------------- | ------- | ------------------------------------------------ |
| GET    | `/residents`                           | Lista (`?clinicId=`, `?guardianId=`)                                | Ambos   |                                                  |
| GET    | `/residents/:id`                       | Detalhe                                                             | Ambos   |                                                  |
| PATCH  | `/residents/:id`                       | Editar perfil (saúde, humor, peculiaridades, contato de emergência) | Ambos   | pré-vínculo (mobile) ou pós-vínculo (mobile/web) |
| POST   | `/residents/:id/link`                  | Aceitar vínculo — preenche `clinicId`/`roomId`                      | Ambos   | fila de Solicitações de vínculo, `@Roles`        |
| POST   | `/residents/:id/discharge`             | Desvincular/dar alta                                                | Ambos   | `@Roles(Coordenadora, Enfermeira)`               |
| POST   | `/residents/:id/change-room`           | Trocar de quarto (`roomId` no body)                                 | Web     | tela "Quartos" / detalhe do idoso                |
| GET    | `/residents/:id/guardians`             | Responsáveis do idoso                                               | Ambos   |                                                  |
| POST   | `/residents/:id/guardians`             | Adicionar mais um responsável                                       | Ambos   | múltiplos responsáveis                           |
| DELETE | `/residents/:id/guardians/:guardianId` | Remover um responsável específico                                   | —       | **planejado** — item em aberto, sem tela ainda   |

### Rooms (novo)

| Método | Endpoint     | Descrição                                         | Cliente | Observação     |
| ------ | ------------ | ------------------------------------------------- | ------- | -------------- |
| GET    | `/rooms`     | Lista (`?clinicId=`, `?status=vacant\|occupied`)  | Web     | tela "Quartos" |
| POST   | `/rooms`     | Cadastrar quarto (número, andar, ala, capacidade) | Web     |                |
| GET    | `/rooms/:id` | Detalhe                                           | Web     |                |
| PATCH  | `/rooms/:id` | Editar quarto                                     | Web     |                |

### Activities

| Método | Endpoint                                            | Descrição                                                     | Cliente | Observação          |
| ------ | --------------------------------------------------- | ------------------------------------------------------------- | ------- | ------------------- |
| GET    | `/activities`                                       | Lista (`?clinicId=`, `?residentId=`, `?from=&to=`)            | Ambos   |                     |
| POST   | `/activities`                                       | Agendar atividade (um ou mais idosos)                         | Ambos   |                     |
| GET    | `/activities/:id`                                   | Detalhe + participantes                                       | Ambos   |                     |
| PATCH  | `/activities/:id`                                   | Editar atividade ainda não iniciada                           | Ambos   |                     |
| POST   | `/activities/:id/start-all`                         | Inicia todos os participantes ainda não iniciados             | Mobile  |                     |
| POST   | `/activities/:id/participants/:residentId/complete` | Concluir participante (body: `rating`, `comment`)             | Mobile  |                     |
| POST   | `/activities/:id/participants/:residentId/skip`     | Pular participante (body: `reason`)                           | Mobile  |                     |
| POST   | `/activities/:id/complete-batch`                    | Concluir em lote (body: `residentIds[]`, `rating`, `comment`) | Mobile  | "Selecionar vários" |
| POST   | `/activities/:id/skip-batch`                        | Pular em lote (body: `residentIds[]`, `reason`)               | Mobile  |                     |

### Routines (novo)

| Método | Endpoint               | Descrição                                        | Cliente | Observação              |
| ------ | ---------------------- | ------------------------------------------------ | ------- | ----------------------- |
| GET    | `/routines`            | Lista (`?clinicId=`)                             | Web     | tela "Agenda & Rotinas" |
| POST   | `/routines`            | Criar rotina recorrente                          | Web     |                         |
| GET    | `/routines/:id`        | Detalhe                                          | Web     |                         |
| PATCH  | `/routines/:id`        | Editar (dias, horário, escopo, instruções)       | Web     |                         |
| PATCH  | `/routines/:id/toggle` | Ativar/pausar                                    | Web     |                         |
| DELETE | `/routines/:id`        | Remover rotina (não apaga `Activity` já geradas) | Web     |                         |

### Medications

| Método | Endpoint                      | Descrição                            | Cliente | Observação                                  |
| ------ | ----------------------------- | ------------------------------------ | ------- | ------------------------------------------- |
| GET    | `/medications`                | Lista (`?residentId=`, `?clinicId=`) | Ambos   |                                             |
| POST   | `/medications`                | Cadastrar prescrição                 | Ambos   |                                             |
| PATCH  | `/medications/:id`            | Editar prescrição                    | Ambos   |                                             |
| PATCH  | `/medications/:id/deactivate` | Encerrar tratamento                  | Ambos   | preferir isso a `DELETE` — mantém histórico |

### Health records

| Método | Endpoint          | Descrição                            | Cliente | Observação |
| ------ | ----------------- | ------------------------------------ | ------- | ---------- |
| GET    | `/health-records` | Lista (`?residentId=`, `?clinicId=`) | Ambos   |            |
| POST   | `/health-records` | Registrar dado de saúde              | Mobile  |            |

### Outing requests

| Método | Endpoint                       | Descrição                                        | Cliente | Observação                         |
| ------ | ------------------------------ | ------------------------------------------------ | ------- | ---------------------------------- |
| GET    | `/outing-requests`             | Lista (`?residentId=`, `?clinicId=`, `?status=`) | Ambos   |                                    |
| POST   | `/outing-requests`             | Criar solicitação                                | Mobile  |                                    |
| GET    | `/outing-requests/:id`         | Detalhe                                          | Ambos   |                                    |
| POST   | `/outing-requests/:id/approve` | Aprovar                                          | Ambos   | `@Roles(Coordenadora, Enfermeira)` |
| POST   | `/outing-requests/:id/reject`  | Recusar (body: `reason`)                         | Ambos   | `@Roles(Coordenadora, Enfermeira)` |
| DELETE | `/outing-requests/:id`         | Cancelar solicitação ainda pendente              | —       | **planejado** — item em aberto     |

### Messages

| Método | Endpoint    | Descrição              | Cliente | Observação |
| ------ | ----------- | ---------------------- | ------- | ---------- |
| GET    | `/messages` | Lista (`?residentId=`) | Mobile  |            |
| POST   | `/messages` | Enviar recado          | Mobile  |            |

### Feedback

| Método | Endpoint    | Descrição                | Cliente | Observação        |
| ------ | ----------- | ------------------------ | ------- | ----------------- |
| GET    | `/feedback` | Lista (`?clinicId=`)     | Web     | tela "Relatórios" |
| POST   | `/feedback` | Enviar feedback (RF-009) | Mobile  |                   |

### Notifications

| Método | Endpoint                  | Descrição               | Cliente | Observação |
| ------ | ------------------------- | ----------------------- | ------- | ---------- |
| GET    | `/notifications`          | Lista do usuário logado | Mobile  |            |
| PATCH  | `/notifications/:id/read` | Marcar como lida        | Mobile  |            |
| PATCH  | `/notifications/read-all` | Marcar todas como lidas | Mobile  |            |

### Reports (novo, exclusivo web)

Agregações só de leitura sobre entidades que já existem — nenhuma tabela
de "relatório" precisa ser persistida.

| Método | Endpoint                        | Descrição                                            | Cliente | Observação |
| ------ | ------------------------------- | ---------------------------------------------------- | ------- | ---------- |
| GET    | `/reports/overview`             | KPIs do dashboard (`?clinicId=`)                     | Web     |            |
| GET    | `/reports/activities-by-type`   | Distribuição por `ActivityType` (`?from=&to=`)       | Web     |            |
| GET    | `/reports/medication-adherence` | Série temporal de adesão (`?from=&to=`)              | Web     |            |
| GET    | `/reports/activity-completion`  | % concluída/pulada/atrasada (`?from=&to=`)           | Web     |            |
| GET    | `/reports/occupancy`            | Ocupação de quartos ao longo do tempo (`?from=&to=`) | Web     |            |
| GET    | `/reports/feedback-summary`     | Média e histograma de notas (`?clinicId=`)           | Web     |            |
