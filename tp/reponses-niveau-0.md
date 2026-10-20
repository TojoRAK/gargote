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


### 0.3 Interroger l'API à la main
- a) Liste des soupes :  HTTP/1.1 200 OK
```json

[
    {
        "id": 7,
        "nom": "Mi sao",
        "prix": 6500,
        "id_categorie": 2,
        "categorie": "Soupe"
    },
    {
        "id": 6,
        "nom": "Soupe chinoise",
        "prix": 6000,
        "id_categorie": 2,
        "categorie": "Soupe"
    }
]
```
- b) Création d'un plat valide : HTTP/1.1 201 Created
```json
{
    "id": 13,
    "nom": "Mofo gasy",
    "prix": 300,
    "id_categorie": 1
}

```

- c) Création d'un plat invalide : HTTP/1.1 422 Unprocessable Content

```json
{
    "message": "Données invalides.",
    "errors": {
        "nom": "Le nom du plat est obligatoire.",
        "prix": "Le prix doit être un nombre entier (en Ariary).",
        "id_categorie": "Choisissez une catégorie."
    }
}
```
- d) Suppression d'un plat présent dans une commande : HTTP/1.1 409 Conflict
```json
{
    "message": "Ce plat figure déjà dans des commandes, il ne peut pas être supprimé.",
    "errors": {}
}
```

- e) Une commande qui n'existe pas : HTTP/1.1 404 Not Found
```json
{
    "message": "Commande 999 introuvable.",
    "errors": {}
}
```

5. Pour la requête b, on obtient 201 car il s'agit d'une création
6. C'est PHP qui transforme le blocage en 409 : 
```php
return $this->erreur('Ce plat figure déjà dans des commandes, il ne peut pas être supprimé.', 409);
```

7. Creation de commande
```bash
curl -X POST http://localhost:8080/api/commandes \
     -H "Content-Type: application/json" \
     -d '{
     "numero_table":4,
            "lignes":
                [
            {"id_plat": 4, "quantite": 2},
            {"id_plat": 10, "quantite": 1}
            ]}'
```
### 0.4 Suivre une requête de bout en bout

| # | Étape | Fichier | Fonction / ligne |
|---|---|---|---|
| 1 | Le formulaire est soumis | `components/PlatForm.vue` | `enregistrer()` |
| 2 | La requête HTTP est construite | `api.js` | `requete()` |
| 3 | Vite transmet `/api/...` au port 8080 | `vite.config.js` | `lignes 10 -11` |
| 4 | CodeIgniter choisit le contrôleur | `app/Config/Routes.php`| `ligne 20` |
| 5 | Le contrôleur lit le JSON | `backend/app/Controllers/Api/Plats.php` | `create()` : `$this->donneesJson()` |
| 6 | Les règles de validation sont vérifiées | `backend/app/Models/PlatModel.php` | `$validationRules`, lors de `insert()` |
| 7 | La ligne est insérée | `backend/app/Controllers/Api/Plats.php` | `create()` : `$this->plats->insert($donnees)` |
| 8 | Le formulaire prévient l’écran parent | `frontend/src/components/PlatForm.vue` | `enregistrer()` : `emit('enregistre', resultat)` |
| 9 | L’écran recharge la liste | `frontend/src/views/CarteView.vue` | `surEnregistrement()` : `await charger()` |