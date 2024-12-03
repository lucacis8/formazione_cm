# Step 2 - Creare Build di container

Questo esercizio si concentra sulla creazione di due container Docker (uno basato su Ubuntu e l'altro su Rocky Linux) configurati per permettere l'accesso tramite SSH. I container vengono gestiti tramite Ansible utilizzando il playbook `build-containers.yml`.

## Requisiti

1. **Git**: per clonare il repository.
2. **Docker**: per costruire ed eseguire i container.
3. **Ansible**: per eseguire il playbook.
4. **Chiavi SSH**: per autenticarsi sui container.

## Istruzioni

### 1. Clonare il repository

Clonare il repository `formazione_cm`:

```bash
git clone https://github.com/lucacis8/formazione_cm
cd formazione_cm
```

All’interno del repository troverai i seguenti file e cartelle:
- `build-containers.yml`: il playbook Ansible per costruire ed eseguire i container.
- `ubuntu-dockerfile/`: contiene il Dockerfile per il container Ubuntu.
- `rockylinux-dockerfile/`: contiene il Dockerfile per il container Rocky Linux.

### 2. Creare le chiavi SSH

Per permettere l’accesso ai container tramite SSH, devi creare una coppia di chiavi SSH. Esegui il seguente comando per generare le chiavi:

```bash
ssh-keygen -t rsa -b 2048 -f id_key_genericuser -C "genericuser@example.com"
```

Questo creerà due file:
- `id_key_genericuser`: la chiave privata.
- `id_key_genericuser.pub`: la chiave pubblica.

**Passaggi successivi**:
1. Sposta la chiave pubblica nella directory di ciascun Dockerfile:
	•	`id_key_genericuser.pub` in `ubuntu-dockerfile/`
	•	`id_key_genericuser.pub` in `rockylinux-dockerfile/`
2. Sposta la chiave privata nella directory SSH del tuo utente locale:
```bash
mv id_key_genericuser ~/.ssh/
chmod 600 ~/.ssh/id_key_genericuser
```

### 3. Costruire ed eseguire i container

Esegui il playbook Ansible per costruire ed eseguire i container:

```bash
sudo ansible-playbook build-containers.yml
```

Questo playbook utilizzerà i Dockerfile per creare i container e configurarli per l’accesso SSH.

### 4. Connettersi ai container tramite SSH

Dopo aver eseguito con successo il playbook, puoi accedere ai container tramite SSH. Utilizza i seguenti comandi per accedere ai container:

Container Ubuntu
```bash
ssh -i ~/.ssh/id_key_genericuser -p 22 genericuser@localhost
```

Container Rocky Linux
```bash
ssh -i ~/.ssh/id_key_genericuser -p 2222 genericuser@localhost
```

### 5. Risoluzione dei problemi

Se incontri un errore del tipo “REMOTE HOST IDENTIFICATION HAS CHANGED!”, puoi rimuovere la chiave host precedente dal file dei localhost conosciuti. Usa questo comando generico per eliminare la chiave problematica:

```bash
sed -i '' '<numero-linea>d' ~/.ssh/known_hosts
```

Sostituisci `<numero-linea>` con il numero di linea corrispondente al messaggio d’errore. Dopo aver rimosso la chiave, riprova ad accedere al container.

## Note finali

Questo esercizio è stato progettato per familiarizzare con:
	•	La configurazione di container Docker con SSH.
	•	L’uso di Ansible per automatizzare la creazione e gestione dei container.
	•	La gestione di chiavi SSH per autenticazioni sicure.