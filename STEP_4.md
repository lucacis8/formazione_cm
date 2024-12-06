# Step 4 - Vault

## Obiettivo
L'obiettivo di questo esercizio è integrare Ansible Vault per proteggere le credenziali sensibili. In particolare:
1. Utilizzare Ansible per configurare un registry Docker locale, costruire immagini Docker, effettuare il push delle immagini e avviare container.
2. Oscurare tutte le password (come quelle per gli utenti nei Dockerfile o per il registry) utilizzando Ansible Vault.

## Struttura del Progetto
La struttura del progetto è la stessa dello **Step 3**, ma include un file Vault per gestire in sicurezza le credenziali sensibili:
```bash
.
├── main-playbook.yml          # Playbook principale che esegue tutti i ruoli
├── vault.yml                  # File cifrato contenente le credenziali (es. password)
├── roles/
│   ├── registry/
│   │   └── tasks/
│   │       └── main.yml       # Configura e avvia il registry locale
│   ├── build_images/
│   │   └── tasks/
│   │       └── main.yml       # Costruisce le immagini Docker
│   ├── push_images/
│   │   └── tasks/
│   │       └── main.yml       # Pusha le immagini Docker
│   ├── run_containers/
│   │   └── tasks/
│   │       └── main.yml       # Esegue i container basati sulle immagini
```

### Ruoli

Gli stessi ruoli descritti nello Step 3 sono utilizzati per questa esercitazione.

---

## Come Eseguire il Progetto
1. Clonare la repository
```bash
git clone https://github.com/lucacis8/formazione_cm
cd formazione_cm/ansible_vault
```

2. Generare le chiavi SSH
```bash
ssh-keygen -t rsa -b 4096 -C "genericuser@example.com" -f id_key_genericuser
```

Copia le chiavi nei percorsi corretti:
```bash
cp id_key_genericuser.pub ./ubuntu-dockerfile/
cp id_key_genericuser.pub ./rockylinux-dockerfile/
cp id_key_genericuser ~/.ssh/
chmod 600 ~/.ssh/id_key_genericuser
```

3. Creare il file Vault con le credenziali
Crea un file cifrato vault.yml per gestire le password:
```bash
ansible-vault create vault.yml
```

Inserisci le seguenti credenziali nel file, specificando delle proprie password:
```bash
ssh_root_password: "password"
ssh_genericuser_password: "password"
docker_registry_user: "genericuser"
docker_registry_password: "password"
```

Salva e chiudi l’editor. Assicurati di ricordare la password che hai scelto per il Vault.

4. Eseguire il playbook principale
Usa il comando seguente per eseguire il playbook, specificando la password del Vault:
```bash
sudo ansible-playbook main-playbook.yml --ask-vault-pass
```

5. Verifica il contenuto del registry
```bash
curl http://localhost:5000/v2/_catalog
```

Output atteso:
```bash
{"repositories":["rockylinux-ssh-container", "ubuntu-ssh-container"]}
```

6. Controlla i container in esecuzione
```bash
docker ps
```

Output atteso:
```bash
CONTAINER ID   IMAGE                                      COMMAND               PORTS
<ID>           rockylinux-ssh-container:latest            ...                   0.0.0.0:2222->22/tcp
<ID>           ubuntu-ssh-container:latest                ...                   0.0.0.0:22->22/tcp
<ID>           registry:2                                 ...                   0.0.0.0:5000->5000/tcp
```

---

## Documentazione Aggiuntiva

### Ansible Vault

#### Comandi Utili
- **Cifrare un file:**
```bash
ansible-vault encrypt <file>
```

- **Decriptare un file:**
```bash
ansible-vault decrypt <file>
```

- **Modificare un file cifrato:**
```bash
ansible-vault edit <file>
```

- **Cifrare una stringa:**
```bash
ansible-vault encrypt_string 'stringa_da_cifrare' --vault-password-file ~/.vault
```

#### Script per cifrare file in modo ricorsivo:
```bash
for i in $(find . -type f); do ansible-vault encrypt $i --vault-password-file ~/.vault && echo "$i cifrato"; done
```

### Debugging e Risoluzione Problemi
- **Errore di decriptazione:** Assicurati di fornire la password corretta.
- **File Vault non trovato:** Verifica che `vault.yml` sia nel percorso corretto e incluso nei `vars_files` del playbook.
