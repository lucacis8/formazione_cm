# Step 5 - Jenkins & Ansible

## Obiettivo

In questo progetto, la pipeline Jenkins automatizza la costruzione, il tagging e il push di immagini Docker. La pipeline esegue le seguenti operazioni:
1. Costruzione di un'immagine Docker a partire da un `Dockerfile` presente nel repository.
2. Tagging progressivo dell'immagine costruita.
3. Push dell'immagine nel registry Docker locale (su `localhost:5000`).

### Configurazione del Container con Docker Attivo

La prima parte della consegna riguarda la configurazione di un container che deve avere attivo il servizio Docker o Podman. Per questa parte, puoi seguire `STEP_3.md`, che ti guida alla configurazione di un registry Docker locale, alla creazione di immagini Docker personalizzate e al push di queste immagini nel registry.

Una volta configurato il container, puoi accedere al container Ubuntu (o anche a quello basato su Rocky Linux) per verificare che Docker stia funzionando correttamente. Puoi farlo con i seguenti passaggi:
1. Accedi al container tramite `docker exec`:
   ```bash
   docker exec -it jenkins-container bash
   ```

2. All’interno del container, verifica che Docker sia attivo e che i container vengano mostrati correttamente:
   ```bash
   sudo docker ps
   ```

Questo comando mostrerà gli stessi container in esecuzione sul tuo sistema Mac, perché il Docker socket è condiviso tra l’host e il container (non è Docker in Docker).

## Struttura del Progetto

Il progetto contiene un file Jenkinsfile per la configurazione della pipeline Jenkins e la struttura Docker necessaria per costruire e spingere le immagini.
```bash
.
├── Dockerfile                 # Dockerfile per costruzione immagine
├── Jenkinsfile                # Configurazione della pipeline Jenkins
└── README.md                  # Questo file
```

### Pipeline Jenkins

La pipeline è strutturata in più fasi principali:
1. **Checkout del codice**: Recupera il codice dal repository GitHub.
2. **Build dell’immagine Docker**: Crea l’immagine Docker basata sul `Dockerfile` e la tagga progressivamente con un timestamp.
3. **Push nel registry Docker**: Esegue il push dell’immagine costruita nel registro Docker locale sulla porta `5000`.

## Come Funziona

### Configurazione del Container Jenkins

Il container Jenkins è già configurato con Docker e Ansible, quindi è necessario solo eseguire il passo di configurazione della pipeline (come descritto nel passo 2).

### Creazione della Pipeline Jenkins

1. **Clonare il Repository**:
Clona il repository GitHub dove è presente il file `Jenkinsfile`:
   ```bash
   git clone https://github.com/lucacis8/formazione_cm
   cd formazione_cm
   ```

2. **Configurazione di Jenkins**:
Assicurati di avere i plugin `docker-plugin` e `ansible-plugin` installati su Jenkins per abilitare le fasi di costruzione delle immagini e configurare il registry Docker locale.

### Creazione del Jenkinsfile

Il file `Jenkinsfile` definisce la pipeline. La pipeline include:
- **Checkout del codice**: Il repository Git viene scaricato da GitHub.
- **Build dell’immagine Docker**: L’immagine viene costruita con il comando `docker build` e viene taggata utilizzando un timestamp.
- **Push nel registry**: L’immagine viene pushata nel registry Docker locale in esecuzione sulla porta `5000`.

Ecco un esempio di configurazione di base del `Jenkinsfile`:
```bash
pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = 'my-app'
        DOCKER_REGISTRY = 'localhost:5000'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def timestamp = new Date().format('yyyyMMddHHmmss')
                    sh "docker build -t ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${timestamp} ."
                }
            }
        }

        stage('Push to Registry') {
            steps {
                script {
                    def timestamp = new Date().format('yyyyMMddHHmmss')
                    sh "docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE_NAME}:${timestamp}"
                }
            }
        }
    }
}
```

### Verifica dell’Immagine

Una volta che la pipeline è eseguita con successo, verifica che l’immagine sia stata costruita e pushata correttamente:
1. **Verifica l’Elenco delle Immagini Docker**:
Controlla se l’immagine è stata creata localmente con il comando:
   ```bash
   docker images
   ```

2. **Verifica il Registro Docker Locale**:
Per verificare se l’immagine è stata pushata nel registry Docker locale, esegui:
   ```bash
   curl http://localhost:5000/v2/_catalog
   ```

Output atteso:
   ```bash
   {"repositories":["my-app"]}
   ```

### Esegui il Container

Per eseguire il container basato sull’immagine appena creata, utilizza il comando Docker `run`:
   ```bash
   docker run -d localhost:5000/my-app:<timestamp>
   ```

Puoi anche controllare i log del container con il comando:
   ```bash
   docker logs <container_id>
   ```

### Debugging e Risoluzione Problemi

Se riscontri problemi durante l’esecuzione della pipeline o dei container, considera i seguenti punti:
- **Connessione al Docker Socket**: Assicurati che il Docker socket (`/var/run/docker.sock`) sia correttamente montato e accessibile dal container Jenkins.
- **Permission Denied su Docker**: Se ottieni errori di permessi, controlla che l’utente Jenkins abbia i permessi per accedere al Docker socket.
- **Immagini Non Trovate nel Registro**: Verifica che il processo di build e push sia stato completato senza errori.
- **Container Non Avviati**: Controlla i log dei container per eventuali errori di avvio.

## Conclusioni

Questa configurazione automatizza il flusso di lavoro di costruzione e distribuzione delle immagini Docker tramite Jenkins. Con la pipeline configurata correttamente, ogni push nel repository GitHub avvierà automaticamente la costruzione e il push di nuove immagini nel registry Docker locale.
