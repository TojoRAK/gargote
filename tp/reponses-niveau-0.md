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

### 0.5 Repérer les notions de Vue


| Notion | À quoi ça sert | Votre exemple |
|---|---|---|
| `ref()` | une variable réactive dont le changement met l’écran à jour | `views/CarteView.vue ligne 7` : `plats` est réactif ; quand sa valeur change, la liste affichée est mise à jour |
| `computed()` | une valeur calculée à partir d’autres, recalculée automatiquement | `components/Panier.vue ligne 11` : Le total est recalculé à chaque ajout et suppression de ligne |
| `v-for` | répéter un élément pour chaque élément d’une liste | `components/Panier.vue ligne 21` : parcourt les lignes du panier |
| `v-if` / `v-else` | afficher un élément seulement si une condition est vraie | `components/Panier.vue lignes 17 et 19` : affiche un message si le panier est vide, sinon la liste |
| `v-model` | lier un champ de formulaire à une variable, dans les deux sens | `views/CommandeView.vue ligne 74` : lie le champ de numéro de table à `numeroTable` |
| `defineProps` | recevoir des données du composant parent | `components/Panier.vue ligne 5` : reçoit la liste `lignes` |
| `defineEmits` / `emit` | envoyer un événement au composant parent | `components/Panier.vue ligne 8` : déclare `plus` et `moins`, émis dans les boutons |
| `onMounted` | exécuter du code quand le composant apparaît | `views/CommandeView.vue ligne 13` : charge les plats à l’affichage |

9. `Panier.vue` ne modifie jamais la quantité, c'est CommandeView qui la modifie

10. `watch` surveille la modification des plats. Sans watch, il faudrait rafraichir la page pour voir les modifications

### 0.6 Premières modifications

- a) Le nom de la gargote a été modifié dans `frontend/src/App.vue`, ligne 22 :
  `Gargote Milay, Andoharanofotsy`.

- b) La catégorie a été ajoutée directement en SQL :

```sql
INSERT INTO categorie (libelle) VALUES ('Goûter');
```

La liste des catégories est fournie par la route `GET /api/categories`, déclarée
dans `backend/app/Config/Routes.php` et traitée par `Categories::index()`.
Dans `frontend/src/views/CarteView.vue`, la fonction `charger()` appelle
`api.categories.lister()`, puis transmet le résultat à `PlatForm.vue` avec la
prop `categories`. Le formulaire génère ensuite automatiquement une option
avec `v-for` dans `PlatForm.vue`. Après rechargement, *Goûter* apparaît donc
dans la liste déroulante sans modification du code Vue.
