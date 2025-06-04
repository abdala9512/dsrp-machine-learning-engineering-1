#!/bin/bash

set -e

echo "Actualizando y actualizando el sistema..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y software-properties-common curl build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncursesw5-dev xz-utils tk-dev \
    libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

echo "Añadiendo deadsnakes PPA para Python 3.11..."
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update

echo "Instalando Python 3.11 y pip..."
sudo apt install -y python3.11 python3.11-venv python3.11-dev
curl -sS https://bootstrap.pypa.io/get-pip.py | sudo python3.11

echo "Configurando python3 y pip para apuntar a Python 3.11..."
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
sudo update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip3.11 1

echo "Instalando uv package manager..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv to PATH if installed via local user
export PATH="$HOME/.cargo/bin:$PATH"

echo "Creando requirements.txt..."
cat <<EOF > requirements.txt
jupyterlab
numpy
pandas
scikit-learn
matplotlib
seaborn
EOF

echo "Instalando paquetes de Python usando uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh
uv init
uv add -r requirements.txt

echo "Configuración completa!"
echo "Para activar tu entorno y ejecutar Jupyter Lab:"
echo "source jupyter_env/bin/activate"
echo "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser"

