# FTC in einem OAM aktivieren — Kurzfassung

Die Checkliste zum Nachbauen. Begründungen, Messwerte und die verworfenen Wege stehen in
[FTC-Integration.md](FTC-Integration.md) — **hier steht nur, was zu tun ist.**

Drei der sieben Schritte melden sich **nicht**, wenn man sie vergisst. Sie sind unten mit ⚠ markiert.

---

## 0. Branches prüfen

| Repo | Branch | warum |
|---|---|---|
| `OGM-Common` | `ec/v1dev-ec` | `OPENKNX_FTC_CONSOLE` / `_lineSink` gibt es auf `origin/v1` nicht |
| `OFM-FileTransferModule` | `ec/v1dev` | das Modul selbst (0.2.0) |
| `OFM-UsbExchange` | `ec/pr-littlefs-align-flash-sector-8MB-4MB` | nur bei 4MB/8MB: sonst ist `filesystem_size` nicht sektorausgerichtet und Dateien > 4 KB werden korrupt |
| `knx` | `ec/v1dev-ec` | **empfohlen, praktisch vorausgesetzt** — pinnt `tpuart#ec/1.3.0-beta.1`; nur dort gibt es die TPUart-Schalter aus Schritt 1. `origin/v1` zieht `tpuart#1.1.0`, wo keiner davon existiert. Der Bau dagegen ist nie getestet worden |
| `OFM-Network` | `ec/v1dev-ec` | **optional**, hat mit FTC nichts zu tun |

## 1. Build-Switches — `platformio.custom.ini`, Block `[custom]`

```ini
  ; --- OFM-FileTransferModule (FTC) -- see lib/OFM-FileTransferModule/doc/reference/flags.md ---
  -D OPENKNX_FTC_PROFILE_DEVICE        ; end-device profile: security + download + dirops + fastupload
  -D OPENKNX_FTC_CONSOLE               ; console tunnel (obj 160) -- read by OGM-Common Console.h, which never sees the module header, so it must be -D
  -D OPENKNX_FTC_DELTA_UPDATE          ; firmware as a patch against the running image; no profile sets it (it hangs on the board, not the device class)
  ; --- TPUart driver (pulled in by the knx stack) -- diagnostics reachable over the FTC console ---
  -D TPUART_NCN_TW_AUTORESET           ; NCN thermal-warning auto-heal via one guarded U_RESET; robustness, not diagnostics
  -D TPUART_BCU_HEALTH                 ; 'bcu' report shows BCU<Health> and the NCN error counters
  -D TPUART_BCU_REGISTER_INFO          ; 'bcu stat' NCN rails + chip identity; costs one identifyNcnChip() excursion at boot
```

⚠ Ohne Switch läuft FTM auf Stufe 0: elf Kommandos, **ohne jeden Zugriffsschutz**.
⚠ Die TPUart-Diagnose ist ohne ihre Switches wegkompiliert, ohne Meldung.
Nicht setzen auf einem normalen TP-Gerät: `OPENKNX_HW_BUSMON`, `TPUART_BUSMON_INTEGRITY`.

## 2. ETS-Share einbinden — in **jedes** Produkt-XML

```xml
<op:define prefix="FTM"
           share="../lib/OFM-FileTransferModule/src/FileTransfer.share.xml"
           noConfigTransfer="true"
           ModuleType="13">
  <op:verify File="../lib/OFM-FileTransferModule/library.json" ModuleVersion="%FTM_VerifyVersion%" />
</op:define>
```

`ModuleType` muss frei sein: `grep -oE 'ModuleType="[0-9]+"' src/<Produkt>.xml | sort -u`

## 3. ⚠ Platzierung erzwingen — sonst wird es ein eigener Reiter

Das `op:define` allein erzeugt einen Top-Level-Reiter „Datei-Transfer" statt eines Blocks in
`OpenKNX > Erweitert`. **Kein Fehler, keine Warnung.** `<generate />` in **jedem** Produkt-XML ersetzen:

