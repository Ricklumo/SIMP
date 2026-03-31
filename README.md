# SIMP – Sistema Inteligente de Materiais Pedagógicos

**Sistema de Controle de Itens da Supervisão Pedagógica**

Aplicação desktop e mobile desenvolvida em Flutter para gerenciar o fluxo de materiais pedagógicos (entrada, saída, prazos e devoluções) da Supervisão Pedagógica.

---

## ✨ Funcionalidades

- **Cadastro de itens** com nome, categoria, quantidade, data limite, solicitante e observação
- **Controle de status**: Pendente, Concluído e Atrasado (automático)
- **QR Code** gerado automaticamente para cada item
- **Dashboard** em tempo real com Totais, Atrasados e Pendentes + alerta visual
- **Tela de Itens** com busca, edição, exclusão, marcação como concluído e QR Code
- **Relatórios** completos com histórico e contadores atualizados
- **Exportação para PDF** (relatório completo salvo na pasta Documentos)
- **Design responsivo**:
    - **Desktop**: Sidebar fixa
    - **Mobile**: Drawer (menu lateral deslizante)
- **Banco de dados local** (SQLite) – funciona 100% offline
- **Notificações visuais** de itens atrasados

---

## 🛠 Tecnologias Utilizadas

- **Flutter** (Desktop + Mobile)
- **Provider** (gerenciamento de estado)
- **SQLite** + `sqflite` + `sqflite_common_ffi` (banco local)
- **pdf** + **path_provider** (geração de PDF)
- **qr_flutter** (geração de QR Code)
- Design responsivo com separação de telas Desktop / Mobile

---

## 🚀 Como Executar

1. Clone o repositório ou abra a pasta do projeto
2. Instale as dependências:

```bash
flutter pub get