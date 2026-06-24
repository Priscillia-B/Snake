# Snake

Ce projet est une implémentation du célèbre jeu **Snake** développée entièrement en langage Assembleur MIPS32. Il a été réalisé dans le cadre d'un projet universitaire en binôme et s'exécute via l'émulateur **MARS**.

## 🎮 Comment jouer ?

### Prérequis
- Avoir Java d'installé sur sa machine.
- Télécharger l'émulateur MARS

### Configuration de l'émulateur
Avant de lancer le jeu, vous devez configurer les outils d'affichage et de clavier dans MARS :
1. [cite_start]Ouvrez MARS en utilisant la commande `java -jar Mars.jar`[cite: 1].
2. [cite_start]Allez dans le menu **Tools**[cite: 23].
3. [cite_start]Ouvrez l'outil **Bitmap Display** et configurez-le avec ces paramètres exacts[cite: 24]:
   - *Unit Width in Pixels* : 16
   - *Unit Height in Pixels* : 16
   - *Display Width in Pixels* : 256
   - *Display Height in Pixels* : 256
4. [cite_start]Ouvrez également l'outil **Keyboard and Display MMIO Simulator**[cite: 23].
5. [cite_start]**Très important :** Cliquez sur le bouton **"Connect to MIPS"** sur ces deux fenêtres pour les lier à votre code[cite: 25].

### Contrôles
Sélectionnez la zone de saisie de l'outil *Keyboard and Display MMIO Simulator* pour contrôler le serpent.
- [cite_start]**Z** : Haut [cite: 4]
- [cite_start]**Q** : Gauche [cite: 4]
- [cite_start]**S** : Bas [cite: 4]
- [cite_start]**D** : Droite [cite: 4]

## ⚙️ Mécaniques du jeu
- [cite_start]**Déplacement :** Le serpent avance de manière automatique, si aucune touche directionnelle n'est capturée entre deux mouvements, la direction précédente est mémorisée et réutilisée[cite: 5].
- [cite_start]**Nourriture et Obstacles :** À chaque fois que le serpent mange un bloc de nourriture, sa taille augmente de 1[cite: 13]. [cite_start]Simultanément, la difficulté augmente car un nouvel obstacle apparaît aléatoirement sur la grille[cite: 14].
- **Game Over :** La partie s'arrête immédiatement si le serpent :
  - [cite_start]Dépasse la bordure de la grille[cite: 18].
  - [cite_start]Heurte un obstacle[cite: 19].
  - [cite_start]Rencontre une partie de son propre corps[cite: 19].