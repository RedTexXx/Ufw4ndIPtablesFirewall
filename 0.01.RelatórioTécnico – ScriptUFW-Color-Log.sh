📄 Relatório Técnico – Script UFW-Color-Log.sh
📌 Objetivo

O script UFW-Color-Log.sh tem como objetivo:

    Ativar o log completo do firewall UFW.

    Instalar o utilitário ccze para colorização de logs.

    Criar uma função interativa chamada ufw-colorlog no ~/.bashrc, que permite visualizar logs do kernel relacionados ao UFW em tempo real, com destaque em cores para facilitar a análise de segurança.

🔍 Análise do Script
1. Ativação do log completo do UFW

sudo ufw logging full

    Habilita logs detalhados de todas as ações do firewall.

2. Instalação do ccze

sudo apt update
sudo apt install -y ccze

    Instala o colorizador de logs, embora não seja usado diretamente no script atual.

3. Criação da função ufw-colorlog

Adiciona ao ~/.bashrc a seguinte função:

ufw-colorlog() {
  sudo journalctl -k -f | awk '
  /BLOCK|DENIED|INVALID|DROP/ {
    print "\033[1;31m" $0 "\033[0m"; next
  }
  /DPT=23|DPT=445|DPT=3389|DPT=1433|DPT=21|DPT=22/ {
    print "\033[1;31m[!] Porta sensível: " $0 "\033[0m"; next
  }
  /ALLOW/ {
    print "\033[1;34m" $0 "\033[0m"; next
  }
  /SRC=([0-9]{1,3}\.){3}[0-9]{1,3}/ {
    print "\033[1;33m[~] Conexão ativa: " $0 "\033[0m"; next
  }
  {
    print "\033[0;37m" $0 "\033[0m";
  }'
}

🖍️ Colorização dos logs:
Tipo de Evento	Cor	Significado
BLOCK, DENIED, DROP, INVALID	Vermelho	Eventos bloqueados ou suspeitos
Portas comuns em ataques (ex: 22, 3389)	Vermelho	Alertas sobre uso de portas sensíveis
ALLOW	Azul	Conexões permitidas
SRC=xxx.xxx.xxx.xxx	Amarelo	Destaca o IP de origem das conexões
Outros	Cinza	Logs neutros
⚠️ Problemas Encontrados
Problema	Descrição
❌ ufw-colorlog não reconhecido	Após executar o script, o comando ufw-colorlog não funciona imediatamente. Isso ocorre porque o .bashrc foi modificado na execução do script, mas não foi recarregado na sessão interativa do terminal atual.
❌ Uso redundante de sudo sudo	Foi detectado no script original: sudo sudo journalctl -k -f, o que é incorreto.
✅ Soluções Aplicadas

    ✔️ Corrigido o comando duplicado sudo sudo → substituído por sudo.

    ✔️ Adicionado verificador para evitar duplicação da função no .bashrc.

    ✔️ Orientação clara para o usuário recarregar o .bashrc após execução:

source ~/.bashrc

🛠️ Sugestão de Melhoria (Opcional)
Criar um comando global em /usr/local/bin/

Passo 1 – Criar o script:

sudo nano /usr/local/bin/ufw-colorlog

Conteúdo:

#!/bin/bash
sudo journalctl -k -f | awk '
/BLOCK|DENIED|INVALID|DROP/ {
  print "\033[1;31m" $0 "\033[0m"; next
}
/DPT=23|DPT=445|DPT=3389|DPT=1433|DPT=21|DPT=22/ {
  print "\033[1;31m[!] Porta sensível: " $0 "\033[0m"; next
}
/ALLOW/ {
  print "\033[1;34m" $0 "\033[0m"; next
}
/SRC=([0-9]{1,3}\.){3}[0-9]{1,3}/ {
  print "\033[1;33m[~] Conexão ativa: " $0 "\033[0m"; next
}
{
  print "\033[0;37m" $0 "\033[0m";
}'

Passo 2 – Tornar executável:

sudo chmod +x /usr/local/bin/ufw-colorlog

Agora você pode usar:

ufw-colorlog

De qualquer terminal, sem depender do .bashrc.
🧪 Teste de Execução

ufw-colorlog

✅ O comando mostra logs do kernel em tempo real com destaques coloridos por tipo de evento.
✅ Conclusão

O script UFW-Color-Log.sh é uma ferramenta útil para administradores de sistemas que desejam monitorar o tráfego do firewall de forma mais visual. Após as correções e orientações aplicadas, ele funciona conforme o esperado.
📌 Requisitos

    Distribuição Linux com UFW e systemd (journalctl)

    Bash shell

    Permissões de superusuário (sudo)
