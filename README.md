# 🐧 Administração de Usuários, Grupos e Permissões no Linux

**Aluno:** Kauane Paixão Rocha 

---

## 🐳 1. Inicialização e Acesso ao Ambiente

**Subir o container:**
```bash
docker compose up --build
````

**Acessar o container:**

```bash
docker exec -it ubuntu-linux bash
```

-----

## 👥 2. Criação de Usuários

```bash
adduser monica
adduser cebolinha
adduser cascao
adduser magali
```

Se dentro do container o comando `adduser` não existir (imagens muito minimalistas), instale-o em sistemas Debian/Ubuntu com:

```bash
apt update && apt install -y adduser
```


-----

## 📁 3. Criação de Arquivos nas Home Dirs

```bash
touch /home/monica/sansao.txt /home/monica/revista_turma.txt
touch /home/cebolinha/planos_infaliveis.txt /home/cebolinha/desenhos.txt
touch /home/cascao/camisas_favoritas.txt /home/cascao/mapa_do_bairro.txt
touch /home/magali/receitas_secreta.txt /home/magali/cardapio_semanal.txt
```

-----

## 🏷️ 4. Ajuste de Propriedade dos Arquivos (Usuário e Grupo)

Garante que os arquivos pertençam aos seus criadores inicialmente.

```bash
chown monica:monica /home/monica/sansao.txt /home/monica/revista_turma.txt
chown cebolinha:cebolinha /home/cebolinha/planos_infaliveis.txt /home/cebolinha/desenhos.txt
chown cascao:cascao /home/cascao/camisas_favoritas.txt /home/cascao/mapa_do_bairro.txt
chown magali:magali /home/magali/receitas_secreta.txt /home/magali/cardapio_semanal.txt
```

-----

## 👨‍👩‍👧‍👦 5. Criação do Grupo e Adição dos Usuários

**Grupo:** `grupo_bairro_do_limoeiro`

**Criar grupo:**

```bash
groupadd grupo_bairro_do_limoeiro
```

**Incluir usuários no grupo:**

```bash
usermod -aG grupo_bairro_do_limoeiro monica
usermod -aG grupo_bairro_do_limoeiro cebolinha
usermod -aG grupo_bairro_do_limoeiro cascao
usermod -aG grupo_bairro_do_limoeiro magali
```

-----

## 🧷 6. Alteração do Grupo Proprietário dos Arquivos Selecionados

Define o grupo `grupo_bairro_do_limoeiro` como proprietário secundário de arquivos específicos.

```bash
chown :grupo_bairro_do_limoeiro /home/monica/revista_turma.txt
chown :grupo_bairro_do_limoeiro /home/cebolinha/desenhos.txt
chown :grupo_bairro_do_limoeiro /home/cascao/mapa_do_bairro.txt
chown :grupo_bairro_do_limoeiro /home/magali/cardapio_semanal.txt
```

-----

## 🔐 7. Definição de Permissões de Leitura para o Grupo

Permissão `644`: Dono (RW), Grupo (R), Outros (R).

```bash
chmod 644 /home/monica/revista_turma.txt
chmod 644 /home/cebolinha/desenhos.txt
chmod 644 /home/cascao/mapa_do_bairro.txt
chmod 644 /home/magali/cardapio_semanal.txt
```

-----

## 🔍 8. Verificação Final das Permissões

Listar os arquivos para confirmar as alterações de propriedade e permissão.

```bash
ls -l /home/monica/sansao.txt
ls -l /home/monica/revista_turma.txt
ls -l /home/cebolinha/planos_infaliveis.txt
ls -l /home/cebolinha/desenhos.txt
ls -l /home/cascao/camisas_favoritas.txt
ls -l /home/cascao/mapa_do_bairro.txt
ls -l /home/magali/receitas_secreta.txt
ls -l /home/magali/cardapio_semanal.txt
```

