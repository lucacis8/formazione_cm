# Usare l'immagine ufficiale di Rocky Linux come base
FROM rockylinux:9

# Installare OpenSSH, sudo e bash
RUN dnf -y install openssh-server sudo bash docker.io \
    && rm -rf /var/cache/dnf

# Creare un utente generico
RUN useradd -m genericuser \
    && echo "genericuser:password" | chpasswd \
    && usermod -aG wheel genericuser

# Consentire sudo senza password per genericuser
RUN echo "genericuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/genericuser \
    && chmod 0440 /etc/sudoers.d/genericuser

# Creare la cartella per il servizio SSH
RUN mkdir /var/run/sshd

# Impostare la password di root (opzionale, se necessario)
RUN echo 'root:rootpassword' | chpasswd

# Copiare la chiave SSH per l'utente
COPY id_key_genericuser.pub /home/genericuser/.ssh/authorized_keys

# Impostare i permessi sulla cartella dell'utente
RUN chown -R genericuser:genericuser /home/genericuser/.ssh && chmod 700 /home/genericuser/.ssh && chmod 600 /home/genericuser/.ssh/authorized_keys

# Generare le chiavi host SSH (evita l'errore "no hostkeys available")
RUN ssh-keygen -A

# Abilitare il servizio SSH
RUN systemctl enable sshd

# Esponiamo la porta 22 per il container
EXPOSE 22

# Avviare il servizio SSH
CMD ["/usr/sbin/sshd", "-D"]
