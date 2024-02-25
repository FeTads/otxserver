#!/bin/bash

# Configurações do Git
usuario_git="SEU_NICK_DOGITHUB_AQUI"
token_git="SEU_TOKEN_AQUI"
diretorio="/home/otxserver"
log_file="$diretorio/automaticCommit.txt"

# NÃO MEXA daqui pra baixo
# Esse script funciona apenas pra linux, um auto backup a cada 24h pro github das modificações feitas no servidor!

# crontab -e
# 0 0 * * * /home/otxserver/updategit.sh

# se diretório não existir
if [ ! -d "$diretorio" ]; then
    exit 1
fi

cd "$diretorio" || { exit 1; }

# configura temporariamente o nome de usuário e token
git config credential.helper store
git fetch origin main
git checkout main

# atualiza com pull do git pra maquina
git pull origin main

# verifica se tem alterações pra fazer o commit
if git diff-index --quiet HEAD --; then
    echo "Nenhuma alteração para commit." > "$log_file"
    exit 0
fi


# subindo pro git
git add .
git commit -m "Commit automático" > "$log_file" 2>&1

# verifica se o commit foi bem sucedido
if [ $? -ne 0 ]; then
    echo "Erro ao fazer o commit." >> "$log_file"
    exit 1
fi


# configura temporariamente o nome de usuário e token pra subir pro git
git -c credential.helper='!f() { echo "username=${usuario_git}"; echo "password=${token_git}"; }; f' push -u origin main > "$log_file" 2>&1

# verifica se o push foi bem sucedido
if [ $? -ne 0 ]; then
    echo "Erro ao fazer o push." >> "$log_file"
    exit 1
fi

# caso de tudo certo, vai commitar e escrever no log
echo "Commit e push realizados com sucesso em $(date +'%d-%m-%Y-%H-%M')." >> "$log_file"
