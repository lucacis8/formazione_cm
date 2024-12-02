# Step 1 - Creare il Primo Playbook

Questo progetto contiene un playbook Ansible per avviare un **Docker registry locale** (senza autenticazione) e un contenitore `hello-world` per testare la configurazione. Segui i passaggi seguenti per eseguire il playbook e verificare che tutto funzioni correttamente.

## Requisiti

Assicurati di avere i seguenti strumenti installati sulla tua macchina:

- **Docker**: Per gestire i contenitori e le immagini Docker.
- **Ansible**: Per eseguire il playbook di automazione.
- **Un terminale con privilegi sudo**: Per eseguire i comandi che richiedono permessi di amministratore.

## Struttura del Progetto

- `container-playbook.yml`: Il playbook Ansible che esegue la configurazione.
- Docker Registry: Configurato per essere eseguito localmente sulla porta `5000`.

## Istruzioni

### 1. Clona il repository

Prima di tutto, clona il repository che contiene il playbook:

```bash
git clone https://github.com/tuo-utente/formazione_cm.git
cd formazione_cm
```

### 2. Esegui il playbook Ansible

Per eseguire il playbook, utilizza il comando seguente:

```bash
sudo ansible-playbook container-playbook.yml
```

### 3. Verifica che il tutto sia stato configurato correttamente

Dopo aver eseguito il playbook, segui questi passaggi per verificare che il Docker registry e il contenitore `hello-world` siano in esecuzione correttamente.

**3.1 Verifica il Docker Registry**

Controlla che il contenitore del registry sia in esecuzione con il comando:

```bash
docker ps
```

Dovresti vedere un contenitore chiamato `registry` in esecuzione sulla porta `5000`.

**3.2 Verifica le Immagini Docker**

Controlla che l’immagine `hello-world` sia stata scaricata correttamente:

```bash
docker images
```

Dovresti vedere l’immagine `hello-world` nella lista delle immagini disponibili.

**3.3 Verifica il Contenitore hello-world**

Controlla che il contenitore `hello-world-container` sia stato avviato correttamente:

```bash
docker ps
```

Dovresti vedere il contenitore `hello-world-container` in esecuzione.

**3.4 Testa il Registry Locale**

Testa il Docker registry locale per vedere se è attivo:

```bash
curl http://localhost:5000/v2/_catalog
```

Se il registry è attivo, dovresti vedere una risposta JSON simile a questa:

```bash
{"repositories":[]}
```

**3.5 Testa il Push di un’Immagine nel Registry**

Per testare il funzionamento del registry locale, puoi provare a caricare un’immagine nel registry. Esegui i seguenti comandi:
1. Tagga l’immagine `hello-world` per il tuo registry locale:
   ```bash
   docker tag hello-world localhost:5000/hello-world
   ```

2. Esegui il push dell’immagine nel registry locale:
   ```bash
   docker push localhost:5000/hello-world
   ```

Se il push ha successo, il registry funziona correttamente.

## Dettagli del Playbook

Il playbook Ansible esegue i seguenti task:
1. **Avvia un contenitore Docker** `hello-world`: Utilizza l’immagine `hello-world` per avviare un contenitore.
2. **Scarica l’immagine** `hello-world`: Esegui il pull dell’immagine dal Docker Hub.
3. **Avvia un registry Docker locale**: Utilizza l’immagine `registry:2` per creare un Docker registry in esecuzione sulla porta `5000`.
4. **Esegui il contenitore** `hello-world`: Esegui il contenitore `hello-world` e impostalo per il riavvio automatico.

## Problemi Comuni

- **Docker non installato**: Se non hai Docker installato, puoi seguire la documentazione ufficiale per installarlo: https://docs.docker.com/get-docker/.
- **Ansible non installato**: Se non hai Ansible, puoi installarlo con il comando `pip install ansible` o seguendo la guida ufficiale: https://docs.ansible.com/ansible/latest/installation_guide/.
