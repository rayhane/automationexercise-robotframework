*** Settings ***
Documentation     Suite de tests "Cart" pour automationexercise.com.
...
...               Le panier est préparé une seule fois en Suite Setup
...               (via "Preparer Panier Avec Un Produit"), puis chaque test
...               vérifie une facette différente du panier.
...
...               TC08 : le produit ajouté apparaît bien dans le panier
...               TC09 : la quantité affichée est correcte
...               TC10 : suppression du produit -> panier vide
...
...               ATTENTION : ces tests dépendent les uns des autres et
...               doivent s'exécuter DANS L'ORDRE (TC10 supprime le produit
...               ajouté en Suite Setup, donc il doit passer en dernier).

Library           SeleniumLibrary
Resource          ../resources/keywords.resource
Resource          ../resources/variables.resource

Suite Setup       Preparer Panier Avec Un Produit
Suite Teardown    Fermer le Navigateur
Test Setup        Aller Au Panier Depuis Le Menu

*** Test Cases ***
TC08 - Le panier contient le produit ajoute
    [Documentation]    Vérifie que le produit ajouté en Suite Setup est bien
    ...    visible dans le tableau du panier.
    [Tags]    cart    positive
    Le Panier Doit Contenir Le Produit    ${id_produit}    ${nom_produit}

TC09 - La quantite du produit est correcte
    [Documentation]    Vérifie que la quantité du produit dans le panier est 1
    ...    (un seul ajout a été fait).
    [Tags]    cart    positive
    ${quantite}=    Obtenir La Quantite Du Produit Dans Le Panier    ${id_produit}
    Should Be Equal As Strings    ${quantite}    1

TC10 - Supprimer le produit du panier
    [Documentation]    Supprime le produit du panier et vérifie que le
    ...    message "Cart is empty" s'affiche.
    [Tags]    cart    positive
    Supprimer Produit Du Panier    ${id_produit}
    Wait Until Element Is Visible    ${panier_vide_texte}    timeout=${time_out}
