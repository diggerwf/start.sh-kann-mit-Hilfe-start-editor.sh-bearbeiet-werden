#!/bin/bash

MENU_FILE="menu.sh"

# Funktion: Menü initialisieren oder aktualisieren
funktion_anzeigen() {
    echo "#!/bin/bash" > "$MENU_FILE"
    echo "while true; do" >> "$MENU_FILE"
    echo "echo \"Bitte wähle eine Option\":" >> "$MENU_FILE"
    echo "echo \"1) Beenden\"" >> "$MENU_FILE"
    echo "echo \"2) Update\"" >> "$MENU_FILE"
    # Hier kannst du weitere Optionen dynamisch hinzufügen
    # Beispiel: Wenn eine Variable gesetzt ist, Option hinzufügen
    if [ "$1" == "add_option" ]; then
        option_num=3
        option_text="$2"
        script_name="$3"
        echo "echo \"$option_num) $option_text\"" >> "$MENU_FILE"
        cat <<EOF >> "$MENU_FILE"
if [ "\$auswahl" == "$option_num" ]; then
    bash "$script_name"
fi
EOF
    fi
    # Ende der Schleife
    echo "read -p \"Wähle: \" auswahl" >> "$MENU_FILE"
    echo "case \$auswahl in" >> "$MENU_FILE"
    echo "1) exit;;" >> "$MENU_FILE"
    echo "2) bash update.sh;;" >> "$MENU_FILE"
    # Weitere Optionen hier hinzufügen...
    echo "*) echo \"Ungültige Wahl\";"; echo "esac;" >> "$MENU_FILE"
    echo "done" >> "$MENU_FILE"

    chmod +x "$MENU_FILE"
}

# Beispiel: Neue Option hinzufügen (z.B. Funktion für 'Neue Funktion')
# start-editor.sh add_option "Neue Funktion" "funktion.sh"

# Für den Anfang nur Standardmenü erstellen:
funktion_anzeigen

# Menü starten
./"$MENU_FILE"
