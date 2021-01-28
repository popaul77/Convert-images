#!/bin/bash
clear

source convert-fonctions.sh
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

function origine ()
{
  echo -ne "Dossier des images a traiter (ex: /home/user/dossier ou mettre '.' si vous etes dans le dossier) : "
	read DIR
  echo "$DIR"
}
function origine1 ()
{
  echo -ne "Dossiers des images a traiter (ex png,jpeg,webp) : "
	read DIR1
  echo "$DIR1"
}
function destination ()
{
  echo -ne "Destination des images a traiter (ex: ma_destination)) : "
	read DST
  echo "$DST"
}

function taille ()
{
  echo -ne "Taille de l'image finale (ex: 512) : "
	read SIZE
  echo "$SIZE"
}
function qualite ()
{
  echo -ne "Qualité de l'image finale (ex: 90) : "
	read QUALITY
  echo "$QUALITY"
}
function menu(){
echo -ne "$(ColorCyanClair 'Menu Conversion/Optimisation d images jpg, png, webp, svg.')
        $(ColorGreen '1)') Tri des images en fonction de leurs extension.
        $(ColorGreenBold  'Convertir en .png')
        $(ColorGreen '2)') Convertir images .webp en .png
        $(ColorGreen '3)') Convertir images .jpg en .png
        $(ColorGreen '4)') Convertir images .svg en .png
        $(ColorGreenBold  'Convertir en .jpg')
        $(ColorGreen '5)') Convertir images .png en .jpg
        $(ColorGreen '6)') Convertir images .webp en .jpg
        $(ColorGreen '7)') Convertir images .svg en .jpg
        $(ColorGreenBold  'Convertir en .Webp')
        $(ColorGreen '8)') Convertir images .png en .webp
        $(ColorGreen '9)') Convertir images .jpg en .webp
        $(ColorGreenBold  'Tout dans un seul dossier')
        $(ColorGreen '10)') Rassembler les images dans un seul dossier
        $(ColorGreenBold  'Optimiser images du dossier final')
        $(ColorGreen '11)') Optimiser images .svg
        $(ColorGreen '12)') Optimiser images .png
        $(ColorGreen '13)') Optimiser images .jpg
        $(ColorOrange 'Sortir du menu ou faire un choix dans le menu')
        $(ColorGreen '0)') Exit
        $(ColorBlue 'Choose an option:') "

        read a
        case $a in
	        1) origine; organise-images $DIR; menu ;;
	        2) origine; webp2png $DIR; menu ;;
	        3) origine; jpg2png $DIR; menu ;;
          4) origine; taille; svg2png $DIR $SIZE; menu ;;
	        5) origine; qualite; png2jpg $DIR $QUALITY; menu ;;
	        6) origine; qualite; webp2jpg $DIR $QUALITY; menu ;;
          7) origine; taille; qualite; svg2jpg $DIR $SIZE $QUALITY; menu ;;
	        8) origine; qualite; png2webp $DIR $QUALITY; menu ;;
	        9) origine; qualite; jpg2webp $DIR $QUALITY; menu ;;
          10) origine1; destination; combine-images $DIR1 $DST ; menu ;;
	        11) destination; optimise-svg $DST; menu ;;
	        12) destination; optimise-png $DST; menu ;;
          13) destination; qualite; optimise-jpg $DST $QUALITY; menu ;;
		      0) exit 0 ;;
          * ) clear ; incorrect_selection ; press_enter ;;
        esac
}

until [ "$a" = "0" ]; do
    menu
done
