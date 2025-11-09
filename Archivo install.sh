#!/bin/sh
# =====================================================
# Install myfetchFBSD - FreeBSD system info fetcher
# =====================================================

INSTALL_PATH="/usr/bin/myfetchFBSD.sh"

echo "Instalando myfetchFBSD en $INSTALL_PATH ..."

sudo cp myfetchFBSD.sh "$INSTALL_PATH"
sudo chmod +x "$INSTALL_PATH"

echo "Instalación completada."

# Añadir a ~/.zshrc si no existe
if ! grep -q "myfetchFBSD.sh" ~/.zshrc; then
    echo "Agregando al inicio de Zsh..."
    cat <<'EOF' >> ~/.zshrc

## Script myfetchFBSD Personalizado "agregando debajo de esta sesion: # Preferred editor for local and remote sessions"
if [ -f /usr/bin/myfetchFBSD.sh ]; then
    bash /usr/bin/myfetchFBSD.sh
fi
EOF
fi

echo "Instalación completa. Reinicia tu terminal."
