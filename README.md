# Formazione Sourcesense - DevOps Academy - Track 3

Questa repository contiene una serie di step progressivi per implementare soluzioni di automazione utilizzando **Ansible**, **Docker** e **Jenkins**. Gli esercizi proposti permettono di configurare infrastrutture, gestire container, proteggere credenziali e automatizzare pipeline CI/CD.

---

## Struttura della Track

### **Step 1 - Introduzione ad Ansible**
Definizione e utilizzo dei concetti di base di Ansible:
- Configurazione degli host remoti.
- Creazione ed esecuzione di playbook per automatizzare task ripetibili.

---

### **Step 2 - Configurazione di Ambienti Server**
Utilizzo di Ansible per automatizzare la configurazione di server:
- Installazione di pacchetti necessari.
- Configurazione di servizi e parametri di sistema.
- Esecuzione di task ripetibili su ambienti multipli.

---

### **Step 3 - Containerizzazione e Registry Docker**
Integrazione di Ansible con Docker per:
- Configurare un registry Docker locale per la gestione delle immagini.
- Creare immagini container personalizzate basate su Dockerfile.
- Effettuare il push delle immagini sul registry locale.
- Avviare container configurati, con porte e servizi esposti.

---

### **Step 4 - Sicurezza delle Credenziali con Ansible Vault**
Protezione delle credenziali sensibili e gestione sicura delle configurazioni:
- Utilizzo di Ansible Vault per cifrare file e variabili.
- Implementazione di password sicure per utenti e servizi.
- Esecuzione di playbook che utilizzano dati protetti.

---

### **Step 5 - Automazione con Jenkins**
Automazione del ciclo di vita delle immagini Docker con Jenkins:
- Configurazione di un container Jenkins con accesso al Docker socket.
- Creazione di pipeline per il build, il tag e il push delle immagini Docker.
- Gestione progressiva delle versioni delle immagini.
- Integrazione con un registry Docker locale.

---

## Obiettivi della Repository

1. Automatizzare la configurazione di infrastrutture server con Ansible.
2. Creare e gestire container Docker in modo scalabile.
3. Proteggere credenziali e configurazioni sensibili.
4. Implementare pipeline CI/CD per la gestione e il deployment di immagini Docker.

Questa repository è organizzata in modo che ogni step sia autonomo e possa essere eseguito singolarmente per sperimentare gli strumenti e le tecniche descritte.
