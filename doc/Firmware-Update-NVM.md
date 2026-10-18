# Firmware-Update und die gespeicherte Programmierung

Was beim Update auf eine Firmware mit dem aktuellen knx mit der gespeicherten Programmierung passiert —
Adresse, Applikation, Gruppenadressen — und woran man sieht, welcher Weg gelaufen ist. Übertragbar auf jedes
OAM. Wie es ausgeht, hängt vor allem davon ab, wie groß die Applikation im Verhältnis zum NVM ist; außerdem
von der Reihenfolge, in der ETS die Tabellen angelegt hat, und davon, ob sich die Applikationsversion ändert.

## Worum es geht

knx speichert die Programmierung als Abbild im NVM: vorne ein Kopf mit den Metadaten (Geräteobjekt, weitere
Objekte wie der cEMI-Server und je Tabelle Zustand, Zeiger, Größe), dahinter die Tabellen selbst. Mit dem
aktuellen knx (Abschnitt `ec/v2.6.0-beta.1` im knx-CHANGELOG) ändert sich das Format des Kopfs
(apiVersion 2 → 3): Ein Layout-Wort kommt dazu und der Datensatz für Application Program 2. Der
Metadatenblock wird dadurch **größer**, im Host-Test um 28 Byte.

Ein Gerät mit RaumController 5.6.1 (knx `609312e`) wird beim ersten Start mit der neuen Firmware
**migriert** und startet dabei einmal neu. Damit der größere Kopf Platz hat, muss die Tabelle direkt dahinter
umziehen.

Von 5.5.x kommend ändert sich zusätzlich die Applikationsversion (55h → 56h): Die Adresse bleibt, die Tabellen
werden verworfen und warten auf einen ETS-Download, wie bei jedem Wechsel der Applikation.

## Warum das gerade ein OAM trifft

ETS legt die Applikation **zuerst** an (`LdCtrlRelSegment`, MergeId 2, vor den Tabellen). Sie liegt also
direkt hinter den Metadaten und ist genau die Tabelle, die umziehen muss. Die Adressen wurden mit
`oknx -i <IP> busprop read <PA> <Objekt> 7` an zwei Geräten der Testlinie gelesen; die Größen ergeben sich aus
dem Abstand zur nächsten Tabelle:

| Gerät | Applikation (4) | Gruppenobjekte (3) | Adressen (1) | Zuordnungen (2) |
|---|---|---|---|---|
| RaumController 5.6 | 0058h, 21 708 Byte | 5524h, 2 720 Byte | 5FC4h | 5FC8h |
| NeoPixel 0.9 | 0058h, 43 768 Byte | AB50h, 3 704 Byte | B9C8h | B9D0h |

Ob die Applikation in einen anderen freien Block passt, hängt am NVM und am Projekt:

- **RaumController, RP2040/RP2350:** 49 152 Byte NVM (`KNX_FLASH_SIZE=0xC000`). Hinter der
  Gruppenobjekttabelle bleiben 24 636 Byte; davon gehen Adress- und Zuordnungstabelle ab (2 Byte je
  Gruppenadresse, 4 Byte je Zuordnung). Belegen beide zusammen mehr als rund 2 900 Byte, reicht der Rest
  nicht mehr für die 21 708 Byte der Applikation.
- **RaumController, ESP32 (REG1 LAN TP Base, REG1 LAN Base):** 65 536 Byte NVM (Partition `knx`). Der Rest
  reicht praktisch immer.
- **NeoPixel:** 102 400 Byte NVM (`KNX_FLASH_SIZE=0x19000`). Neben der Applikation bleiben rund 54 800 Byte,
  sie passt in einen freien Block.

## Was die Migration tut

Für jede Tabelle, die in den größeren Kopf hineinragt, in dieser Reihenfolge:

1. **Kopieren** in einen freien Block ihrer vollen Größe. Das alte Abbild bleibt dabei unverändert, bis der
   neue Kopf geschrieben ist.
2. **Am Platz nach oben schieben**, wenn es keinen solchen Block gibt: Alles vom ersten Block bis zur ersten
   Lücke, die den Zuwachs aufnimmt, rückt um den Zuwachs auf. Vorher wird der alte Kopf ungültig gemacht.
3. **Entladen**, nur wenn auch das nicht geht — also wenn kein einzelner freier Block so groß ist wie der
   Zuwachs (auf einem Koppler auch, wenn eine feste Tabelle im Weg liegt). Die Adresse bleibt, die entladene
   Tabelle wartet auf einen ETS-Download.

