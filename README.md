# TP CIA

Ce TP est divisé en deux parties principales: 
- les parties 1 et 2 ont pour objectif de prendre en main et **manipuler les mécanismes** vus respectivement lors des séances 1 et 2 du cours, ainsi que de compléter ces apports théoriques par quelques expériences ou **évaluations des performances des algorithmes** en termes de temps d'exécution (l'attaque de ces algorithmes par cryptanalyse, bien qu'intéressante, est hors de la frontière d'étude pour ce TP, par contrainte de temps).
- la partie 3 vise à construire un outil de backup de fichier simple, sur lequel les mécanismes utilisés dans les parties 1 et 2 seront intégrés pour garantir des propriétés cryptographiques.

Les répertoires *mechanisms* et *backupper* contiennent des scripts pour accomplir les tâches des sections suivantes.

Parmi les scripts utilitaires : 
- `chrono.sh` permet de logger le temps d'exécution d'une commande donnée en paramètre et de l'écrire optionnellement dans un fichier (permettant une analyse plus fine, notamment par la création de figures/graphes)
- `file_creator.sh` permet de créer un fichier d'une taille donnée en paramètre. `inc_size_file_gen.sh` englobe ce processus en créant des fichiers à partir d'une liste de tailles en paramètre.

Les scripts suivants incluent des fonctionnalités répondant en tout ou partie à des tâches du TP, à utiliser pour tester, s'approprier les mécanismes ou en cas de manque de temps :
- `encryptor.sh` permet de chiffrer ou déchiffrer de manière symétrique les fichiers dans un répertoire donné, à l'aide d'algorithmes passés en paramètres. Le déchiffrement vérifie par ailleurs que chaque fichier chiffré puis déchiffré correspond au fichier initial (avant (dé)chiffrement). 
- `get_pass.sh` permet d'obtenir de l'utilisateur le mot de passe qui sera utilisé pour le chiffrement symétrique.
- `encryptor_asym.sh` est l'équivalent de `encryptor.sh` pour la cryptographie asymétrique.
- `splitNencrypt.sh` permet de diviser un fichier en plus petites parties, qui sont ensuite chiffrées.

Finalement, un fichier `makefile` agrège les différents scripts ainsi que le paramétrage global (répertoires de stockage des fichiers chiffrés, des clefs...). Une certaine tâche peut être exécutée en invoquant la règle correspondante par `make <règle>`, par exemple `make create_files` pour générer les fichiers blob dont les tailles sont données par la variables `FILE_SIZES` en début de fichier. Le comportement de chaque règle peut être retrouvé, outre par son nom, en regardant les commandes *openssl* et de *scripts* qu'elle invoque. `make clean` peut être lancée pour remettre le projet dans un état propre (suppression des fichiers générés par les expériences).

Si ces scripts sont utilisés dans votre TP, il est attendu en compensation de porter une plus grande attention à l'analyse des observations que l'on peut faire des résultats de scripts. Par exemple, des figures peuvent être générées à partir de ces scripts, dans le but de visualiser et comparer les temps d'exécution entre algorithmes. Ces conclusions pourront ensuite être enrichies de connaissances théoriques concernant la sécurité notamment (comme elle n'est pas traitée de manière appliquée dans ce TP).

## 1. Chiffrement

Le choix d'un algorithme de chiffrement plutôt qu'un autre a des conséquences sur la performance et la sécurité du protocole l'intégrant. La performance peut est mesurée par exemple par rapport au temps d'exécution, mais aussi à la taille des messages chiffrés (induisant un coût de stockage ou de bande passante).

