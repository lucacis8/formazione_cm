# Usa un'immagine di base
FROM python:3.9-slim

# Imposta la directory di lavoro
WORKDIR /app

# Copia i file del progetto
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Comando per eseguire l'applicazione
CMD ["python", "src/app.py"]
