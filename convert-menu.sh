#!/bin/bash
sources convert-fonctions.sh
source couleurs

# Fonctions du menu

function incorrect_selection() {
  echo $(ColorRed 'Sélection incorrecte, faites un choix dans le menu.')
}

function press_enter() {
  echo ""
  echo -n " Appuyer sur entrée pour continuer "
  read
  clear
}

function menu(){
echo -ne " Menu Conversion/Optimisation d'images jpg, png, webp, svg.
        $(ColorGreen '1)') Tri des images en fonction de leurs extension.
        echo "__Convertir en .png__"
        $(ColorGreen '2)') Convertir images .webp en .png
        $(ColorGreen '3)') Convertir images .jpg en .png
        $(ColorGreen '4)') Convertir images .svg en .png
        echo "__Convertir en .jpg__"
        $(ColorGreen '5)') Convertir images .png en .jpg
        $(ColorGreen '6)') Convertir images .webp en .jpg
        $(ColorGreen '7)') Convertir images .svg en .jpg
        echo "__Convertir en .Webp__"
        $(ColorGreen '8)') Convertir images .png en .webp
        $(ColorGreen '9)') Convertir images .jpg en .webp
        echo "___Rassembler images dans un seul dossier___"
        $(ColorGreen '10)') Rassembler les images dans un seul dossier
        echo "___Optimiser images du dossier final___"
        $(ColorGreen '11)') Optimiser images .svg
        $(ColorGreen '12)') Optimiser images .png
        $(ColorGreen '13)') Optimiser images .jpg
        echo "___Sortir du menu ou faire un choix dans le menu___"
        $(ColorGreen '0)') Exit
        $(ColorBlue 'Choose an option:') "

        read a
        case $a in
	        1) organise-images ; menu ;;
	        2) webp2png ; menu ;;
	        3) jpg2png ; menu ;;
          4) svg2png ; menu ;;
	        5) png2jpg ; menu ;;
	        6) webp2jpg ; menu ;;
          7) svg2jpg ; menu ;;
	        8) png2webp ; menu ;;
	        9) jpg2webp ; menu ;;
          10) combine-images ; menu ;;
	        11) optimise-svg ; menu ;;
	        12) optimise-png ; menu ;;
          13) optimise-jpg ; menu ;;
		      0) exit 0 ;;
          * ) clear ; incorrect_selection ; press_enter ;;
        esac
}

until [ "$a" = "0" ]; do
    menu
done
