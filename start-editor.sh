#!/bin/bash

# Schritt 1: Dateiname abfragen
read -p "Bitte gib den Namen der Startdatei ein (z.B. start.sh): " datei_name

# Prüfen, ob die Datei existiert
if [ ! -f "$datei_name" ]; then
    echo "Datei '$datei_name' wurde nicht gefunden!"
    exit 1
fi

TARGET_FILE="$datei_name"

# Funktion zum Hinzufügen oder Aktualisieren des Codeblocks bei Marker
update_code_block() {
    marker="# --- AUTOMATION BLOCK ---"

    # Generierten Codeblock (kann nach Bedarf angepasst werden)
    code_block=$(cat <<EOF

$marker
elif [ "\$auswahl" == "2" ]; then
    if [ -f "datei2" ]; then
        chmod +x "datei2"
        ./\"\$datei2\"
        echo "datei2 wurde ausgeführt."
    fi
fi

EOF
)

    # Prüfen, ob der Marker existiert; wenn nicht, hinzufügen
    if ! grep -q "$marker" "$TARGET_FILE"; then
        echo "$marker" >> "$TARGET_FILE"
        echo "Marker '$marker' wurde am Ende von $TARGET_FILE' hinzugefügt."
    fi

    # Den Codeblock an die Stelle des Markers einfügen/ersetzen
    sed -i "/$marker/c\\
$code_block" "$TARGET_FILE"

    echo "Codeblock wurde in $TARGET_FILE aktualisiert."
}

# Hauptmenü mit Optionen
while true; do
    echo ""
    echo "Was möchtest du tun?"
    echo "1) Automatisierungscode einfügen/aktualisieren"
    echo "2) Beenden"
    read -p "Wähle eine Nummer (1-2): " choice

    case $choice in
        1)
            update_code_block
            ;;
        2)
            echo "Beendet."
            break
            ;;
        *)
            echo "Ungültige Eingabe. Bitte versuche es erneut."
            ;;
    esac
done
