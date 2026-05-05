# Sant Jordi Jam 2026 - Tota pedra fa paret

Aquest és el repositori compartit per avançar amb el projecte de joc de cara a la [Sant Jordi Jam 2026](https://itch.io/jam/sant-jordi-jam-2026), juntament amb col·laboradors.

El joc ja es troba publicat! El podeu trobar [aquí](https://gromans.itch.io/roc-a-roc), tal i com el vam mostrar a la presentació de la Jam.

## Full de ruta per a la versió 1.1

- [ ] Arreglar el gir de les peces globalment
    - [ ] Millorar el gir de les peces amb el ratolí
    - [ ] Refactoritzar + unificar la lògica de les peces a tot el joc:
        - [ ] Crear la classe abstracta "Peça", heretant de Recurs
        - [ ] Crear dos nodes físics que utilitzin la "Peça" per implementar la funcionalitat "arrossegable" i, d'altra banda, "caiguda"+"col·lisions".
        - [ ] Implementar els girs en els TileMaps de les peces (concretament, en el moment que s'uneixen peces al taller i quan es fan girs al tetris).
- [ ] El diàleg dels personatges s'hauria de resetejar al final de cada partida!
- [ ] Afegir crèdits
- [ ] Afegir controls de volum i sfx
- [ ] Afegir un highlight a les caselles del taller quan es vagi a arrossegar
- [ ] Millorar la interfície del diàleg (es trepitja amb la campaneta)
- [ ] Afegir un mini tutorial
- [ ] Bug: de vegades la música s'atura entre partides?

