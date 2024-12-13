# Step 5 - Jenkins & Ansible

## Obiettivo

Questo progetto utilizza Jenkins per automatizzare il ciclo di vita delle immagini Docker, dal build al push su un registro locale. Le operazioni principali includono:
1. Configurazione di un container con Docker attivo.
2. Configurazione di una pipeline Jenkins che:
   - Esegue la build di un’immagine Docker.
   - Tagga l’immagine in modo progressivo.
   - Esegue il push dell’immagine in un registry Docker locale.

---

## Parte 1: Configurazione del Container con Docker Attivo

Per configurare un container con Docker attivo, **basta seguire le istruzioni presenti nel file `STEP_3.md`**. Questo file guida alla configurazione completa di due container con Docker attivo, inclusa la creazione di un registro locale e la gestione delle immagini Docker.

### Verifica del Docker Attivo nel Container

Dopo aver seguito il file `STEP_3.md`, è possibile verificare che Docker sia attivo all’interno del container:

1. Accedi al container tramite:
   ```bash
   docker exec --user root -it <nome-del-container> bash
   ```

2. All’interno del container, esegui:
   ```bash
   docker ps
   ```

Questo comando mostrerà gli stessi container in esecuzione sull’host Mac, poiché il Docker socket (`/var/run/docker.sock`) è condiviso tra l’host e il container. **Non è Docker in Docker**, ma una condivisione diretta del socket Docker.

---

## Parte 2: Configurazione di Jenkins

### Creazione del Container Jenkins

Dopo aver seguito lo Step 3, e aver quindi creato il registro, procediamo configurando Jenkins. Crea un container Docker specifico che abbia accesso al Docker socket e ai volumi necessari. Esegui i seguenti comandi:

1. **Creazione del Container**:
   ```bash
   docker run -d \
       --name jenkins-container \
       -p 8080:8080 -p 50000:50000 \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -v jenkins_home:/var/jenkins_home \
       jenkins/jenkins:lts
   ```

- Il Docker socket (`/var/run/docker.sock`) è montato per consentire a Jenkins di eseguire comandi Docker.
- La directory `jenkins_home` viene utilizzata per mantenere i dati persistenti di Jenkins.

2. **Accedi all’Interfaccia di Jenkins**:

Apri un browser e vai su `http://localhost:8080`. Durante il primo avvio, Jenkins richiederà una chiave di sblocco. Recupera la chiave dal container con:
   ```bash
   docker exec jenkins-container cat /var/jenkins_home/secrets/initialAdminPassword
   ```

Procedi con la configurazione guidata.

3. **Installazione di Docker nel Container Jenkins**:

Completata la configurazione iniziale, accedi al container Jenkins come utente `root`:
   ```bash
   docker exec --user root -it jenkins-container bash
   ```

Installa Docker:
   ```bash
   apt update && apt install docker.io
   ```

Modifica i permessi del socket Docker:
   ```bash
   chown root:docker /var/run/docker.sock  
   chmod 660 /var/run/docker.sock  
   ```

Aggiungi l'utente `jenkins` al gruppo `docker` ed esci:
   ```bash
   usermod -aG docker jenkins
   ```

   ```bash
   exit
   ```

Riavvia il container Jenkins:
   ```bash
   docker restart jenkins-container
   ```

---

## Parte 3: Configurazione della Pipeline Jenkins

Segui questi passaggi per configurare una semplice pipeline:

1. **Creazione del Progetto Pipeline**:

- Vai su Jenkins > Nuovo Elemento.
- Dai un nome alla pipeline e seleziona il tipo “Pipeline”.

2. **Definizione della Pipeline**:

- Nella sezione Pipeline, seleziona “Pipeline script from SCM”.
- Configura:
	- SCM: Git.
	- Repository URL: Il link al repository GitHub (mettere https://github.com/lucacis8/formazione_cm).
 	- Ramo: */main
 - Assicurati che il Jenkinsfile sia posizionato nella root del repository.

3. **Esegui la Pipeline**:

Salva e avvia la pipeline. Controlla che tutte le fasi vengano completate con successo.

---

## Parte 4: Verifica delle operazioni

1. **Verifica l’immagine costruita**:

Dopo l’esecuzione della pipeline, verifica che l’immagine sia stata costruita:
   ```bash
   docker images
   ```

2. **Controlla il Registro Docker**:

Assicurati che l’immagine sia stata pushata nel registry:
   ```bash
   curl http://localhost:5000/v2/_catalog
   ```

Output atteso:
   ```bash
   {"repositories":["my-app"]}
   ```

3. **Esegui il Container**:

Puoi avviare un container basato sull’immagine:
   ```bash
   docker run -d localhost:5000/my-app:<timestamp>
   ```

4. **Debugging**:

- **Permission Denied sul Docker Socket**: Verifica i permessi del Docker socket montato nel container Jenkins.
- **Immagini non disponibili**: Controlla che la fase di push della pipeline non abbia errori.

---

## Conclusione

Seguendo questa guida, hai configurato un ambiente Jenkins completo per automatizzare la build, il tagging e il push delle immagini Docker. Il progetto sfrutta il socket Docker condiviso per eseguire comandi Docker direttamente dal container Jenkins.
