# Step 3 - Creazione di un ruolo

## Obiettivo
L'obiettivo di questo esercizio è utilizzare Ansible per:
1. Configurare un registry Docker locale.
2. Costruire immagini Docker personalizzate di Ubuntu e Rocky Linux.
3. Effettuare il push delle immagini nel registry locale.
4. Eseguire container basati su queste immagini.

## Struttura del Progetto
Il progetto è organizzato in più ruoli Ansible, ciascuno responsabile di un aspetto specifico:
```bash
.
├── main-playbook.yml          # Playbook principale che esegue tutti i ruoli
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
│   └── run_containers/
│       └── tasks/
│           └── main.yml       # Esegue i container basati sulle immagini
├── ubuntu-dockerfile/
│   └── Dockerfile
├── rockylinux-dockerfile/
│   └── Dockerfile
```

### Ruoli

#### 1. `registry`
Questo ruolo configura un registry locale sulla porta `5000` utilizzando Docker o Podman.  
- Verifica se `docker` o `podman` è installato.
- Avvia un container `registry:2` configurato per connessioni non sicure.

#### 2. `build_images`
Costruisce immagini Docker o Podman personalizzate:
- `ubuntu-ssh-container`
- `rockylinux-ssh-container`

#### 3. `push_images`
Effettua il push delle immagini al registry locale:  
- `localhost:5000/ubuntu-ssh-container:latest`
- `localhost:5000/rockylinux-ssh-container:latest`

#### 4. `run_containers`
Questo ruolo esegue i container utilizzando le immagini presenti nel registry locale.  
- Controlla se Docker o Podman è installato e configura il motore dei container.
- Esegue i container:
  - **Ubuntu Container:** Nome: `ubuntu-ssh-container`, Porta SSH: `2222`
  - **Rocky Linux Container:** Nome: `rockylinux-ssh-container`, Porta SSH: `2200`

## Come Eseguire il Progetto
1. Clonare la repository:
   ```bash
   git clone https://github.com/lucacis8/formazione_cm
   cd formazione_cm
   ```

2. Genera le chiavi SSH e spostale nei percorsi corretti:
   ```bash
   ssh-keygen -t rsa -b 4096 -C "genericuser@example.com" -f id_key_genericuser
   ```

   ```bash
   cp id_key_genericuser.pub ./ubuntu-dockerfile/
   cp id_key_genericuser.pub ./rockylinux-dockerfile/
   cp id_key_genericuser ~/.ssh/
   chmod 600 ~/.ssh/id_key_genericuser
   ```

3. Eseguire il playbook principale:
   ```bash
   sudo ansible-playbook main-playbook.yml
   ```

4. Verifica il contenuto del registry:
   ```bash
   curl http://localhost:5000/v2/_catalog
   ```

Output atteso:
   ```bash
   {"repositories":["rockylinux-ssh-container", "ubuntu-ssh-container"]}
   ```

5. Controlla i container in esecuzione:
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

### Dettagli Implementativi

#### Registry Locale

- Accessibile sulla porta `5000`.
- Connessioni non sicure abilitate per facilitare i test.

#### Costruzione e Push delle Immagini

- **Ubuntu**: `ubuntu-ssh-container` basata su un Dockerfile personalizzato.
- **Rocky Linux**: `rockylinux-ssh-container` basata su un Dockerfile personalizzato.
- Le immagini sono taggate con `localhost:5000`.

#### Esecuzione dei Container

- Container configurati per esporre il servizio SSH.
- Porte SSH:
	- Ubuntu: 22
	- Rocky Linux: 2222

#### Debugging e Risoluzione Problemi

- Errore di Connessione al Registry: Verifica che il registry locale sia avviato e accessibile sulla porta 5000.
- Immagini Non Trovate: Assicurati che il processo di build e push sia completato senza errori.
- Container Non Avviati: Controlla i log dei container per eventuali problemi.
