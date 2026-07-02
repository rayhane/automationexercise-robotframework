# AutomationExercise — Robot Framework (version organisée)

## Structure

```
AutomationExercise_v2/
├── resources/
│   ├── variables.resource   # Données de test (nom, email, mot de passe, adresse, produit...)
│   └── keywords.resource    # Locators + keywords métier réutilisables
└── tests/
    ├── signup.robot         # TC01 à TC04 (inscription)
    ├── add_product.robot    # TC05 à TC07 (ajout au panier)
    └── cart.robot            # TC08 à TC10 (contenu du panier)
```

## Ce qui a changé par rapport à la version d'origine

- **Locators** : strictement identiques (aucune valeur modifiée).
- **`keywords.resource`** : les actions Selenium (Input Text, Click Button,
  Select Checkbox...) sont regroupées en keywords nommés par étape logique
  (`Remplir Nom Et Email Inscription`, `Selectionner Date De Naissance`,
  `Completer Formulaire Compte Complet`, etc.) au lieu d'être écrites
  directement dans les tests.
- **`tests/`** : les deux anciens fichiers `singup.robot` et `continue.robot`
  (qui contenaient un TC04 en double, un incomplet et un complet) sont
  **fusionnés en un seul fichier `signup.robot`** avec 4 tests clairs et sans
  doublon.
- Ajout de **tags** (`signup`, `positive`, `negative`, `end-to-end`) pour
  pouvoir filtrer l'exécution.
- Ajout de **`[Documentation]`** sur chaque test et keyword.

## Nouveaux tests : Add to cart / Cart

- **`add_product.robot`** (TC05-TC07) : ajout d'un produit au panier depuis
  la page produits, gestion de la fenêtre modale "Added!" ("Continue
  Shopping" / "View Cart").
- **`cart.robot`** (TC08-TC10) : vérifie le contenu du panier (produit
  présent, quantité correcte), puis le supprime. Le panier est préparé
  **une seule fois** en `Suite Setup` (`Preparer Panier Avec Un Produit`) —
  les 3 tests s'exécutent donc dans l'ordre et dépendent les uns des autres
  (TC10 supprime le produit, il doit passer en dernier).
- Le produit testé (`${id_produit}` = 1, `${nom_produit}` = "Blue Top") est
  défini dans `variables.resource` : à ajuster si le catalogue du site
  change.

## Exécution

```bash
robot --outputdir results tests/signup.robot
```

Filtrer par tag :

```bash
robot --outputdir results --include positive tests/signup.robot
robot --outputdir results --include negative tests/signup.robot
```
