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

    # Neue Auswahlname und Dateiname abfragen
    read -p "Wie soll die neue Auswahl heißen? (z.B. '3) Neue Funktion'): " neue_auswahl
    read -p "Wie heißt die Datei, die ausgeführt werden soll? (z.B. 'datei3'): " datei
    read -p "Soll die Datei mit chmod +x ausführbar gemacht werden? (j/n): " chmod_antwort

    # Falls ja, dann chmod +x ausführen
    if [[ "$chmod_antwort" == [jJ] || "$chmod_antwort" == [jJ][aA][nN] ]]; then
        if [ -f "$datei" ]; then
            chmod +x "$datei"
            echo "$datei wurde ausführbar gemacht."
        else
            echo "Warnung: Die Datei '$datei' wurde nicht gefunden."
        fi
    fi

    # Generierten Codeblock erstellen
    code_block=$(cat <<EOF

$marker
elif [ "\$auswahl" == "$(echo "$neue_auswahl" | cut -d')' -f1)" ]; then
    if [ -f "$datei" ]; then
        ./\"$datei\"
        echo "\"$datei\" wurde ausgeführt."
    else
        echo "Datei \"$datei\" nicht gefunden!"
    fi
fi

EOF
)

    # Marker prüfen; falls nicht vorhanden, hinzufügen
    if ! grep -q "$marker" "$TARGET_FILE"; then
        echo "$marker" >> "$TARGET_FILE"
        echo "Marker '$marker' wurde am Ende von $TARGET_FILE hinzugefügt."
    fi

    # Codeblock an Stelle des Markers einfügen/ersetzen
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
