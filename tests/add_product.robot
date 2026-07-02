*** Settings ***
Documentation     Suite de tests "Add to cart" pour automationexercise.com.
...
...               TC05 : ajout d'un produit au panier depuis la page produits
...               TC06 : "Continue Shopping" ferme la fenêtre modale
...               TC07 : "View Cart" depuis la modale redirige vers le panier

Library           SeleniumLibrary
Resource          ../resources/keywords.resource
Resource          ../resources/variables.resource

Suite Setup       Ouvrir Le Navigateur
Suite Teardown    Fermer le Navigateur
Test Setup        Naviguer Vers Produits

*** Test Cases ***
TC05 - Ajouter un produit au panier
    [Documentation]    Ajoute le produit de test au panier et vérifie que la
    ...    fenêtre modale de confirmation "Added!" s'affiche.
    [Tags]    cart    positive
    Ajouter Produit Au Panier Par Id    ${id_produit}
    Element Should Be Visible    ${modal_panier}
    Continuer Les Achats Depuis La Modale

TC06 - Continuer les achats apres ajout
    [Documentation]    Vérifie qu'après avoir cliqué sur "Continue Shopping",
    ...    la fenêtre modale se ferme et on reste sur la page produits.
    [Tags]    cart    positive
    Ajouter Produit Au Panier Par Id    ${id_produit}
    Continuer Les Achats Depuis La Modale
    Element Should Not Be Visible    ${modal_panier}
    Location Should Contain    products

TC07 - Aller au panier depuis la fenetre modale
    [Documentation]    Vérifie qu'après ajout, le lien "View Cart" de la
    ...    modale redirige bien vers la page panier.
    [Tags]    cart    positive
    Ajouter Produit Au Panier Par Id    ${id_produit}
    Aller Au Panier Depuis La Modale
    Location Should Contain    view_cart
    Le Panier Doit Contenir Le Produit    ${id_produit}    ${nom_produit}
