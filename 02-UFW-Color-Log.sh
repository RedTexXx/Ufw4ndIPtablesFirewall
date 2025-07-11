#!/bin/bash

# === Ativando o log completo do UFW ===
echo "[+] Ativando log completo do UFW..."
sudo ufw logging full

# === Instala o utilitário ccze, se necessário ===
echo "[+] Instalando ccze (colorizador de logs)..."
sudo apt update
sudo apt install -y ccze

# === Verifica se o alias já existe no ~/.bashrc ===
if grep -q "ufw-colorlog()" ~/.bashrc; then
    echo "[!] Alias 'ufw-colorlog' já existe no ~/.bashrc. Pulando adição."
else
    echo "[+] Adicionando comando 'ufw-colorlog' ao ~/.bashrc..."

    cat << 'EOF' >> ~/.bashrc

# === UFW Color Log Avançado ===
ufw-colorlog() {
  sudo journalctl -k -f | awk '
  /BLOCK|DENIED|INVALID|DROP/ {
    print "\033[1;31m" $0 "\033[0m"; next  # Vermelho para eventos bloqueados/suspeitos
  }
  /DPT=23|DPT=445|DPT=3389|DPT=1433|DPT=21|DPT=22/ {
    print "\033[1;31m[!] Porta sensível: " $0 "\033[0m"; next  # Vermelho para portas comuns a ataques
  }
  /ALLOW/ {
    print "\033[1;34m" $0 "\033[0m"; next  # Azul para conexões permitidas
  }
  /SRC=([0-9]{1,3}\.){3}[0-9]{1,3}/ {
    print "\033[1;33m[~] Conexão ativa: " $0 "\033[0m"; next  # Amarelo para conexões com IP
  }
  {
    print "\033[0;37m" $0 "\033[0m";  # Cinza para logs neutros
  }'
}
EOF
fi

# === Recarrega o ~/.bashrc para ativar a função ===
echo "[+] Recarregando ~/.bashrc..."
source ~/.bashrc

echo "[✔] Pronto! Agora você pode usar o comando: ufw-colorlog"