Danach wird der Kopf im neuen Format geschrieben, und das Gerät startet einmal neu.

In knx-Ständen vor dieser Korrektur (bis `2fa5a6d`, in keinem RaumController-Release) fehlte Schritt 2: Eine
Applikation, die nicht in den freien Rest passte, wurde entladen.

## Was man im Log sieht

Die Migrationsmeldungen stehen im seriellen Log des **ersten Starts nach dem Update**, direkt vor dem Neustart.
`NVM: older application …`, die OGM-Common-Zeile dazu und `NVM: api FFFF != 3` wiederholen sich bei jedem
Start, bis das Gerät neu programmiert ist.

| Meldung | Bedeutung |
|---|---|
| `NVM: migrating older image` | ein Abbild im alten Format wird übernommen |
| `No available non volatile memory!` | kein freier Block für die Kopie; es folgt Schritt 2 oder 3 |
| `NVM: tables pushed up in place` | Schritt 2 ist gelaufen |
| `NVM: no room to move a table, unloaded` | Schritt 3: eine Tabelle ist entladen (bei einem OAM die Applikation), ETS-Download nötig |
| `NVM: older application, tables not restored` | andere Applikationsversion, die Tabellen sind verworfen |
| `MAIN_ApplicationVersion changed, ETS has to reprogram the application!` | Applikation passt nicht zur Firmware (gemeldet von OGM-Common): folgt `NVM: older application …`, ist nur die Applikationsversion anders und die Adresse bleibt; folgt `NVM: not restored`, ist es eine andere Applikation, nichts wird übernommen, auch nicht die Adresse |
| `NVM: migrated` | neues Format geschrieben, es folgt ein Neustart |
| `NVM: legacy image does not fit, discarded` | das Abbild passte nicht zu dieser Firmware, das Gerät startet unkonfiguriert |
| `NVM: api FFFF != 3`, `NVM: not restored` | kein gültiges Abbild (leerer Speicher, verworfenes Abbild oder ein beim Schieben unterbrochener Start); das Gerät ist unkonfiguriert |

Nach dem Neustart zeigt `oknx -i <IP> <PA> info` den Ladezustand der Tabellen; `busprop read <PA> <Objekt> 5`
liefert ihn einzeln (01 = geladen).

## Stromausfall während der Migration

- **Beim Kopieren:** Das alte Abbild bleibt gültig, der nächste Start migriert noch einmal.
- **Beim Schieben:** Der Kopf ist schon ungültig, das Gerät startet **unkonfiguriert** und braucht Adresse und
  Download. Es startet nie mit halb verschobenen Tabellen, die als gültig gelesen würden.
- **Mitten im Schreiben eines Flash-Sektors** gilt das nicht: Muss ein Sektor dafür gelöscht werden, wird er
  erst gelöscht und dann neu geschrieben. Beim Kopieren und Schieben werden auch Sektoren neu geschrieben, die andere Tabellen enthalten.
  Beim Kopieren bleibt dabei der Kopf gültig, so dass eine dabei beschädigte Tabelle beim nächsten Start
  übernommen werden kann. Dieses Fenster hat jedes Schreiben in einen solchen Sektor, auch ein ETS-Download.

## Was davon geprüft ist

- **Host-Tests** HM-1.1 bis HM-1.13 in OAM-IP-Interface (`scripts/Test/host/stack/test_download.cpp`): TP-Gerät
  mit Maske 07B0, künstliches Abbild, 32 KB NVM, nachgebildeter OpenKNX-Flash-Treiber. Geprüft werden
  Kopieren, Schieben einer Applikation von 31 744 Byte mit Byte-Vergleich jeder Tabelle, volles NVM und
  Stromausfall nach jedem einzelnen Sektor-Schreibvorgang: beim Schieben ist das Gerät danach migriert oder
  unkonfiguriert, beim Kopieren immer konfiguriert mit unveränderten Tabellen.
- **Lage der Tabellen** an zwei echten Geräten gelesen (Tabelle oben).
- **Nicht geprüft:** die Migration der IP-Variante (REG1 LAN Base, Maske 57B0, mit dem KNXnet/IP-Objekt) und
  das Update eines echten RaumControllers mit großem Projekt.

## Zurück auf die ältere Firmware

RaumController 5.6.1 liest das neue Abbild nicht: Das Gerät startet unkonfiguriert und braucht wieder eine
physikalische Adresse und einen ETS-Download.
