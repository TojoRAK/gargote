### 0.2. Lire le schéma relationnel
1. Schéma
- categorie(**id**, libelle)
- plat(**id**, nom, prix, #id_categorie)
- commande(**id**, date_commande, numero_table)
- commande_ligne(**id**, #id_commande, #id_plat, quantite, prix_unitaire)

2. commande_ligne contient prix_unitaire car s'il y a modification du prix du plat, tous les prix utilisés dans les anciennes commandes seront modifiées sans la colonne prix_unitaire.

3. Quand on supprime une commande, on doit aussi supprimer les lignes dans commande_ligne. CASCADE est responsable de cette manipulation

4.
- On peut insérer des prix négatifs
- On peut insérer plats identiques
- Plusieurs commandes à une même

