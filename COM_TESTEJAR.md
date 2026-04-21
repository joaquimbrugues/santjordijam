# Com testejar aquest joc

El joc té uns quants paràmetres que es poden ajustar a l'hora de personalitzar l'experiència de joc.
Els paràmetres es poden trobar a:

1. L'escena **Nivell**: Hi ha els paràmetres
    - Interval Tic: El temps mínim entre dos moviments consecutius de la jugadora
    - Interval Caiguda: El temps entre dos moviments de caiguda de la peça
    - Interval Caiguda Accelerat: El temps entre dos moviments de caiguda de la peça quan la jugadora està accelerant la peça (prement 'avall')
    - Interval Caiguda Frenat: El temps entre dos moviments de caiguda de la peça quan la jugadora està frenant la peça (prement 'amunt')
    - Sensibilitat Moviment: Durant quants mil·lisegons cal prèmer dreta, esquerra o gir per produir realment un moviment
    - Files Alçada Final: Quantes files es poden completar com a màxim en un nivell abans que acabi el joc
    - Files Per Punt: Quantes files cal completar per rebre un punt (mitja estrella)

2. L'escena **Peça**: Hi ha els paràmetres
    - Entrada X: La posició (horitzontal) d'entrada de la peça quan comença a caure
    - Entrada Y: L'alçada d'entrada de la peça quan comença a caure.

3. L'escena **Stamina**, dins de Nivell: hi ha els paràmetres
    - Tics Frenada: Nombre de tics (de durada Interval Caiguda Frenat) que pot durar la frenada com a màxim.
    - Tics Recuperació Frenada: Nombre de tics (de durada Interval Caiguda) que trigarà la barra d'stamina a recuperar-se completament. *(Només es fa servir per calcular el temps en segons de recuperada, per tant si la jugadora està prement accelerar la recuperació d'stamina NO s'accelerarà)*

4. El Timer **RetardReset**: Controla els segons entre que es diposita una peça i entra la primera peça de la cua. Es pot ajustar el Wait Time
