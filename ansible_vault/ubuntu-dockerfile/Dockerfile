# Usare l'immagine ufficiale di Ubuntu come base
FROM ubuntu:24.04

# Usare argomenti per le password
ARG SSH_ROOT_PASSWORD
ARG SSH_GENERICUSER_PASSWORD

# Impostare le variabili d'ambiente per le password (opzionale, per debug)
ENV SSH_ROOT_PASSWORD=${SSH_ROOT_PASSWORD}
ENV SSH_GENERICUSER_PASSWORD=${SSH_GENERICUSER_PASSWORD}

# Installare OpenSSH, sudo e bash
RUN apt-get update && apt-get install -y openssh-server sudo bash docker.io \
    && rm -rf /var/lib/apt/lists/*

# Configurare SSH per consentire l'accesso con password e login come root
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config && \
    echo "LogLevel DEBUG" >> /etc/ssh/sshd_config

# Creare un utente generico
RUN useradd -m genericuser \
    && echo "genericuser:${SSH_GENERICUSER_PASSWORD}" | chpasswd \
    && usermod -aG sudo genericuser

# Consentire sudo senza password per genericuser
RUN echo "genericuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/genericuser \
    && chmod 0440 /etc/sudoers.d/genericuser

# Creare la cartella per il servizio SSH
RUN mkdir /var/run/sshd

# Impostare la password di root
RUN echo "root:${SSH_ROOT_PASSWORD}" | chpasswd

# Generare le chiavi host SSH (evita l'errore "no hostkeys available")
RUN ssh-keygen -A

# Abilitare il servizio SSH per avviarsi automaticamente
RUN systemctl enable ssh

# Esponiamo la porta 22 per il container
EXPOSE 22

# Avviare il servizio SSH
CMD ["/usr/sbin/sshd", "-D"]
