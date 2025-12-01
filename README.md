# Aplicativo Entregas Dev

Aplicativo desenvolvido em **Flutter** utilizando **Flutter Modular** especialmente para os entregadores, onde é possível visualizar **solicitações de entrega** cadastradas pela loja no **Dashboard Web - Entregas Dev**

---

## Funcionalidades
- **Login** com e-mail e senha usando Firebase Authentication
- **Visualizar entregas disponíveis** criadas no **Dashboard - Entregas Dev**
- **Aceitar entregas disponíveis** onde o entregador poderá confirmar coleta e confirmar entrega do pedido
- **Visualizar entregas finalizadas** juntamente com os **ganhos totais**

---

## Tecnologias Utilizadas
| Componente | Descrição |
|-------------|------------|
| **Dart** | Linguagem principal do projeto |
| **Flutter** | Framework utilizado |
| **Firebase Authentication** | Login de usuários via e-mail/senha |
| **Firebase Database** | Banco de dados utilizado para salvar usuários, solicitações, entregas e lojas |
| **Realtime Database** | Utilizado para verificar o status do entregador, se ele está online/offline, enviando essa informação para o **Dashboard Web - Entregas Dev** onde ele fará a contabilidade total de entregadores com o aplicativo aberto


