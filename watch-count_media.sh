#!/bin/bash

explorer() {
    local DIR="$1"
    while true; do
        # Crée une liste : ".." pour revenir + fichiers/rep dans ce dossier
        CHOICE=$(ls -Ap "$DIR" | fzf --prompt="📂 $DIR > " --header="Sélectionne un fichier .log ou un dossier" --height=40% --reverse)
        
        # Si échappé ou rien sélectionné
        [ -z "$CHOICE" ] && echo "❌ Annulé." && exit 1

        # Gestion ".." pour revenir au parent
        if [ "$CHOICE" == "../" ]; then
            DIR=$(dirname "$DIR")
            continue
        fi

        FULL_PATH="$DIR/$CHOICE"

        # Si dossier → replonger dedans
        if [ -d "$FULL_PATH" ]; then
            DIR="$FULL_PATH"
            continue
        fi

        # Si fichier avec extension .log → ok
        if [[ "$FULL_PATH" =~ \.log$ ]]; then
            echo "✅ Fichier sélectionné : $FULL_PATH"
            echo ""
            echo "⏳ Lancement du compteur dans 2 secondes..."
            sleep 2
            compteur "$FULL_PATH"
            return
        else
            echo "❌ Ce n'est pas un fichier .log. Essaie encore."
        fi
    done
}

compteur() {
LOGFILE="$1"

watch -n 1 "
echo '--- Compteur audio/vidéo pour : $LOGFILE ---'

# Vidéos
mp4=\$(grep -ic '\.mp4$' \"$LOGFILE\")
mkv=\$(grep -ic '\.mkv$' \"$LOGFILE\")
avi=\$(grep -ic '\.avi$' \"$LOGFILE\")
mov=\$(grep -ic '\.mov$' \"$LOGFILE\")
video_total=\$((mp4 + mkv + avi + mov))

echo '🎬 Vidéo :'
printf '  mp4   : %d\n' \$mp4
printf '  mkv   : %d\n' \$mkv
printf '  avi   : %d\n' \$avi
printf '  mov   : %d\n' \$mov
echo \"  ➤ Total vidéo : \$video_total\"

# Audios
mp3=\$(grep -ic '\.mp3$' \"$LOGFILE\")
flac=\$(grep -ic '\.flac$' \"$LOGFILE\")
wav=\$(grep -ic '\.wav$' \"$LOGFILE\")
ogg=\$(grep -ic '\.ogg$' \"$LOGFILE\")
audio_total=\$((mp3 + flac + wav + ogg))

echo ''
echo '🎵 Audio :'
printf '  mp3   : %d\n' \$mp3
printf '  flac  : %d\n' \$flac
printf '  wav   : %d\n' \$wav
printf '  ogg   : %d\n' \$ogg
echo \"  ➤ Total audio : \$audio_total\"
"
}

# Lancer l'explorateur depuis le dossier courant
explorer "/"
