# Tourdeappka NodeJS API server
(c) 2023 Matyáš Caras a Richard Pavlikán

## Požadavky
- [NodeJS](https://nodejs.org) LTS verze (16+)
- [pnpm](https://pnpm.io)

## Jak spustit
1. Nainstaluj NodeJS
2. Nainstaluj pNPM
3. Stáhni repozitář
4. Nainstaluj závislosti (`pnpm i`)
### K vývoji
5. Vytvoř soubor `.env`:
```js
FIREBASE_KEY=klic
FIREBASE_AUTH=nejakaurl
FIREBASE_ID=idcko
FIREBASE_STORAGE=nejakaurl
FIREBASE_MESSAGING=idcko
FIREBASE_APPID=idcko
```
6. Spusť pomocí `pnpm run dev`
### Live server
5. Ulož proměnné dle předchozí struktury jako systémové proměnné
6. Spusť pomocí `pnpm start`