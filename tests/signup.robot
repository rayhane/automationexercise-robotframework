*** Settings ***
Documentation     Suite de tests "Signup" pour automationexercise.com.
...
...               TC01 : inscription rapide avec des données valides
...               TC02 : erreur si le champ "Name" est vide
...               TC03 : erreur si le champ "Email" est vide
...               TC04 : parcours complet d'inscription (formulaire rapide
...                      + formulaire détaillé "Enter Account Information")
...
...               NB: ce fichier remplace les anciens tests/singup.robot et
...               tests/continue.robot, qui contenaient un TC04 en double
...               (l'un incomplet, l'autre complet). Ici il n'y a plus
...               qu'une seule version, correcte et complète.

Library           SeleniumLibrary
Resource          ../resources/keywords.resource
Resource          ../resources/variables.resource

Suite Setup       Ouvrir Le Navigateur
Suite Teardown    Fermer le Navigateur
Test Setup        Naviguer Vers Login

*** Test Cases ***
TC01 - Singup with valid data
    [Documentation]    Remplit le formulaire rapide "New User Signup!" avec
    ...    des données valides.
    [Tags]    signup    positive
    Remplir Nom Et Email Inscription    ${name}    ${email ins}
    Soumettre Formulaire Inscription Rapide

TC02 - Laisser un champ name vide
    [Documentation]    Vérifie le message d'erreur HTML5 quand "Name" est vide.
    [Tags]    signup    negative
    Input Text    ${chp_email}    ${email ins}
    Soumettre Formulaire Inscription Rapide
    Sleep    3s
    Capture Page Screenshot    erreur_champ_vide.png
    Verifier Message Erreur Champ Vide    input[data-qa='signup-name']    Please fill out this field.

TC03 - Laisser un champ email vide
    [Documentation]    Vérifie le message d'erreur HTML5 quand "Email" est vide.
    [Tags]    signup    negative
    Input Text    ${chp_name}    ${name}
    Soumettre Formulaire Inscription Rapide
    Sleep    3s
    Capture Page Screenshot    erreur_champ_vide2.png
    Verifier Message Erreur Champ Vide    input[data-qa='signup-email']    Please fill out this field.

TC04 - Inscription complete (Signup + Enter Account Information)
    [Documentation]    Parcours complet : formulaire rapide puis formulaire
    ...    détaillé "Enter Account Information" jusqu'à "Create Account".
    [Tags]    signup    positive    end-to-end
    Remplir Nom Et Email Inscription    ${name}    ${email ins}
    Soumettre Formulaire Inscription Rapide
    Completer Formulaire Compte Complet