```xml
<generate>
  <Dynamic>
    <Channel Id="%AID%_CH-BASE" Number="BASE" Name="BASE_Main" Text="OpenKNX" Icon="openknx" HelpContext="BASE-OpenKNX">
      <op:include href="../lib/OGM-Common/src/Common.share.xml" xpath="//ApplicationProgram/Dynamic/Channel/ParameterBlock[@Name='Basic']" prefix="BASE" />
      <ParameterBlock Id="%AID%_PB-nnn" Name="Extended" Text="Erweitert" Icon="format-list-text" HelpContext="BASE-OpenKNX">
        <op:include href="../lib/OGM-Common/src/Common.share.xml" xpath="//ApplicationProgram/Dynamic/Channel/ParameterBlock[@Name='Extended']/*" IsInner="true" prefix="BASE" />
        <op:include href="../lib/OFM-FileTransferModule/src/FileTransfer.share.xml" xpath="//Dynamic/Channel/ParameterBlock/*" IsInner="true" prefix="FTM" />
      </ParameterBlock>
      <op:include href="../lib/OGM-Common/src/Common.share.xml" xpath="//ApplicationProgram/Dynamic/Channel/*[not(self::ParameterBlock[@Name='Basic']) and not(self::ParameterBlock[@Name='Extended'])]" prefix="BASE" />
    </Channel>
    <!-- ab hier JEDES weitere Modul explizit, in op:define-Reihenfolge -->
    <op:include href="../lib/OFM-Network/src/Network.share.xml" xpath="//ApplicationProgram/Dynamic/*" prefix="NET" />
    ...
  </Dynamic>
</generate>
```

⚠ Damit ist die per-define-Schleife des Producers weg — **jedes** Modul muss aufgeführt werden, sonst
verschwindet dessen ETS-Seite kommentarlos. Ein später hinzugefügtes `op:define` braucht hier eine Zeile.
`Name="BASE_Main"`, nicht `Main`. `src/LocalApplication.xml` wird vom Producer **nicht** gelesen.

## 4. Versions-Pin + ApplicationVersion — `src/<Produkt>.conf.xml`

```xml
<op:config name="%FTM_VerifyVersion%" value="0.2" />
```

ApplicationVersion anheben (neue Parameter, geändertes Speicherlayout).

## 5. oknx bauen lassen — `scripts/Build-Release.ps1`, vor dem Preprocess

```powershell
$oknxDir = "lib/OFM-FileTransferModule/oknx"
if ($env:OPENKNX_SKIP_HOSTCLI -ne "1") {
    if (Test-Path (Join-Path $oknxDir "platformio.ini")) {
        pio run -d $oknxDir
        if (!$?) { Write-Host "oknx build failed" -ForegroundColor Red; exit 1 }
    } else {
        Write-Host "oknx project not found ($oknxDir)" -ForegroundColor Red
        exit 1
    }
}
```

⚠ Der Release-Hook von FTM **kopiert** nur, er baut nicht. Ohne diesen Block enthält das Release kein
Werkzeug — ohne Fehlermeldung. Der `else`-Zweig bricht deshalb ab, statt still zu überspringen.

`pio run` cross-baut **6 der 8 Ziele von jedem Host aus** (Linux x64/arm64/armhf, Windows x86/x64/arm64):
dafür zieht sich der Pre-Build-Hook ein projektlokales `zig` selbst nach. Nur die beiden macOS-Ziele
brauchen einen macOS-Host — sie laufen über host-clang und das Xcode-SDK, das sich nicht mitliefern lässt.

## 6. ⚠ `include/knxprod.h` neu erzeugen

```sh
openknxproducer create --HeaderFileName="include/knxprod.h" src/<Produkt>.xml
```

Sonst scheitert der Build mit `'ParamFTM_Security' was not declared in this scope`, obwohl die `.knxprod`
korrekt ist.

## 7. Prüfen

```sh
openknxproducer create src/<Produkt>.xml                 # "successful", kein "INCREASE YOUR"
grep -c ParamFTM_ include/knxprod.h                      # 4
pio run -e <env>                                         # SUCCESS

unzip -qo src/<Produkt>.knxprod -d /tmp/kp
grep -o 'Text="Datei-Transfer"' /tmp/kp/M-*/M-*_A-*.xml  # muss LEER sein
strings .pio/build/<env>/firmware.elf | grep -c "NCN Rails"   # > 0

oknx -i <Router-IP> <PA> info                            # Funktionen: ... Console ... Delta
```

Richtig ist: kein „Datei-Transfer"-Kanal, und „Zugriffsschutz Service & Wartung" als letzter Separator
innerhalb von „Erweitert". Weil der `Dynamic`-Nachbau alles neu auflistet, zusätzlich `ComObjectRef`,
`ParameterRef`, `Parameter` und `ParameterRefRef` gegen den Stand davor vergleichen — die dürfen sich
**nicht** ändern.

---

## Zum Schluss: der Zugriffsschutz ist ein Parameter

`OPENKNX_FTC_SECURITY` zu übersetzen schützt noch nichts. Die ETS-Vorgabe ist **„Immer erlaubt"**, also
offen. Die Stufe muss beim Inbetriebnehmen gesetzt werden.
