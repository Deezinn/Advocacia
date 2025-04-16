# Use Alpine como base
FROM alpine:3.21

# Defina o diretório de trabalho
WORKDIR /app

# Instale as dependências necessárias (Python, pip, etc.)
RUN apk add --no-cache python3 py3-pip py3-virtualenv

# Crie o ambiente virtual
RUN python3 -m venv /venv

# Defina o diretório do ambiente virtual como variável de ambiente
ENV PATH="/venv/bin:$PATH"

# Copie o arquivo requirements.txt para o container
COPY requirements.txt .

# Instale as dependências Python no ambiente virtual
RUN pip install --no-cache-dir -r requirements.txt

# Copie o código da aplicação
COPY src/ .

# Exponha a porta usada pelo Dash (default é 8050)
EXPOSE 8050

# Defina o comando para rodar o app
CMD ["python", "index.py"]
