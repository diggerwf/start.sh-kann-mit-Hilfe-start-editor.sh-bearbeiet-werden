#!/bin/bash

# Nach dem Dateinamen fragen
read -p "Bitte gib den Namen der Datei ein, die du analysieren möchtest: " datei_name

# Überprüfen, ob die Datei existiert
if [ ! -f "$datei_name" ]; then
    echo "Die Datei '$datei_name' wurde nicht gefunden."
    exit 1
fi

# Arrays für Scripts und Beschreibungen
declare -a scripts
declare -a beschreibungen

index=1

echo "Analysiere die Datei und finde verfügbare Optionen..."

# Datei Zeile für Zeile lesen
while IFS=: read -r script pfad; do
    # Zeilen überspringen, wenn leer oder Kommentar
    if [[ -z "$script" || "$script" =~ ^# ]]; then
        continue
    fi

    # Speichern der Daten in Arrays
    scripts[$index]=$script
    beschreibungen[$index]=$pfad

    # Ausgabe der Beschreibung mit Nummer
    echo "$index) $pfad"

    ((index++))
done < "$datei_name"

# Anzahl der gefundenen Optionen
anzahl=$((index - 1))

if [ "$anzahl" -eq 0 ]; then
    echo "Keine gültigen Optionen in der Datei gefunden."
    exit 0
fi

# Nutzer zur Auswahl auffordern
read -p "Bitte wähle eine Option (1-$anzahl): " auswahl

# Validierung der Eingabe
if ! [[ "$auswahl" =~ ^[0-9]+$ ]] || [ "$auswahl" -lt 1 ] || [ "$auswahl" -gt "$anzahl" ]; then
    echo "Ungültige Auswahl."
    exit 1
fi

# Das gewählte Script ausführen
gewähltes_script="${scripts[$auswahl]}"
pfad="${beschreibungen[$auswahl]}"

if [ -f "$gewähltes_script" ]; then
    chmod +x "$gewähltes_script"
    ./"$gewähltes_script"
else
    echo "Das Script '$gewähltes_script' wurde nicht gefunden."
fi

echo "Aktion abgeschlossen."
