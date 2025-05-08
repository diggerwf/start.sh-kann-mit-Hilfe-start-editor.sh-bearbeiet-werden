#!/bin/bash

TARGET_FILE="start.sh"

# Funktion zum Anzeigen des Menüs
show_current_options() {
    echo "Aktuelle Optionen in $TARGET_FILE:"
    grep -E 'echo "[0-9]+\)' "$TARGET_FILE"
}

# Funktion zum Hinzufügen einer neuen Option
add_option() {
    read -p "Gib den Text für die neue Option ein (z.B. '3) Neue Funktion'): " new_option_line
    # Füge die neue Zeile am Ende der Datei hinzu
    echo "$new_option_line" >> "$TARGET_FILE"
    echo "Neue Option wurde hinzugefügt."
}

# Hauptmenü
while true; do
    show_current_options
    echo ""
    echo "Was möchtest du tun?"
    echo "1) Neue Option hinzufügen"
    echo "2) Beenden"
    read -p "Wähle eine Nummer (1-2): " choice

    case $choice in
        1)
            add_option
            ;;
        2)
            echo "Beendet."
            break
            ;;
        *)
            echo "Ungültige Eingabe. Bitte versuche es erneut."
            ;;
    esac
    echo ""
done
