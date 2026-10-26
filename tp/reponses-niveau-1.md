### 1.1 Script de migration
1. Je choisis date_jour comme ça il ne peut pas y avoir deux fois la meme date dans la table.

2. Avec la colonne `est_plat_du_jour`, on perd : 
    - les plats proposés les jours d'avant
    - 

### 1.2  Données de test
3. 
    - Plat à 0Ar : ERROR:  new row for relation "plat" violates check constraint "chk_prix_plat"
DÉTAIL : Failing row contains (17, TEST, 0, 1, null, t).
    - Plat dont le nom existe : ERROR:  duplicate key value violates unique constraint "chk_unique_nom_plat"
    DÉTAIL : Key (nom)=(Romazava) already exists.


### 1.5 Le plat du jour

4. R2 renvoie 409 car il s'agit d'un conflit avec l'état actuel : plat indisponible

5. Pour gérer ce problème on peut supprimer le plat du jour actuel et ne pas avoir de plat du jour et proposer à Bao un autre plat