#!/bin/bash

# Fonction de navigation interactive avec fzf
explorer() {
    local DIR="$1"
    while true; do
        CHOICE=$(ls -Ap "$DIR" | awk '{print} END {print "../"}' | fzf \
            --prompt="📂 $DIR > " \
            --header="Sélectionne un fichier .log ou un dossier" \
            --height=40% --reverse)

        [ -z "$CHOICE" ] && echo "❌ Annulé." && exit 1

        if [ "$CHOICE" == "../" ]; then
            DIR=$(dirname "$DIR")
            continue
        fi

        FULL_PATH="$(realpath "$DIR/$CHOICE")"

        if [ -d "$FULL_PATH" ]; then
            DIR="$FULL_PATH"
            continue
        fi

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

# Fonction de comptage audio/vidéo (sans couleurs)
compteur() {
    LOGFILE="$1"
    TMP_SCRIPT="/tmp/count_media_temp.sh"

    cat > "$TMP_SCRIPT" <<EOF
#!/bin/bash

echo "--- Compteur audio/vidéo pour : $LOGFILE ---"

# Vidéo
mp4=\$(grep -ic '\.mp4$' "$LOGFILE")
mkv=\$(grep -ic '\.mkv$' "$LOGFILE")
avi=\$(grep -ic '\.avi$' "$LOGFILE")
mov=\$(grep -ic '\.mov$' "$LOGFILE")
video_total=\$((mp4 + mkv + avi + mov))
last_video=\$(grep -Eo '[^/"]+\.(mp4|mkv|avi|mov)' "$LOGFILE" | tail -n 1 | LC_ALL=C tr -dc '[:print:]\n')

echo "🎬 Vidéo :"
printf "  mp4   : %d\n" \$mp4
printf "  mkv   : %d\n" \$mkv
printf "  avi   : %d\n" \$avi
printf "  mov   : %d\n" \$mov
echo "  ➤ Total vidéo : \$video_total"
echo "  📄 Dernier fichier vidéo : \$last_video"

# Audio
mp3=\$(grep -ic '\.mp3$' "$LOGFILE")
flac=\$(grep -ic '\.flac$' "$LOGFILE")
wav=\$(grep -ic '\.wav$' "$LOGFILE")
ogg=\$(grep -ic '\.ogg$' "$LOGFILE")
audio_total=\$((mp3 + flac + wav + ogg))
last_audio=\$(grep -Eo '[^/"]+\.(mp3|flac|wav|ogg)' "$LOGFILE" | tail -n 1 | LC_ALL=C tr -dc '[:print:]\n')

echo ""
echo "🎵 Audio :"
printf "  mp3   : %d\n" \$mp3
printf "  flac  : %d\n" \$flac
printf "  wav   : %d\n" \$wav
printf "  ogg   : %d\n" \$ogg
echo "  ➤ Total audio : \$audio_total"
echo "  📄 Dernier fichier audio : \$last_audio"
EOF

    chmod +x "$TMP_SCRIPT"
    watch -n 1 "$TMP_SCRIPT"
}

# Lancer depuis la racine
explorer "/"
