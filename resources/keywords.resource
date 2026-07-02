*** Settings ***
Library   SeleniumLibrary
Library   String
Resource   ../resources/variables.resource

*** Variables ***
# ============================================================
# LOCATORS - INCHANGES (non modifiés, tels que fournis à l'origine)
# ============================================================
${chp_name} =   //input[@placeholder="Name"]
${chp_email}=   //input[@data-qa="signup-email"]
${buton-submit}=  //button[@data-qa="signup-button" and text()="Signup"]

${radio-button}=   id=id_gender2
${password}=       id=password

${buttin days} =        id=days
${buttin months} =      id=months
${buttin years} =       id=years

${first_name} =        id=first_name
${last_name} =       id=last_name
${company} =         id=company
${Address} =         id=address1
${Country} =        id=country
${State} =          id=state
${City} =          id=city
${zipcode} =       id=zipcode
${num tel} =       id=mobile_number

${chk_newsletter} =    //input[@id="newsletter"]
${chk_optin} =         //input[@id="optin"]
${btn_create_account} =    //button[@class="btn btn-default"]

# ------------------------------------------------------------
# Navigation (menu)
# ------------------------------------------------------------
${lien_produits} =    //a[@href="/products"]
${lien_panier} =      //a[@href="/view_cart"]

# ------------------------------------------------------------
# Page Produits (/products) + fenêtre modale "Added!"
# ------------------------------------------------------------
# %s est remplacé dynamiquement par l'ID du produit (mot-clé "Replace String")
${ADD_TO_CART_BY_ID} =         xpath:(//a[@data-product-id='%s' and contains(@class,'add-to-cart')])[1]
${modal_panier} =              id=cartModal
${modal_lien_voir_panier} =    //div[@id="cartModal"]//a[contains(text(),"View Cart")]
${modal_continuer_achats} =    //div[@id="cartModal"]//button[contains(text(),"Continue Shopping")]

# ------------------------------------------------------------
# Page Panier (/view_cart)
# ------------------------------------------------------------
${table_panier} =        id=cart_info
${panier_vide_texte} =   //b[contains(text(),"Cart is empty")]
${CART_ROW_BY_ID} =      //tr[@id="product-%s"]
${CART_ROW_DESC} =       //tr[@id="product-%s"]//td[@class="cart_description"]//a
${CART_ROW_PRIX} =       //tr[@id="product-%s"]//td[@class="cart_price"]//p
${CART_ROW_QTE} =        //tr[@id="product-%s"]//td[@class="cart_quantity"]//button
${CART_ROW_TOTAL} =      //tr[@id="product-%s"]//td[@class="cart_total"]//p
${CART_ROW_SUPPR} =      //tr[@id="product-%s"]//td[@class="cart_delete"]//a


*** Keywords ***

# ════════════ SETUP / TEARDOWN ═══════════════════

Ouvrir Le Navigateur
    [Documentation]    Ouvre Chrome en navigation privée sur le site.
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys
    Call Method    ${options}    add_argument    --incognito
    Open Browser    ${url_base}    ${Browser}    options=${options}
    Maximize Browser Window
    Set Selenium Implicit Wait    ${time_out}

Fermer le Navigateur
    [Documentation]    Ferme le navigateur en fin de suite.
    Close Browser

Naviguer Vers Login
    [Documentation]    Va sur la page de login (contient aussi le formulaire signup rapide).
    Go To    ${url_login}

Naviguer Vers Signup
    [Documentation]    Va directement sur la page "Enter Account Information".
    Go To    ${url_singup}


# ════════════ ETAPE 1 : FORMULAIRE "NEW USER SIGNUP" ═══════════════════

Remplir Nom Et Email Inscription
    [Documentation]    Renseigne les 2 champs du formulaire d'inscription rapide.
    [Arguments]    ${nom}    ${email}
    Input Text    ${chp_name}    ${nom}
    Input Text    ${chp_email}    ${email}

Soumettre Formulaire Inscription Rapide
    [Documentation]    Clique sur le bouton "Signup".
    Click Button    ${buton-submit}

Verifier Message Erreur Champ Vide
    [Documentation]    Vérifie le message natif HTML5 "Please fill out this field."
    ...    affiché quand un champ obligatoire est laissé vide.
    [Arguments]    ${selecteur_css}    ${message_attendu}
    ${message}=    Execute Javascript
    ...    return document.querySelector("${selecteur_css}").validationMessage
    Should Be Equal    ${message}    ${message_attendu}


# ════════════ ETAPE 2 : FORMULAIRE "ENTER ACCOUNT INFORMATION" ═══════════════════

Selectionner Genre Et Mot De Passe
    [Documentation]    Choisit le genre (Mrs) et saisit le mot de passe.
    Click Element    ${radio-button}
    Input Password    ${password}    ${pass}

Selectionner Date De Naissance
    [Documentation]    Sélectionne jour / mois / année de naissance.
    [Arguments]    ${jour}    ${mois}    ${annee}
    Select From List By Value    ${buttin days}      ${jour}
    Select From List By Value    ${buttin months}    ${mois}
    Select From List By Value    ${buttin years}     ${annee}

Cocher Newsletter Et Offres
    [Documentation]    Coche les cases newsletter et offres spéciales.
    Select Checkbox    ${chk_newsletter}
    Select Checkbox    ${chk_optin}

Remplir Informations Personnelles
    [Documentation]    Renseigne prénom, nom, société et adresse ligne 1.
    Input Text    ${first_name}    ${fname}
    Input Text    ${last_name}     ${lname}
    Input Text    ${company}       ${comp}
    Input Text    ${Address}       ${Adress}

Remplir Informations Adresse
    [Documentation]    Renseigne pays, état, ville, code postal et téléphone.
    Scroll Element Into View    ${Country}
    Select From List By Value    ${Country}    India
    Input Text    ${State}      ${tState}
    Input Text    ${City}       ${tCity}
    Input Text    ${zipcode}    ${zip}
    Input Text    ${num tel}    ${num}

Valider Creation Compte
    [Documentation]    Clique sur le bouton final "Create Account".
    Click Button    ${btn_create_account}

Completer Formulaire Compte Complet
    [Documentation]    Enchaîne toutes les étapes de la page
    ...    "Enter Account Information" (TC04) en un seul keyword.
    [Arguments]    ${jour}=15    ${mois}=3    ${annee}=1995
    Wait Until Element Is Visible    ${radio-button}    timeout=${time_out}
    Selectionner Genre Et Mot De Passe
    Selectionner Date De Naissance    ${jour}    ${mois}    ${annee}
    Cocher Newsletter Et Offres
    Remplir Informations Personnelles
    Remplir Informations Adresse
    Valider Creation Compte


# ════════════ SCENARIO COMPLET (bout en bout) ═══════════════════

Inscription Complete
    [Documentation]    Parcours complet : formulaire rapide + formulaire détaillé.
    ...    Utile pour un test bout-en-bout (non utilisé par défaut ici pour ne pas
    ...    modifier le comportement existant des suites TC01-TC04).
    [Arguments]    ${nom}    ${email}
    Remplir Nom Et Email Inscription    ${nom}    ${email}
    Soumettre Formulaire Inscription Rapide
    Completer Formulaire Compte Complet


# ════════════ NAVIGATION PRODUITS / PANIER ═══════════════════

Naviguer Vers Produits
    [Documentation]    Va directement sur la page "All Products".
    Go To    ${url_products}
    Wait Until Page Contains    All Products

Aller Aux Produits Depuis Le Menu
    [Documentation]    Clique sur "Products" dans le menu de navigation.
    Click Element    ${lien_produits}
    Wait Until Page Contains    All Products

Aller Au Panier Depuis Le Menu
    [Documentation]    Clique sur l'icône/lien "Cart" dans le menu de navigation.
    Click Element    ${lien_panier}
    Wait Until Location Contains    view_cart


# ════════════ AJOUT AU PANIER ═══════════════════

Ajouter Produit Au Panier Par Id
    [Documentation]    Ajoute un produit au panier via son data-product-id.
    ...    Chaque produit possède 2 liens "Add to cart" identiques (un
    ...    visible directement, un dans l'overlay au survol) : on cible donc
    ...    le premier via XPath indexé, avec un "Mouse Over" au préalable.
    [Arguments]    ${id_produit}
    ${locator}=    Replace String    ${ADD_TO_CART_BY_ID}    %s    ${id_produit}
    Mouse Over    ${locator}
    Wait Until Element Is Visible    ${locator}    timeout=${time_out}
    Click Element    ${locator}
    Wait Until Element Is Visible    ${modal_panier}    timeout=${time_out}

Continuer Les Achats Depuis La Modale
    [Documentation]    Ferme la fenêtre modale "Added!" pour continuer à naviguer.
    Click Element    ${modal_continuer_achats}
    Wait Until Element Is Not Visible    ${modal_panier}

Aller Au Panier Depuis La Modale
    [Documentation]    Depuis la fenêtre modale "Added!", clique sur "View Cart".
    Click Element    ${modal_lien_voir_panier}
    Wait Until Element Is Visible    ${table_panier}    timeout=${time_out}

Preparer Panier Avec Un Produit
    [Documentation]    Ouvre le navigateur, va sur la page produits et ajoute
    ...    le produit de test (${id_produit}) au panier. Utilisé en Suite
    ...    Setup par les tests "cart" qui ont besoin d'un panier déjà rempli.
    Ouvrir Le Navigateur
    Naviguer Vers Produits
    Ajouter Produit Au Panier Par Id    ${id_produit}
    Continuer Les Achats Depuis La Modale


# ════════════ VERIFICATIONS / ACTIONS PANIER ═══════════════════

Le Panier Doit Contenir Le Produit
    [Documentation]    Vérifie qu'un produit donné apparaît dans le panier.
    [Arguments]    ${id_produit}    ${nom_produit}
    ${ligne}=    Replace String    ${CART_ROW_BY_ID}    %s    ${id_produit}
    Wait Until Element Is Visible    ${ligne}    timeout=${time_out}
    ${description}=    Replace String    ${CART_ROW_DESC}    %s    ${id_produit}
    Element Should Contain    ${description}    ${nom_produit}

Obtenir La Quantite Du Produit Dans Le Panier
    [Documentation]    Retourne la quantité affichée pour un produit du panier.
    [Arguments]    ${id_produit}
    ${qte_locator}=    Replace String    ${CART_ROW_QTE}    %s    ${id_produit}
    ${quantite}=    Get Text    ${qte_locator}
    RETURN    ${quantite}

Supprimer Produit Du Panier
    [Documentation]    Supprime un produit du panier via l'icône corbeille.
    [Arguments]    ${id_produit}
    ${lien_suppr}=    Replace String    ${CART_ROW_SUPPR}    %s    ${id_produit}
    Click Element    ${lien_suppr}
