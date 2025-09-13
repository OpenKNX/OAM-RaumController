## **Applikationsbeschreibung RaumController**

Die vorliegende Applikation kombiniert alle notwendigen Module, um die Steuerung und Automatisierung von einem Raum im Haus zu ermöglichen. Die einzelnen Module haben jeweils eigene Applikationsbeschreibungen. Das Vorliegende Dokument gibt nur einen Gesamtüberblick, stellt eine Änderungshistorie zur Verfügung und stellt die Links auf die Applikationsbeschreibungen der einzelnen Module bereit.

Diese Applikation ist eine Weiterentwicklung vom [Sensormodul](https://github.com/OpenKNX/OAM-Sensormodul). Sie ist Update-Kompatibel und kann direkt als [Update von der Version 4.x](#update-vom-sensormodul-4x) vom Sensormodul verwendet werden.

### **Funktionsübersicht**


## **Änderungshistorie**

Im folgenden werden Änderungen an der Applikation erfasst, damit man nicht immer das Gesamtdokument lesen muss, um Neuerungen zu erfahren. Dabei wird primär auf Änderungen in den beteiligten Modulen hingewiesen. Detailänderungen können dann in den jeweiligen Applikationsbeschreibungen nachgelesen werden.

15.10.2025: Firmware 5.0, Applikation 5.0:

- NEU: Erste Version 5.0 vom RaumController
- NEU: Common in der Version 1.4 zugefügt
- NEU: Netzwerk in der Version 0.5 zugefügt
- NEU: Konfigurationstransfer in der Version 0.4 zugefügt
- NEU: Sensoren in der Version 4.9 zugefügt
- NEU: 1-Wire in der Version 2.0 mit 30 Kanälen zugefügt
- NEU: Präsenzmeler in der Version 3.8 mit 16 Kanälen zugefügt
- NEU: Jalousiesteuerung in der Version 0.3 mit 3 Kanälen zugefügt
- NEU: Virtuelle Taster in der Version 0.5 mit 10 Kanälen zugefügt
- NEU: Binäreingänge in der Version 0.2 mit 6 Kanälen zugefügt
- NEU: Analogeingänge in der Version 0.1 mit 4 Kanälen zugefügt
- NEU: Zähler in der Version 0.5 nut 10 Kanälen zugefügt
- NEU: Zustandsautomaten in der Version 0.5 mit 5 Kanälen zugefügt
- NEU: Logiken in der Version 3.7 mit 99 Kanälen zugefügt
- NEU: Funktionsblöcke in der Version 0.6 mit 10 Kanälen zugefügt

## **Im RaumController verwendete Module**

Die folgenden Module werden von der RaumController Applikation verwendet. Diese Zusammenstellung bietet alle notwendigen Teile, um einen Raum in einem Haus zu steuern und zu automatisieren. 

Die RaumController Firmware kann auf vielerlei verschiedener Hardware laufen, die unterschiedliche Hardwareeigenschaften hat. Somit muss nicht jede Hardware alle hier aufgeführten Module unterstützen. Hat die Hardware beispielsweise keine Binäreingänge, kann und wird das Binäreingangsmodul nicht funktionieren. Die hier aufgeführte Modulliste ist auch in der Applikation zu finden und dort kann man auch Module, die nicht unterstützt werden, passend ausblenden.

### **OpenKNX**

Dies ist eine Seite mit allgemeinen Parametern, die unter [Applikationsbeschreibung-Common](https://github.com/OpenKNX/OGM-Common/blob/v1/doc/Applikationsbeschreibung-Common.md) beschrieben sind. 

### **Netzwerk**

Der RaumController kann auch auf einem KNX-IP-Gerät laufen. Dazu sind auch IP-Einstellungen notwendig, die von diesem Modul bereitgestellt werden. Beschrieben ist das in der [Applikationsbeschreibung-Netzwerk](https://github.com/OpenKNX/OFM-Network/blob/v1/doc/Applikationsbeschreibung-Netzwerk.md)

### **Konfigurationstransfer**

Der Konfigurationstransfer erlaubt einen

* Export von Konfigurationen von OpenKNX-Modulen und deren Kanälen
* Import von Konfigurationen von OpenKNX-Modulen und deren Kanälen
* Kopieren der Konfiguration von einem OpenKNX-Modulkanal auf einen anderen
* Zurücksetzen der Konfiguration eines OpenKNX-Modulkanals auf Standardwerte

Die Funktionen vom Konfigurationstransfer-Modul sind unter [Applikationsbeschreibung-ConfigTransfer](https://github.com/OpenKNX/OFM-ConfigTransfer/blob/v1/doc/Applikationsbeschreibung-ConfigTransfer.md) beschrieben.

### **Sensoren**

Das Modul Sensoren unterstützt die Messung verschiedenster Werte zum Raumklima (und auch mehr). Die Funktion ist beschrieben in der [Applikationsbeschreibung-Sensor](https://github.com/OpenKNX/OFM-SensorModule/blob/v1/doc/Applikationsbeschreibung-Sensor.md).

### **1-Wire**

Als weitere Sensorart werden auch 1-Wire-Sensoren unterstützt. Deren Funktion ist in der [Applikationsbeschreibung-Wire](https://github.com/OpenKNX/OFM-OneWireModule/blob/v1/doc/Applikationsbeschreibung-Wire.md) beschrieben.

### **Präsenzmelder**

Zu einem RaumController gehört auch die Auswertung von Präsenzmeldern. Bei der Verwendung mit passender Hardware - wie dem Presence-Multisensor von ab-tools - auch als echter Präsenzmelder, sonst als virtueller Präsenzmelder (VPM).

Die Funktionen des Präsenzmelder-Moduls sind unter [Applikationsbeschreibung-Präsenz](https://github.com/OpenKNX/OFM-PresenceModule/blob/v1/doc/Applikationbeschreibung-Praesenz.md) beschrieben.

### **Jalousiesteuerung**

Auch eine Jalousiesteuerung darf in einem RaumController nicht fehlen. Dieses Modul ist in der [Applikationsbeschreibung-ShutterController](https://github.com/OpenKNX/OFM-ShutterControllerModule/blob/v1/doc/Applikationsbeschreibung-ShutterController.md) beschrieben.

### **Virtuelle Taster**

Ebenso wie virtuelle Präsenzmelder werden auch virtuelle Taster von der RaumController-Applikation angeboten. Wenn auch Binäreingänge in Hardware vorhanden sind - wie dem Sensormodul v4.2 von SmartMF - können es auch echte Taster werden.

Die Funktionen des Tastermoduls sind unter [Applikationsbeschreibung-Taster](https://github.com/OpenKNX/OFM-VirtualButton/blob/v1/doc/Applikationsbeschreibung-Taster.md) beschrieben.

### **Binäreingänge**

Die RaumController-Applikation unterstützt auch Binäreingänge, z.B. vom Sensormodul v4.2 von SmartMF oder beim Präsenz-Multisensor von AB-Tools.

Die Funktionen der Binäreingänge sind unter [Applikationsbeschreibung-Binäreingang](https://github.com/OpenKNX/OFM-BinaryInput/blob/v1/doc/Applikationsbeschreibung-Binaereingang.md) beschrieben.

### **Analogeingänge**

Auch Analogeingänge werden unterstützt, z.B. vom Sensormodul v4.2 von SmartMF.

Die Funktionen der Analogeingänge sind unter [Applikationsbeschreibung-ADC-Eingang](https://github.com/OpenKNX/OFM-ADCInput/blob/main/doc/Applikationsbeschreibung-ADC-Eingang.md) beschrieben.

### **Zähler**

In einem Raum will man auch Verbrauchsdaten erfassen und Zählen, um daraus Regeln für Automatismen abzuleiten. Das Zählermodul ist in der [Applikationsbeschreibung-Zaehler](https://github.com/OpenKNX/OFM-Meter/blob/v1/doc/Applikationsbeschreibung-Zaehler.md) beschrieben.

### **Zustandsautomaten**

Regelbasierte Automatismen können sehr gut mit einem Zustandsautomaten abgebildet werden. Dessen Funktion ist beschrieben in der [Applikationsbeschreibung-DFA](https://github.com/OpenKNX/OFM-DFA/blob/v1/doc/DFA_Applikationsbeschreibung.md) beschrieben.

### **Logiken**

Wie die meisten OpenKNX-Applikationen enthält auch die RaumController-Applikation ein Logikmodul.

Die Funktionen des Logikmoduls sind unter [Applikationsbeschreibung-Logik](https://github.com/OpenKNX/OFM-LogicModule/blob/v1/doc/Applikationsbeschreibung-Logik.md) beschrieben.

### **Funktionsblöcke**

Kompliziertere logische Funktionen, die nur sehr aufwändig mit dem Logikmodul zu realisieren wären, sind als Funktionsblöcke verfügbar. Das Modul ist in der [Applikationsbeschreibung-Function](https://github.com/OpenKNX/OFM-FunctionBlocks/blob/v1/doc/Applikationsbeschreibung-FunctionBlocks.md) beschrieben.


## **Update vom Sensormodul 4.x**

Der RaumController ist eine updatefähige Applikation zum Sensormodul 4.x, das ist auch der Grund, warum die erste Version vom RaumController 5.0 ist, das ist eines der Update-Kriterien der ETS.

Da die neue Applikation aber viele Änderungen beinhaltet, sind auch Vorarbeiten im Sensormodul **vor** den Update notwendig.

Als erstes (wie be jedem Update einer Applikation): Projekt exportieren, damit man einen Weg zurück hat.

Anschließend kann man das Gerät mit der Version 4.x kopieren - dann kann man nach dem Update vergleichen, falls sich irgendwas anders verhält.

Wenn man im Sensormodul 4.x mehr als 16 Kanäle für Präsenzmelder verwendet hat: Kanalanzahl auf 16 reduzieren. Die Definitionen für Kanäle >16 kann man mit dem Konfigurationstransfer->Kanalkopie auf Kanäle <= 16 übertragen, falls man Lücken gelassen hat. Ansonsten sollte man diese Kanäle auf ein anderes Gerät übertragen oder sie gehen verloren.

Wenn man im Sensormodul 4.x mehr als 10 Kanäle für Virtuelle Taster verwendet hat: Kanalanzahl auf 10 reduzieren. Die Definitionen für Kanäle >10 kann man mit dem Konfigurationstransfer->Kanalkopie auf Kanäle <= 10 übertragen, falls man Lücken gelassen hat. Ansonsten sollte man diese Kanäle auf ein anderes Gerät übertragen oder sie gehen verloren.

Ferner haben sich einige KO-Nummern verschoben. Das ist unkritisch, die entsprechenden GA-Verknüpfungen bleiben erhalten. Falls allerdings in Logiken Eingänge mit internen KO-Verknüpfungen genutzt wurden, muss man schauen, ob die jetzt noch auf die KO-Nummern zeigen, die man erwartet. Dazu ist ein Vergleich mit dem zu Anfang Kopierten Sensormodul angeraten.

> ***Tipp:*** Referenzen auf KO-Nummern im Logikmodul können leicht auf der Seite "*Übersicht interne Verknüpfungen*" angepasst werden.


Folgende KO-Nummern haben sich verschoben:

**Änderung von zentralen KO-Nummern (in Common):**


| KO                               | alt | NEU (in 5.0) | Kommentar                                |
|----------------------------------|-----|----------------|------------------------------------------|
| In Betrieb                       | 1   | 1              | (unverändert)                            |
| **Uhrzeit**                      | 2 * | 2              | KO war bislang geteilt mit Uhrzeit/Datum |
| Datum                            | 3   | 3              | (unverändert)                            |
| **Uhrzeit/Datum**                | 2 * | 4              | Separiert von KO 2 Uhrzeit.              |
| **Sommerzeit aktiv**             | 10  | 5              |                                          |
| **Speichern**                    | 11  | 6              |                                          |
| Diagnose                         | 7   | 7              | (unverändert)                            |
| **Urlaub**                       | 4   | 15             |                                          |
| **Welcher Feiertag ist heute?**  | 5   | 16             |                                          |
| **Welcher Feiertag ist morgen?** | 6   | 17             |                                          |
| **LED sperren**                  | 8   | 18             | (nicht in allen Applikationen vorhanden) |
| **Buzzer sperren**               | 9   | 19             | (nicht in allen Applikationen vorhanden)        |


\*: Doppelbelegung der KO-Nummer. Einblendung war abhängig von Konfiguration.

**Alle KO vom Virtuellen Taster haben sich verschoben:**
- Beginn der KO-Nummern vom Virtuellen Taster beim Sensormodul 4.x: 1220
- Beginn der KO-Nummern vom Virtuellen Taster beim RaumController 5.0: 610

Somit hat sich jede KO-Nummer um den Wert -610 verschoben.


Nach dem Update heißt das Gerät in der ETS nicht mehr Sensormodul sondern RaumController, aber nur, wenn man im Eigenschaften-Fenster vom Gerät den Namen nicht geändert hat - er also auf Sensormoul stand.
Leider kennt die ETS für ein Gerät nur einen Standrard-Namen. Hat man also mehrere Geräte mit dem Standardnamen "Sensormodul" und hat nur ein Gerät auf RaumController aktualisiert, so heißen spätestens nach einem Neuladen des Projektes **alle** früheren "Sensormodul"-Geräte jetzt RaumController.
Das bedeutet nicht, dass alle diese Geräte aktualisiert worden sind! Nur der angezeigte Namen wird vom neusten Gerät übernommen.
Wenn man sowieso alle Sensormodule aktualisieren will, ist das kein Problem. Sollte man noch Sensormodule behalten wollen (weil man z.B. mehr als 16 Präsenzkanäle braucht), dann kann man den alten Namen bekommen, indem man bei den Eigenschaften als Name wieder "Sensormodul" eintippt.






