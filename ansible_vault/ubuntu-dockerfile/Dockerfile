# Usare l'immagine ufficiale di Ubuntu come base
FROM ubuntu:20.04

# Usare argomenti per le password
ARG SSH_ROOT_PASSWORD
ARG SSH_GENERICUSER_PASSWORD

# Impostare le variabili d'ambiente per le password
ENV SSH_ROOT_PASSWORD=${SSH_ROOT_PASSWORD}
ENV SSH_GENERICUSER_PASSWORD=${SSH_GENERICUSER_PASSWORD}

# Installare OpenSSH, sudo e bash
RUN apt-get update && apt-get install -y openssh-server sudo bash \
    && rm -rf /var/lib/apt/lists/*

# Creare un utente generico
RUN useradd -m genericuser \
    && echo "genericuser:${SSH_GENERICUSER_PASSWORD}" | chpasswd \
    && usermod -aG sudo genericuser

# Consentire sudo senza password per genericuser
RUN echo "genericuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/genericuser \
    && chmod 0440 /etc/sudoers.d/genericuser

# Creare la cartella per il servizio SSH
RUN mkdir /var/run/sshd

# Impostare la password di root (opzionale, se necessario)
RUN echo "root:${SSH_ROOT_PASSWORD}" | chpasswd

# Copiare la chiave SSH per l'utente
COPY id_key_genericuser.pub /home/genericuser/.ssh/authorized_keys

# Impostare i permessi sulla cartella dell'utente
RUN chown -R genericuser:genericuser /home/genericuser/.ssh && chmod 700 /home/genericuser/.ssh && chmod 600 /home/genericuser/.ssh/authorized_keys

# Generare le chiavi host SSH (evita l'errore "no hostkeys available")
RUN ssh-keygen -A

# Abilitare il servizio SSH
RUN systemctl enable ssh

# Esponiamo la porta 22 per il container
EXPOSE 22

# Avviare il servizio SSH
CMD ["/usr/sbin/sshd", "-D"]
