#!/bin/bash

# Schritt 1: Dateiname abfragen
read -p "Bitte gib den Namen der Startdatei ein (z.B. start.sh): " datei_name

# Prüfen, ob die Datei existiert
if [ ! -f "$datei_name" ]; then
    echo "Datei '$datei_name' wurde nicht gefunden!"
    exit 1
fi

TARGET_FILE="$datei_name"

# Funktion zum Anzeigen der aktuellen Optionen
show_current_options() {
    echo "Aktuelle Optionen in $TARGET_FILE:"
    grep -E 'echo "[0-9]+\)' "$TARGET_FILE"
}

# Funktion zum Entfernen der Zeile mit "update"
remove_update_line() {
    sed -i '/update/d' "$TARGET_FILE"
}

# Funktion zum Hinzufügen einer neuen Option
add_option() {
    read -p "Gib den Text für die neue Option ein (z.B. '3) Neue Funktion'): " new_option_line
    # Entferne alte 'update'-Zeile falls vorhanden
    remove_update_line
    # Füge die neue Zeile ans Ende hinzu
    echo "$new_option_line" >> "$TARGET_FILE"
    echo "Neue Option wurde hinzugefügt."
}

# Funktion für die Automatisierung: Code in start.sh einfügen
insert_code_block() {
    # Beispiel: Markierung im start.sh, wo der Code eingefügt werden soll
    marker="# --- AUTOMATION BLOCK ---"

    # Prüfen, ob Marker existiert; wenn nicht, hinzufügen
    if ! grep -q "$marker" "$TARGET_FILE"; then
        echo "$marker" >> "$TARGET_FILE"
        echo "Marker '$marker' wurde am Ende von $TARGET_FILE hinzugefügt."
    fi

    # Generierten Codeblock erstellen (Beispiel)
    code_block=$(cat <<EOF

$marker
elif [ "\$auswahl" == "2" ]; then
    if [ -f "datei2" ]; then
        chmod +x "datei2"
        ./\"\$datei2\"
        # Hier kannst du noch weiteren Code hinzufügen
        # z.B. das Programm starten oder eine Nachricht ausgeben
        echo "datei2 wurde ausgeführt."
    fi
fi

EOF
)

    # Den Codeblock an die Stelle des Markers einfügen (ersetzen oder hinzufügen)
    sed -i "/$marker/{
        c\\
$code_block
}" "$TARGET_FILE"

    echo "Codeblock wurde in $TARGET_FILE eingefügt/ersetzt."
}

# Hauptmenü mit erweiterten Optionen
while true; do
    show_current_options
    echo ""
    echo "Was möchtest du tun?"
    echo "1) Neue Option hinzufügen"
    echo "2) Automatisierungscode einfügen/aktualisieren"
    echo "3) Beenden"
    read -p "Wähle eine Nummer (1-3): " choice

    case $choice in
        1)
            add_option
            ;;
        2)
            insert_code_block
            ;;
        3)
            echo "Beendet."
            break
            ;;
        *)
            echo "Ungültige Eingabe. Bitte versuche es erneut."
            ;;
    esac
    echo ""
done
