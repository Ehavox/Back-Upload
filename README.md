# Back Upload v1.0
Langue : Français
Développé par Ehavox

## Description

Back Upload est un programme interactif de sauvegarde conçu pour automatiser et sécuriser la copie de vos données vers un serveur distant.

Il permet de sauvegarder :

- Bases de données SQL (MariaDB)
- Fichiers
- Dossiers complets

Le script établit une connexion sécurisée vers un serveur de sauvegarde distant via SSH , puis transfère uniquement les données que vous avez sélectionnées avec RSYNC.

## Sécurité

Lors de la première configuration, le programme vous demandera :

- Les informations de connexion SSH vers le serveur distant
- Les éléments à sauvegarder

Ces informations :

- Sont utilisées uniquement sur votre système
- Servent exclusivement à établir la connexion distante
- Sont stockées dans un fichier de configuration chiffré
- Ne sont jamais transmises à un service tiers

Le chiffrement du fichier de configuration repose sur une clé définie par l'utilisateur.


## Fonctionnement général

1. Lancement du script
2. Saisie des informations SSH (si première utilisation)
3. Sélection :
   - Base(s) de données MariaDB à exporter
   - Fichier(s) à sauvegarder
   - Dossier(s) à transférer
4. Transfert sécurisé vers le serveur distant via RSYNC SSH (ed25519 et renforcement contre brute-force)
5. Installez le paquet 'rsync' sur le serveur de backup pour assuer le transfert

## Technologies utilisées

- Bash
- MariaDB (mysqldump)
- SSH
- Chiffrement via variable d’environnement openssl
- rsync

## Objectif du projet

Fournir une solution simple, interactive et sécurisée pour automatiser les sauvegardes vers un serveur distant sans nécessiter d’infrastructure complexe.
