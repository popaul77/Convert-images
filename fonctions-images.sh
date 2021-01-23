#!/bin/bash

### Organiser les images ###
 # OK, nous sommes techniquement configurés.
 # Mais avant de nous lancer dans l'optimisation de toutes les images,
 # nous devons organiser un peu nos fichiers.
 # Organisons-les en les divisant en différents sous-répertoires en fonction de leur type MIME.
 # En fait, nous pouvons créer une nouvelle fonction pour le faire pour nous!

function organise-images () # organise-images dossier-de-depart-images
{
input_dir="$1"

if [[ -z "$input_dir" ]]; then
  echo "Preciser le dossier de départ."
  exit 1
fi

for img in $( find $input_dir -type f -iname "*" );
do
  img_type=$(basename `file --mime-type -b $img`)
  mkdir -p $img_type
  rsync -a $img $img_type
done
}

#__________________________________________________
### Convertir en png ###

function webp2png() # webp2png webp
{
input_dir="$1"

if [[ -z "$input_dir" ]]; then
  echo "Preciser le dossier de départ."
  exit 1
fi

for img in $( find $input_dir -type f -iname "*.webp" );
do
  dwebp $img -o ${img%.*}.png
done
}

#__________________________________________________

function jpg2png () # jpg2png jpeg
{
input_dir="$1"

if [[ -z "$input_dir" ]]; then
  echo "Preciser le dossier de départ."
  exit 1
fi

for img in $( find $input_dir -type f -iname "*.jpg" -o -iname "*.jpeg" );
do
  convert $img ${img%.*}.png
done
}

#__________________________________________________

function svg2png () # svg2png svg+xml
{
input_dir="$1"
width="$2"

if [[ -z "$input_dir" ]]; then
  echo "Preciser le dossier de départ."
  exit 1
elif [[ -z "$width" ]]; then
  echo "Preciser la largeur de l'image finale."
  exit 1
fi

for img in $( find $input_dir -type f -iname "*.svg" );
do
  svgexport $img ${img%.*}.png $width:
done
}

#__________________________________________________
### Convertir en JPG ###

function png2jpg () # png2jpg png 90
{
input_dir="$1"
quality="$2"

if [[ -z "$input_dir" ]]; then
  echo "Preciser le dossier de départ."
  exit 1
elif [[ -z "$quality" ]]; then
  echo "Preciser la qualité de l'image finale."
  exit 1
fi

for img in $( find $input_dir -type f -iname "*.png" );
do
  convert $img -quality $quality% ${img%.*}.jpg
done
}

#__________________________________________________

function webp2jpg () # webp2jpg jpeg 90
{
input_dir="$1"
quality="$2"

if [[ -z "$input_dir" ]]; then
  echo "Preciser le dossier de départ."
  exit 1
elif [[ -z "$quality" ]]; then
  echo "Preciser la qualité de l'image finale."
  exit 1
fi

for img in $( find $input_dir -type f -iname "*.webp" );
do
  dwebp $img -o ${img%.*}.png
  convert ${img%.*}.png -quality $quality% ${img%.*}.jpg
done
}

#__________________________________________________
function svg2jpg () # svg2jpg svg+xml 512 90
{
input_dir="$1"
width="$2"
quality="$3"

if [[ -z "$input_dir" ]]; then
  echo "Preciser le dossier de départ."
  exit 1
elif [[ -z "$width" ]]; then
  echo "Preciser la largeur de l'image finale."
  exit 1
elif [[ -z "$quality" ]]; then
  echo "Preciser la qualité de l'image finale."
  exit 1
fi

for img in $( find $input_dir -type f -iname "*.svg" );
do
    svgexport $img ${img%.*}.jpg $width: $quality%
done
}

#__________________________________________________
### Convertir en WebP ###

function png2webp () # png2webp png 90
{
input_dir="$1"
quality="$2"

if [[ -z "$input_dir" ]]; then
  echo "Preciser le dossier de départ."
  exit 1
elif [[ -z "$quality" ]]; then
  echo "Preciser la qualité de l'image finale."
  exit 1
fi

for img in $( find $input_dir -type f -iname "*.png" );
do
  cwebp $img -q $quality -o ${img%.*}.webp
done
}

#__________________________________________________

function jpg2webp () # jpg2webp jpeg 90
{
input_dir="$1"
quality="$2"

if [[ -z "$input_dir" ]]; then
  echo "Preciser le dossier de départ."
  exit 1
elif [[ -z "$quality" ]]; then
  echo "Preciser la qualité de l'image finale."
  exit 1
fi

for img in $( find $input_dir -type f -iname "*.jpg" -o -iname "*.jpeg" );
do
  # convert to png first
  convert $img ${img%.*}.png

  # then convert png to webp
  cwebp ${img%.*}.png -q $quality -o ${img%.*}.webp
done
}

#__________________________________________________
### Tout combiner dans un seul répertoire ###

function combine-images () # combine-images jpeg,svg+xml,webp,png destination-images
{
input_dirs="$1"
output_dir="$2"

if [[ -z "$input_dirs" ]]; then
  echo "Preciser le dossier de départ."
  exit 1
elif [[ -z "$output_dir" ]]; then
  echo "Preciser le dossier de destination."
  exit 1
fi

mkdir -p $output_dir

# diviser les répertoires d'entrée des chaînes séparées par des virgules en un tableau
input_dirs=(${input_dirs//,/ })

for dir in "${input_dirs[@]}"
do
# copier les images de ce répertoire vers le répertoire de destination.
  rsync -a $dir/* $output_dir/
done
}

#__________________________________________________
### Optimiser SVG ##

function optimise-svg () # optimise-svg destination-images
{
input_dir="$1"

if [[ -z "$input_dir" ]]; then
echo "Preciser le dossier de départ."
exit 1
fi

for img in $( find $input_dir -type f -iname "*.svg" );
do
  svgo $img -o ${img%.*}-optimized.svg
done
}

#__________________________________________________

function optimise-png ()  # optimise-png destination-images
{
input_dir="$1"

if [[ -z "$input_dir" ]]; then
  echo "Preciser le dossier de départ."
  exit 1
fi

for img in $( find $input_dir -type f -iname "*.png" );
do
  optipng $img -out ${img%.*}-optimized.png
done
}

#__________________________________________________
### optimise-jpg ###
# L'argument -m est utilisé pour spécifier la qualité de l'image.
# Il est bon de l'essayer un peu pour trouver le bon équilibre entre qualité taille du fichier.

function optimise-jpg () # optimise-jpg destination-images 95
{
input_dir="$1"
quality="$2"

if [[ -z "$input_dir" ]]; then
  echo "Preciser le dossier de départ."
  exit 1
elif [[ -z "$quality" ]]; then
  echo "Preciser la qualité de l'image finale."
  exit 1
fi

for img in $( find $input_dir -type f -iname "*.jpg" -o -iname "*.jpeg" );
do
  cp $img ${img%.*}-optimized.jpg
  jpegoptim -m $quality ${img%.*}-optimized.jpg
done
}
