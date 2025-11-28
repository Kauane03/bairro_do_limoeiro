#!/usr/bin/env bash
set -euo pipefail

# Este script aplica os passos do README:

if [ "$EUID" -ne 0 ]; then
  echo "Execute este script como root (sudo)." >&2
  exit 1
fi

# Garantir que o comando `adduser` exista; tentar instalar conforme o gerenciador de pacotes
if ! command -v adduser &>/dev/null; then
  echo "adduser não encontrado. Tentando instalar..."
  if command -v apt &>/dev/null; then
    apt update
    apt install -y adduser
  elif command -v apt-get &>/dev/null; then
    apt-get update
    apt-get install -y adduser
  elif command -v apk &>/dev/null; then
    apk add --no-cache shadow
  elif command -v dnf &>/dev/null; then
    dnf install -y passwd
  elif command -v yum &>/dev/null; then
    yum install -y passwd
  elif command -v pacman &>/dev/null; then
    pacman -Sy --noconfirm shadow
  else
    echo "Não foi possível instalar adduser automaticamente. Instale manualmente e execute o script novamente." >&2
    exit 1
  fi
fi

# 1) Criar usuários (não-interativo). Se já existirem, pula.
USERS=(monica cebolinha cascao magali)
for u in "${USERS[@]}"; do
  if id "$u" &>/dev/null; then
    echo "Usuário $u já existe — pulando criação"
  else
    # Usar adduser em modo não-interativo
    adduser --disabled-password --gecos "" "$u" >/dev/null 2>&1 || true
    # Garantir shell padrão
    usermod -s /bin/bash "$u" >/dev/null 2>&1 || true
    echo "Criado usuário: $u"
  fi
done

# 2) Criar arquivos nas home dirs
mkdir -p /home/monica /home/cebolinha /home/cascao /home/magali

touch /home/monica/sansao.txt /home/monica/revista_turma.txt
touch /home/cebolinha/planos_infaliveis.txt /home/cebolinha/desenhos.txt
touch /home/cascao/camisas_favoritas.txt /home/cascao/mapa_do_bairro.txt
touch /home/magali/receitas_secreta.txt /home/magali/cardapio_semanal.txt

# 3) Ajuste de propriedade (usuário:grupo)
chown monica:monica /home/monica/sansao.txt /home/monica/revista_turma.txt
chown cebolinha:cebolinha /home/cebolinha/planos_infaliveis.txt /home/cebolinha/desenhos.txt
chown cascao:cascao /home/cascao/camisas_favoritas.txt /home/cascao/mapa_do_bairro.txt
chown magali:magali /home/magali/receitas_secreta.txt /home/magali/cardapio_semanal.txt

# 4) Criar grupo e adicionar usuários
# -f evita erro se o grupo já existir
groupadd -f grupo_bairro_do_limoeiro
for u in "${USERS[@]}"; do
  usermod -aG grupo_bairro_do_limoeiro "$u" || true
done

# 5) Alteração do grupo proprietário para arquivos selecionados
chown :grupo_bairro_do_limoeiro /home/monica/revista_turma.txt
chown :grupo_bairro_do_limoeiro /home/cebolinha/desenhos.txt
chown :grupo_bairro_do_limoeiro /home/cascao/mapa_do_bairro.txt
chown :grupo_bairro_do_limoeiro /home/magali/cardapio_semanal.txt

# 6) Definição de permissões (644) para os arquivos compartilhados
chmod 644 /home/monica/revista_turma.txt
chmod 644 /home/cebolinha/desenhos.txt
chmod 644 /home/cascao/mapa_do_bairro.txt
chmod 644 /home/magali/cardapio_semanal.txt

# 7) Verificação final
ls -l /home/monica/sansao.txt || true
ls -l /home/monica/revista_turma.txt || true
ls -l /home/cebolinha/planos_infaliveis.txt || true
ls -l /home/cebolinha/desenhos.txt || true
ls -l /home/cascao/camisas_favoritas.txt || true
ls -l /home/cascao/mapa_do_bairro.txt || true
ls -l /home/magali/receitas_secreta.txt || true
ls -l /home/magali/cardapio_semanal.txt || true

echo "Script concluído."
