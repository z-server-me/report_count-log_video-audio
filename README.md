# Explorateur Log Audio/Vidéo (Terminal)

Ce script Bash permet de naviguer dans les dossiers à l’aide du clavier (flèches + entrée) pour sélectionner un fichier `.log`, puis de lancer un compteur **audio/vidéo** en temps réel avec `watch`.

---

## 🎯 Objectif

- Naviguer dans les répertoires avec une interface simple en ligne de commande
- Sélectionner un fichier `.log`
- Afficher en direct :
  - Le nombre de fichiers **vidéo** détectés (`.mp4`, `.mkv`, `.avi`, `.mov`)
  - Le nombre de fichiers **audio** détectés (`.mp3`, `.flac`, `.wav`, `.ogg`)
  - Le total séparé pour audio et vidéo

---

## 🛠️ Prérequis

- `bash`
- [`fzf`](https://github.com/junegunn/fzf) (sélecteur interactif)
  - Installation :
    ```bash
    sudo apt install fzf
    ```

---

## 🚀 Utilisation

1. Rends le script exécutable :
    ```bash
    chmod +x explorateur_log_fzf.sh
    ```

2. Lance le script :
    ```bash
    ./explorateur_log_fzf.sh
    ```

---

## ⌨️ Raccourcis clavier dans l'explorateur

| Action                   | Touche                     |
|--------------------------|-----------------------------|
| Monter / Descendre      | ↑ / ↓ (flèches)             |
| Entrer dans un dossier  | **Entrée** sur un dossier   |
| Revenir en arrière      | **Sélectionner `../` + Entrée** |
| Valider un fichier      | **Entrée** sur un `.log`    |
| Quitter                 | **Échap** ou **Ctrl+C**     |

---

## 🧪 Exemple de sortie

```bash
--- Compteur audio/vidéo pour : /var/log/transfert_anime-music-serie.log ---

🎬 Vidéo :
  mp4   : 12
  mkv   : 5
  avi   : 2
  mov   : 1
  ➤ Total vidéo : 20

🎵 Audio :
  mp3   : 7
  flac  : 3
  wav   : 1
  ogg   : 2
  ➤ Total audio : 13
