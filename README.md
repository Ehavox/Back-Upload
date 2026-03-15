# Back Upload v1.0

Langue : Français

Développé par Ehavox

## Description

Back Upload est un programme interactif de sauvegarde conçu pour automatiser et sécuriser la copie de vos données vers un serveur distant.

Il permet de sauvegarder :

* Bases de données SQL (MariaDB)
* Fichiers
* Dossiers complets

Le script établit une connexion sécurisée vers un serveur de sauvegarde distant via SSH, puis transfère uniquement les données que vous avez sélectionnées avec RSYNC.

## Utilisation

### Prérequis

Assurez-vous que `rsync` est installé sur votre machine locale ainsi que sur le serveur de destination.

### Installation et Lancement

Pour utiliser le script, clonez le dépôt et donnez-lui les droits d'exécution :

```bash
git clone https://github.com/Ehavox/Back-Upload.git
cd Back-Upload
apt install dos2unix
dos2unix BackUpload_by_Ehavox.sh
chmod +x back-upload.sh
./back-upload.sh

```

### Aperçu de l'interface

**1. Configuration initiale et connexion SSH** Lors du premier lancement, le script vous guidera pour configurer vos accès sécurisés.

**2. Sélection des éléments à sauvegarder** Interace du programme.

---

## Sécurité

Lors de la première configuration, le programme vous demandera :

* Les informations de connexion SSH vers le serveur distant
* Les éléments à sauvegarder

Ces informations :

* Sont utilisées uniquement sur votre système
* Servent exclusivement à établir la connexion distante
* Sont stockées dans un fichier de configuration chiffré
* Ne sont jamais transmises à un service tiers

Le chiffrement du fichier de configuration repose sur une clé définie par l'utilisateur via **OpenSSL**.

## Fonctionnement général

1. **Lancement du script**
2. **Saisie des informations SSH** (si première utilisation)
3. **Sélection :**
* Base(s) de données MariaDB à exporter
* Fichier(s) à sauvegarder
* Dossier(s) à transférer


4. **Transfert sécurisé** vers le serveur distant via RSYNC SSH (ed25519 et renforcement contre brute-force)
5. **Optimisation :** Installez le paquet `rsync` sur le serveur de backup pour assurer le transfert.

## Technologies utilisées

* **Bash**
* **MariaDB** (mysqldump)
* **SSH**
* **Chiffrement** via variable d’environnement OpenSSL
* **RSYNC**


# Release v1.0.0
### Nouveautés

* **Moteur de transfert :** Passage de `scp` à `rsync` pour plus de performance et de fiabilité.
* **Sécurité :** Refonte de la gestion des variables d'environnement.
* **Chiffrement :** Ajustements et optimisations de la configuration `openssl`.

### Corrections & Améliorations

* **Validation des saisies :** Contrôle rigoureux des entrées (IP, Cron, Port).
* **Stabilité :** Correction des bugs identifiés durant la version bêta.
> **Note :** Cette version marque le passage en version stable. Pensez à mettre à jour vos configurations.