Dans les sections suivantes, l'objectif sera de **manipuler la librairie *openssl*** pour **(dé)chiffrer des messages** ou fichiers, ainsi que de **mesurer le temps d'exécution** à des fins comparatives **entre algorithmes**, en parallèle de considérations de sécurité. De manière générale, étant donné l'impact d'une attaque sur un processus métier, il s'agit de choisir des algorithmes protégeant contre l'attaque (plus précisément, qui rendent la réussite de l'attaque très coûteuse, ou plus chère que la valeur à soutirer, et donc peu probable), et en cas de compétition, de sélectionner l'algorithme le plus performant.

La commande `time <commande à analyser>` pourra vous être utile pour mesurer le temps d'exécution d'une commande en paramètre. Par défaut, `time` vous renvoit trois valeurs, *real*, le temps "réel" tel que perçu par l'utilisateur et l'horloge de la machine entre le lancement du processus et son retour final, *user* et *sys*. Ces deux dernières représentent le temps que le processus a **effectivement passé dans le CPU** respectivement en user-mode (pour les instructions non sensibles) et en kernel-mode (pour les instructions sensibles, par exemple pour l'allocation mémoire). 

Utiliser *real* implique que la mesure faite comprendra également le temps où la machine exécute d'autres processus en tâches de fond au lieu de seulement celui à analyser. Dans ce cas, il faudra **répéter l'expérience** pour "lisser" les perturbations extérieures, en appliquant par exemple une **moyenne sur les temps** obtenus sur les expériences.

### 1.1 Chiffrement symétrique

- Utilisez la librairie *openssl* pour (dé)chiffrer des fichiers de tailles croissantes (par exemple 10ko,... 1Mo,... 1Go). **Mesurez le temps** pris par l'opération en fonction de l'**algorithme choisi** et la **taille du fichier**. Vous pourrez soit implémenter ce script vous-même, ou utiliser ceux fournis. 

- En utilisant les scripts fournis, ou les vôtres, vous pouvez **enregistrer les temps d'exécution dans un fichier**, au format **.csv** (chaînes de caractères séparées par un séparateur, comme un espace, une virgule,...). Ensuite, en utilisant **LibreOffice Calc** (ou équivalent), vous pourrez :
    - D'une part, appliquer des filtres sur les données : `Data > AutoFilter` sur LibreOffice. Ceci permet d'afficher seulement les lignes correspondant au critère de filtre (par exemple seulement les expériences sur aes-128).
    - D'autre part, en sélectionnant la colonne donnant l'algorithme de chiffrement ainsi que celles des temps *user* et *sys*, vous pourrez générer des figures donnant les **temps d'exécution en fonction de l'algorithme pour une taille de fichier donnée** (en filtrant la taille du fichier, par exemple seulement les expériences sur un fichier de taille 1Go). Des figures similaires peuvent être générées en prenant la colonne de taille de fichier en abscisse (axe horizontal des x), et en fixant l'algorithme (par filtrage). On obtiendra alors le **temps d'exécution d'un algorithme en fonction de la taille de fichier**. Changer le critère de filtre (par exemple pour rc4 au lieu de aes-128) mettra automatiquement à jour la figure.
    - Pour la mise en page de la figure, on pourra utiliser une **échelle logarithmique** (une graduation par puissance de 10 : 0.01, 0.1, 1, 10,...) par un clic-droit sur l'axe des ordonnées (axe vertical des y) pour mieux visualiser les **différences significatives entre algorithmes**.

- Dans le script `encryptor.sh`, **localisez, expliquez et commentez** le mécanisme vérifiant que le fichier initial correspond bien au fichier déchiffré.

### 1.2 Chiffrement asymétrique

Une méthode similaire à la section précédente peut être utilisée pour étudier le chiffrement asymétrique, seules les commandes *openssl* seront à changer (à cela s'ajoute le processus de génération de clefs privées/publiques propre à la cryptographie asymétrique).
- En utilisant `encrypt_asym.sh` en mode "naïf" ou vos propres scripts, chiffrez et déchiffrez de manière similaire à précédent des fichiers de tailles variées. Quel problème constatez-vous en fonction de cette taille de fichier ?
- Proposez une solution à ce problème (ou utilisez et expliquez la version non naïve de `encrypt_asym.sh`) et mesurez les temps d'exécution comme précédemment.

## 2. Hachage et Signature

En utilisant des outils similaires à ceux utilisés en partie 1., effectuez les tâches de la version pdf du TP.

## 3. Outil de backup

### 3.1 MVP

`backup.sh` contient un utilitaire très simple pour envoyer ou récupérer des fichiers depuis une zone de travail vers une zone de backup ou inversement. 
Il possède deux sous-commandes:
- `push <src> <dst>` pour l'envoi zone de travail -> backup
- `pull <src> <dst>` pour la restoration du backup dans la zone de travail.
A l'état actuel, le comportement des commandes est identique, mis à part l'inversion entre la source et la destination, ainsi que l'affichage.
Cependant, l'ajout des contraintes de sécurité cryptographique CIA dans la section suivante demanderont des actions différentes en push et en pull, d'où l'implémentation dès à présent en deux sous-commandes. 

### 3.2
A partir de ce script et des commandes utilisées pour les parties précédentes, vous devez désormais ajouter les propriétés de confidentialité, intégrité et authenticité à l'outil de backup.