# Hackothon DIRO ~ Automne 2015

Commentaires, par Alizée Gagnon, Stéphanie Larocque et Nicolas Hurtubise


## Documentation

https://processing.org/ --> la recherche sur le site semble brisée par moments

Ça serait bien d'avoir des liens vers des pages utiles dans le PDF (surtout pour
les étapes de dessin de rectangles et de bordures)


## Backups

On a pas utilisé DropBox, mais la méthode semble correcte.

## Objectif 1

On est restés coincés un bon bout de temps sur le fait que nos bordures étaient
par défaut trop larges, ce qui nous donnait l'impression d'afficher nos rectangles
bleus et verts aux mauvais endroits.

Avec un strokeWeight(0);, le problème était réglé.

## Objectif 2

Tout était correct.

## Objectif 3

Étape 1 : J'ai assumé que `map[j][i] = lines[i].charAt(j);` fonctionnerait et
j'ai patché les différences avec la hauteur du level aux autres endroits, alors
que la solution la plus simple était de corriger cette ligne directement.

Peut-être que mettre plus d'emphase sur "Be careful to load the level in the
right order!" serait un bon indice.

## Objectif 4

Les étapes sont numérotées de façon incorrecte : 1, 2, 3, 1, 2, 3, 4

Par manque de temps, on a décidé de sauter la deuxième étape 2, ce qui s'est avéré
être la pire décision de notre vie (à ce jour). On s'est ensuite battus avec le lag
de Mario de la mauvaise façon en mettant 2-3h sur refaire à quelques reprises plusieurs
fonctions qui fonctionnaient déjà.
Ça pourrait être bien d'indiquer qu'il est important de ne pas sauter d'étapes.


## Objectif 5

Tout était correct, on s'est juste battus avec l'étape 2.2 de l'objectif 4 en pensant
que ça avait rapport icitte.


## Objectif 6

Pour la première étape, il serait bien de préciser que les faux objets sont 
générés aléatoirement et qu'on n'a pas besoin d'utiliser les méthodes officielles
pour les créer. 

Pour la troisième étape, il faudrait préciser quels sont les mouvements pour 
chaque objet, car la phrase "Implement the movements for all previously mentioned objects"
laisse sous-entendre que tous les objets doivent bouger, ce qui n'est pas le cas de la fleur.

Les autres étapes étaient bien, sauf que nos goombas et koopas ne sont jamais apparus :'(

Au fait, le path pour les images des piranaPlant ne fonctionnait pas. Il n'était pas
pareil dans le triggers.txt et dans la vraie vie.

