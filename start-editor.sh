#!/bin/bash

TARGET_FILE="start.sh"

# Funktion zum Anzeigen des Menüs
show_menu() {
    echo "Was möchtest du tun?"
    echo "1) Zeile hinzufügen"
    echo "2) Zeile bearbeiten"
    echo "3) Zeile löschen"
    echo "4) Beenden"
}

# Funktion zum Hinzufügen einer Zeile
add_line() {
    read -p "Gib die Zeile ein, die du hinzufügen möchtest: " new_line
    echo "$new_line" >> "$TARGET_FILE"
    echo "Zeile hinzugefügt."
}

# Funktion zum Bearbeiten einer Zeile
edit_line() {
    mapfile -t lines < "$TARGET_FILE"
    echo "Aktuelle Zeilen:"
    for i in "${!lines[@]}"; do
        printf "%d) %s\n" "$i" "${lines[$i]}"
    done
    read -p "Welche Zeilennummer möchtest du bearbeiten? " index
    if [[ "$index" =~ ^[0-9]+$ ]] && [ "$index" -ge 0 ] && [ "$index" -lt "${#lines[@]}" ]; then
        read -p "Neue Zeile: " new_content
        lines[$index]="$new_content"
        printf "%s\n" "${lines[@]}" > "$TARGET_FILE"
        echo "Zeile aktualisiert."
    else
        echo "Ungültige Nummer."
    fi
}

# Funktion zum Löschen einer Zeile
delete_line() {
    mapfile -t lines < "$TARGET_FILE"
    echo "Aktuelle Zeilen:"
    for i in "${!lines[@]}"; do
        printf "%d) %s\n" "$i" "${lines[$i]}"
    done
    read -p "Welche Zeilennummer möchtest du löschen? " index
    if [[ "$index" =~ ^[0-9]+$ ]] && [ "$index" -ge 0 ] && [ "$index" -lt "${#lines[@]}" ]; then
        unset 'lines[index]'
        printf "%s\n" "${lines[@]}" > "$TARGET_FILE"
        echo "Zeile gelöscht."
    else
        echo "Ungültige Nummer."
    fi
}

# Hauptschleife
while true; do
    show_menu
    read -p "Wähle eine Option (1-4): " choice

    case $choice in
        1)
            add_line
            ;;
        2)
            edit_line
            ;;
        3)
            delete_line
            ;;
        4)
            echo "Beende den Editor."
            break
            ;;
        *)
            echo "Ungültige Wahl. Bitte versuche es erneut."
            ;;
    esac

    echo ""
done
