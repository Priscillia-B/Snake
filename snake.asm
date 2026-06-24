#                      _..._                 .           __.....__
#                    .'     '.             .'|       .-''         '.
#                   .   .-.   .          .'  |      /     .-''"'-.  `.
#                   |  '   '  |    __   <    |     /     /________\   \
#               _   |  |   |  | .:--.'.  |   | ____|                  |
#             .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'
#            .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.
#          .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'
#        .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'
#        .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \
#                   '--'   '--' `--'  `"'------'  '---'
#
#
#
#                                               .......
#                                     ..  ...';:ccc::,;,'.
#                                 ..'':cc;;;::::;;:::,'',,,.
#                              .:;c,'clkkxdlol::l;,.......',,
#                          ::;;cok0Ox00xdl:''..;'..........';;
#                          o0lcddxoloc'.,. .;,,'.............,'
#                           ,'.,cc'..  .;..;o,.       .......''.
#                             :  ;     lccxl'          .......'.
#                             .  .    oooo,.            ......',.
#                                    cdl;'.             .......,.
#                                 .;dl,..                ......,,
#                                 ;,.                   .......,;
#                                                        ......',
#                                                       .......,;
#                                                       ......';'
#                                                      .......,:.
#                                                     .......';,
#                                                   ........';:
#                                                 ........',;:.
#                                             ..'.......',;::.
#                                         ..';;,'......',:c:.
#                                       .;lcc:;'.....',:c:.
#                                     .coooc;,.....,;:c;.
#                                   .:ddol,....',;:;,.
#                                  'cddl:'...,;:'.
#                                 ,odoc;..',;;.                    ,.
#                                ,odo:,..';:.                     .;
#                               'ldo:,..';'                       .;.
#                              .cxxl,'.';,                        .;'
#                              ,odl;'.',c.                         ;,.
#                              :odc'..,;;                          .;,'
#                              coo:'.',:,                           ';,'
#                              lll:...';,                            ,,''
#                              :lo:'...,;         ...''''.....       .;,''
#                              ,ooc;'..','..';:ccccccccccc::;;;.      .;''.
#          .;clooc:;:;''.......,lll:,....,:::;;,,''.....''..',,;,'     ,;',
#       .:oolc:::c:;::cllclcl::;cllc:'....';;,''...........',,;,',,    .;''.
#      .:ooc;''''''''''''''''''',cccc:'......'',,,,,,,,,,;;;;;;'',:.   .;''.
#      ;:oxoc:,'''............''';::::;'''''........'''',,,'...',,:.   .;,',
#     .'';loolcc::::c:::::;;;;;,;::;;::;,;;,,,,,''''...........',;c.   ';,':
#     .'..',;;::,,,,;,'',,,;;;;;;,;,,','''...,,'''',,,''........';l.  .;,.';
#    .,,'.............,;::::,'''...................',,,;,.........'...''..;;
#   ;c;',,'........,:cc:;'........................''',,,'....','..',::...'c'
#  ':od;'.......':lc;,'................''''''''''''''....',,:;,'..',cl'.':o.
#  :;;cclc:,;;:::;''................................'',;;:c:;,'...';cc'';c,
#  ;'''',;;;;,,'............''...........',,,'',,,;:::c::;;'.....',cl;';:.
#  .'....................'............',;;::::;;:::;;;;,'.......';loc.'.
#   '.................''.............'',,,,,,,,,'''''.........',:ll.
#    .'........''''''.   ..................................',;;:;.
#      ...''''....          ..........................'',,;;:;.
#                                ....''''''''''''''',,;;:,'.
#                                    ......'',,'','''..
#


################################################################################
#                  Fonctions d'affichage et d'entrée clavier                   #
################################################################################

# Ces fonctions s'occupent de l'affichage et des entrées clavier.
# Il n'est pas nécessaire de les modifier.!!!

.data


# Tampon d'affichage du jeu 256*256 de manière linéaire.

frameBuffer: .word 0 : 1024  # Frame buffer

# Code couleur pour l'affichage
# Codage des couleurs 0xwwxxyyzz où
#   ww = 00
#   00 <= xx <= ff est la couleur rouge en hexadécimal
#   00 <= yy <= ff est la couleur verte en hexadécimal
#   00 <= zz <= ff est la couleur bleue en hexadécimal

colors: .word 0x00000000, 0x00ff0000, 0xff00ff00, 0x00396239, 0x00ff00ff
.eqv black 0
.eqv red   4
.eqv green 8
.eqv greenV2  12
.eqv rose  16

# Dernière position connue de la queue du serpent.

lastSnakePiece: .word 0, 0

.text
j main

############################# printColorAtPosition #############################
# Paramètres: $a0 La valeur de la couleur
#             $a1 La position en X
#             $a2 La position en Y
# Retour: Aucun
# Effet de bord: Modifie l'affichage du jeu
################################################################################

printColorAtPosition:
lw $t0 tailleGrille
mul $t0 $a1 $t0
add $t0 $t0 $a2
sll $t0 $t0 2
sw $a0 frameBuffer($t0)
jr $ra

################################ resetAffichage ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Réinitialise tout l'affichage avec la couleur noir
################################################################################

resetAffichage:
lw $t1 tailleGrille
mul $t1 $t1 $t1
sll $t1 $t1 2
la $t0 frameBuffer
addu $t1 $t0 $t1
lw $t3 colors + black

RALoop2: bge $t0 $t1 endRALoop2
  sw $t3 0($t0)
  add $t0 $t0 4
  j RALoop2
endRALoop2:
jr $ra

################################## printSnake ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement ou se
#                trouve le serpent et sauvegarde la dernière position connue de
#                la queue du serpent.
################################################################################

printSnake:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 tailleSnake
sll $s0 $s0 2
li $s1 0

lw $a0 colors + greenV2
lw $a1 snakePosX($s1)
lw $a2 snakePosY($s1)
jal printColorAtPosition
li $s1 4

PSLoop:
bge $s1 $s0 endPSLoop
  lw $a0 colors + green
  lw $a1 snakePosX($s1)
  lw $a2 snakePosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j PSLoop
endPSLoop:

subu $s0 $s0 4
lw $t0 snakePosX($s0)
lw $t1 snakePosY($s0)
sw $t0 lastSnakePiece
sw $t1 lastSnakePiece + 4

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################ printObstacles ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage aux emplacement des obstacles.
################################################################################

printObstacles:
subu $sp $sp 12
sw $ra 0($sp)
sw $s0 4($sp)
sw $s1 8($sp)

lw $s0 numObstacles
sll $s0 $s0 2
li $s1 0

POLoop:
bge $s1 $s0 endPOLoop
  lw $a0 colors + red
  lw $a1 obstaclesPosX($s1)
  lw $a2 obstaclesPosY($s1)
  jal printColorAtPosition
  addu $s1 $s1 4
  j POLoop
endPOLoop:

lw $ra 0($sp)
lw $s0 4($sp)
lw $s1 8($sp)
addu $sp $sp 12
jr $ra

################################## printCandy ##################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Change la couleur de l'affichage à l'emplacement du bonbon.
################################################################################

printCandy:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + rose
lw $a1 candy
lw $a2 candy + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

eraseLastSnakePiece:
subu $sp $sp 4
sw $ra ($sp)

lw $a0 colors + black
lw $a1 lastSnakePiece
lw $a2 lastSnakePiece + 4
jal printColorAtPosition

lw $ra ($sp)
addu $sp $sp 4
jr $ra

################################## printGame ###################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Effectue l'affichage de la totalité des éléments du jeu.
################################################################################

printGame:
subu $sp $sp 4
sw $ra 0($sp)

jal eraseLastSnakePiece
jal printSnake
jal printObstacles
jal printCandy

lw $ra 0($sp)
addu $sp $sp 4
jr $ra

############################## getRandomExcluding ##############################
# Paramètres: $a0 Un entier x | 0 <= x < tailleGrille
# Retour: $v0 Un entier y | 0 <= y < tailleGrille, y != x
################################################################################

getRandomExcluding:
move $t0 $a0
lw $a1 tailleGrille
li $v0 42
syscall
beq $t0 $a0 getRandomExcluding
move $v0 $a0
jr $ra

########################### newRandomObjectPosition ############################
# Description: Renvoie une position aléatoire sur un emplacement non utilisé
#              qui ne se trouve pas devant le serpent.
# Paramètres: Aucun
# Retour: $v0 Position X du nouvel objet
#         $v1 Position Y du nouvel objet
################################################################################

newRandomObjectPosition:
subu $sp $sp 4
sw $ra ($sp)

lw $t0 snakeDir
or $t0 0x2
bgtz $t0 horizontalMoving
li $v0 42
lw $a1 tailleGrille
syscall
move $t8 $a0
lw $a0 snakePosY
jal getRandomExcluding
move $t9 $v0
j endROPdir

horizontalMoving:
lw $a0 snakePosX
jal getRandomExcluding
move $t8 $v0
lw $a1 tailleGrille
li $v0 42
syscall
move $t9 $a0
endROPdir:

lw $t0 tailleSnake
sll $t0 $t0 2
la $t0 snakePosX($t0)
la $t1 snakePosX
la $t2 snakePosY
li $t4 0

ROPtestPos:
bge $t1 $t0 endROPtestPos
lw $t3 ($t1)
bne $t3 $t8 ROPtestPos2
lw $t3 ($t2)
beq $t3 $t9 replayROP
ROPtestPos2:
addu $t1 $t1 4
addu $t2 $t2 4
j ROPtestPos
endROPtestPos:

bnez $t4 endROP

lw $t0 numObstacles
sll $t0 $t0 2
la $t0 obstaclesPosX($t0)
la $t1 obstaclesPosX
la $t2 obstaclesPosY
li $t4 1
j ROPtestPos

endROP:
move $v0 $t8
move $v1 $t9
lw $ra ($sp)
addu $sp $sp 4
jr $ra

replayROP:
lw $ra ($sp)
addu $sp $sp 4
j newRandomObjectPosition

################################# getInputVal ##################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 (haut), 1 (droite), 2 (bas), 3 (gauche), 4 erreur
################################################################################

getInputVal:
lw $t0 0xffff0004
li $t1 115
beq $t0 $t1 GIhaut
li $t1 122
beq $t0 $t1 GIbas
li $t1 113
beq $t0 $t1 GIgauche
li $t1 100
beq $t0 $t1 GIdroite
li $v0 4
j GIend

GIhaut:
li $v0 0
j GIend

GIdroite:
li $v0 1
j GIend

GIbas:
li $v0 2
j GIend

GIgauche:
li $v0 3

GIend:
jr $ra

################################ sleepMillisec #################################
# Paramètres: $a0 Le temps en milli-secondes qu'il faut passer dans cette
#             fonction (approximatif)
# Retour: Aucun
################################################################################

sleepMillisec:
move $t0 $a0
li $v0 30
syscall
addu $t0 $t0 $a0

SMloop:
bgt $a0 $t0 endSMloop
li $v0 30
syscall
j SMloop

endSMloop:
jr $ra

##################################### main #####################################
# Description: Boucle principal du jeu
# Paramètres: Aucun
# Retour: Aucun
################################################################################

main:

# Initialisation du jeu

#jal resetAffichage
jal newRandomObjectPosition
sw $v0 candy
sw $v1 candy + 4


# Boucle de jeu

mainloop:

jal getInputVal
move $a0 $v0
jal majDirection
jal updateGameStatus
jal conditionFinJeu
bnez $v0 gameOver
jal printGame
li $a0 500
jal sleepMillisec
j mainloop

gameOver:
jal affichageFinJeu
li $v0 10
syscall

################################################################################
#                                Partie Projet                                 #
################################################################################

# À vous de jouer !

.data

tailleGrille:  .word 16        # Nombre de case du jeu dans une dimension.

# La tête du serpent se trouve à (snakePosX[0], snakePosY[0]) et la queue à
# (snakePosX[tailleSnake - 1], snakePosY[tailleSnake - 1])
tailleSnake:   .word 1         # Taille actuelle du serpent.
snakePosX:     .word 0 : 1024  # Coordonnées X du serpent ordonné de la tête à la queue.
snakePosY:     .word 0 : 1024  # Coordonnées Y du serpent ordonné de la t.

# Les directions sont représentés sous forme d'entier allant de 0 à 3:
snakeDir:      .word 1       # Direction du serpent: 0 (haut), 1 (droite)
                               #                       2 (bas), 3 (gauche)
numObstacles:  .word 0         # Nombre actuel d'obstacle présent dans le jeu.
obstaclesPosX: .word 0 : 1024  # Coordonnées X des obstacles
obstaclesPosY: .word 0 : 1024  # Coordonnées Y des obstacles
candy:         .word 0, 0      # Position du bonbon (X,Y)
scoreJeu:      .word 0         # Score obtenu par le joueur
motgentil: .asciiz "Vous �tes vraiment tr�s mauvais ! \n"
.text


################################# majDirection #################################
# Paramètres: $a0 La nouvelle position demandée par l'utilisateur. La valeur
#                 étant le retour de la fonction getInputVal.
# Retour: Aucun
# Effet de bord: La direction du serpent à été mise à jour.
# Post-condition: La valeur du serpent reste intacte si une commande illégale
#                 est demandée, i.e. le serpent ne peut pas faire un demi-tour 
#                 (se retourner en un seul tour. Par exemple passer de la 
#                 direction droite à gauche directement est impossible (un 
#                 serpent n'est pas une chouette)
################################################################################

majDirection:
subu $sp $sp 12
sw $ra 0($sp)
sw $a0 4($sp)
sw $t0 8($sp)

lw $t0 snakeDir

beq $a0 4 Exit
beq $a0 $t0 Exit

# Haut
beq $a0 0 TestLegalTop
# Droite 
beq $a0 1 TestLegalRight
# Bas
beq $a0 2 TestLegalBottom
# Left
beq $a0 3 TestLegalLeft

TestLegalTop:
bne $t0 2 SetDirection
j Exit

TestLegalBottom:
bne $t0 0 SetDirection
j Exit

TestLegalRight:
bne $t0 3 SetDirection
j Exit

TestLegalLeft:
bne $t0 1 SetDirection
j Exit

SetDirection:
sw $a0 snakeDir

Exit :
lw $ra 0($sp)
lw $a0 4($sp)
lw $t0 8($sp)
addu $sp $sp 12
jr $ra

############################### updateGameStatus ###############################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: L'état du jeu est mis à jour d'un pas de temps. Il faut donc :
#                  - Faire bouger le serpent
#                  - Tester si le serpent à manger le bonbon
#                    - Si oui déplacer le bonbon et ajouter un nouvel obstacle
################################################################################



updateGameStatus:
subu $sp $sp 56
sw $ra 0($sp)
sw $t0 4($sp)
sw $t1 8($sp)
sw $t2 12($sp)
sw $t3 16($sp)
sw $t4 20($sp)
sw $t5 24($sp)
sw $t6 28($sp)
sw $t7 32($sp)
sw $t8 36($sp)
sw $t9 40($sp)
sw $s1 44($sp)
sw $s2 48($sp)
sw $s3 52($sp)


lw $t0 snakeDir

la $t1 snakePosX
la $t2 snakePosY



lw $t5 tailleSnake
li $s1 4
mul $t5 $t5 $s1
add $t1 $t1 $t5
add $t2 $t2 $t5
lw $t5 tailleSnake
lw $t7 tailleSnake

beq $t0 0 BougeEnHaut
beq $t0 1 BougeADroite
beq $t0 2 BougeEnBas
beq $t0 3 BougeAGauche


BougeEnHaut:
beq $t5 0 UpY
subi $t1 $t1 4
addi $t3 $t1 4
lw $t6 0($t1)
sw $t6 0($t3)
subi $t5 $t5 1
j BougeEnHaut

UpY:
beq $t7 0 HeadUp
subi $t2 $t2 4
addi $t3 $t2 4
lw $t6 0($t2)
sw $t6 0($t3)
subi $t7 $t7 1
j UpY

HeadUp: 
la $t1 snakePosX
lw $t3 4($t1)
addi $t3 $t3 1
sw $t3 0($t1)

la $t2 snakePosY
lw $t3 4($t2)
sw $t3 0($t2)

lw $t5 tailleSnake
li $s1 4
mul $t5 $t5 $s1
add $t1 $t1 $t5
add $t2 $t2 $t5
li $s2 0
sw $s2 0($t1)
sw $s2 0($t2)
j TestCandy

BougeEnBas:
beq $t5 0 DownY
subi $t1 $t1 4
addi $t3 $t1 4
lw $t6 0($t1)
sw $t6 0($t3)
subi $t5 $t5 1
j BougeEnBas

DownY:
beq $t7 0 HeadDown
subi $t2 $t2 4
addi $t3 $t2 4
lw $t6 0($t2)
sw $t6 0($t3)
subi $t7 $t7 1
j DownY

HeadDown: 
lw $t5 tailleSnake
la $t1 snakePosX
lw $t3 4($t1)
subi $t3 $t3 1
sw $t3 0($t1)

la $t2 snakePosY
lw $t3 4($t2)
sw $t3 0($t2)

lw $t5 tailleSnake
li $s1 4
mul $t5 $t5 $s1
add $t1 $t1 $t5
add $t2 $t2 $t5
li $s2 0
sw $s2 0($t1)
sw $s2 0($t2)
j TestCandy

BougeADroite:
beq $t5 0 RightY
subi $t2 $t2 4
addi $t3 $t2 4
lw $t6 0($t2)
sw $t6 0($t3)
subi $t5 $t5 1
j BougeADroite

RightY:
beq $t7 0 HeadRight
subi $t1 $t1 4
addi $t3 $t1 4
lw $t6 0($t1)
sw $t6 0($t3)
subi $t7 $t7 1
j RightY

HeadRight: 
la $t2 snakePosY
lw $t3 4($t2)
addi $t3 $t3 1
sw $t3 0($t2)

la $t1 snakePosX
lw $t3 4($t1)
sw $t3 0($t1)

lw $t5 tailleSnake
li $s1 4
mul $t5 $t5 $s1
add $t1 $t1 $t5
add $t2 $t2 $t5
li $s2 0
sw $s2 0($t1)
sw $s2 0($t2)
j TestCandy

BougeAGauche:
beq $t5 0 LeftX
subi $t2 $t2 4
addi $t3 $t2 4
lw $t6 0($t2)
sw $t6 0($t3)
subi $t5 $t5 1
j BougeAGauche

LeftX:
beq $t7 0 HeadLeft
subi $t1 $t1 4
addi $t3 $t1 4
lw $t6 0($t1)
sw $t6 0($t3)
subi $t7 $t7 1
j LeftX

HeadLeft: 
la $t2 snakePosY
lw $t3 4($t2)
subi $t3 $t3 1
sw $t3 0($t2)

la $t1 snakePosX
lw $t3 4($t1)
sw $t3 0($t1)

lw $t5 tailleSnake
li $s1 4
mul $t5 $t5 $s1
add $t1 $t1 $t5
add $t2 $t2 $t5
li $s2 0
sw $s2 0($t1)
sw $s2 0($t2)



TestCandy:
lw $t0 snakeDir

la $t1 snakePosX
la $t2 snakePosY

lw $t3 0($t1) # en X
lw $t4 0($t2)  # en Y

lw $t5 tailleSnake

la $t6 candy
lw $t7 0($t6)
lw $t8 4($t6)

la $s3 lastSnakePiece

beq $t3 $t7 TestY
j Exi

TestY:
beq $t4 $t8 Augmente
j Exi


Augmente:
#augmente le score du joueur
la $t1 scoreJeu
lw $t2 0($t1)
addi $t2 $t2 1
sw $t2 0($t1)
#change la queue
la $t1 snakePosX
la $t2 snakePosY
la $s3 lastSnakePiece
lw $t5 tailleSnake
li $s1 4
mul $t5 $t5 $s1
subi $t5 $t5 4
add $t1 $t1 $t5
add $t2 $t2 $t5
lw $t1 0($t1)
lw $t2 0($t2)
sw $t1 0($s3)
sw $t2 4($s3)

la $t1 snakePosX
la $t2 snakePosY
lw $t5 tailleSnake
li $s1 4
mul $t5 $t5 $s1
add $t1 $t1 $t5
add $t2 $t2 $t5
lw $t5 tailleSnake
lw $t7 tailleSnake

beq $t0 0 CordoAddX
beq $t0 1 CordoAddY
beq $t0 2 CordoSubX
beq $t0 3 CordoSubY


CordoAddX:
beq $t5 0 ChangeYAdd
subi $t1 $t1 4
addi $t3 $t1 4
lw $t6 0($t1)
sw $t6 0($t3)
subi $t5 $t5 1
j CordoAddX

ChangeYAdd:
beq $t7 0 AddX
subi $t2 $t2 4
addi $t3 $t2 4
lw $t6 0($t2)
sw $t6 0($t3)
subi $t7 $t7 1
j ChangeYAdd

AddX: 
la $t1  snakePosX
lw $t3 4($t1)
addi $t3 $t3 1
sw $t3 0($t1)

la $t2 snakePosY
lw $t3 4($t2)
sw $t3 0($t2)

lw $t5 tailleSnake
li $s1 4
mul $t5 $t5 $s1
add $t1 $t1 $t5
add $t2 $t2 $t5
lw $t1 0($t1)
lw $t2 0($t2)
sw $t1 0($s3)
sw $t2 4($s3)
j MoveCandy




CordoSubX:
beq $t5 0 ChangeYSub
subi $t1 $t1 4
addi $t3 $t1 4
lw $t6 0($t1)
sw $t6 0($t3)
subi $t5 $t5 1
j CordoSubX


ChangeYSub:
beq $t7 0 SubX
subi $t2 $t2 4
addi $t3 $t2 4
lw $t6 0($t2)
sw $t6 0($t3)
subi $t7 $t7 1
j ChangeYSub


SubX: 
lw $t5 tailleSnake
la $t1 snakePosX
lw $t3 4($t1)
subi $t3 $t3 1
sw $t3 0($t1)

la $t2 snakePosY
lw $t3 4($t2)
sw $t3 0($t2)

lw $t5 tailleSnake
li $s1 4
mul $t5 $t5 $s1
add $t1 $t1 $t5
add $t2 $t2 $t5
lw $t1 0($t1)
lw $t2 0($t2)
sw $t1 0($s3)
sw $t2 4($s3)
lw $t5 tailleSnake
addi $t5 $t5 1
sw $t5 tailleSnake
j MoveCandy




CordoAddY:
beq $t5 0 ChangeXAdd
subi $t2 $t2 4
addi $t3 $t2 4
lw $t6 0($t2)
sw $t6 0($t3)
subi $t5 $t5 1
j CordoAddY

ChangeXAdd:
beq $t7 0 AddY
subi $t1 $t1 4
addi $t3 $t1 4
lw $t6 0($t1)
sw $t6 0($t3)
subi $t7 $t7 1
j ChangeXAdd

AddY: 
lw $t5 tailleSnake
la $t2 snakePosY
lw $t3 4($t2)
addi $t3 $t3 1
sw $t3 0($t2)

la $t1 snakePosX
lw $t3 4($t1)
sw $t3 0($t1)

lw $t5 tailleSnake
li $s1 4
mul $t5 $t5 $s1
add $t1 $t1 $t5
add $t2 $t2 $t5
lw $t1 0($t1)
lw $t2 0($t2)
sw $t1 0($s3)
sw $t2 4($s3)
lw $t5 tailleSnake
addi $t5 $t5 1
sw $t5 tailleSnake
j MoveCandy

CordoSubY:
beq $t5 0 ChangeXSub
subi $t2 $t2 4
addi $t3 $t2 4
lw $t6 0($t2)
sw $t6 0($t3)
subi $t5 $t5 1
j CordoSubY

ChangeXSub:
beq $t7 0 SubY
subi $t1 $t1 4
addi $t3 $t1 4
lw $t6 0($t1)
sw $t6 0($t3)
subi $t7 $t7 1
j ChangeXSub

SubY: 
lw $t5 tailleSnake
la $t2 snakePosY
lw $t3 4($t2)
subi $t3 $t3 1
sw $t3 0($t2)

la $t1 snakePosX
lw $t3 4($t1)
sw $t3 0($t1)

li $s1 4
mul $t5 $t5 $s1
add $t1 $t1 $t5
add $t2 $t2 $t5
lw $t1 0($t1)
lw $t2 0($t2)
sw $t1 0($s3)
sw $t2 4($s3)
lw $t5 tailleSnake
addi $t5 $t5 1
sw $t5 tailleSnake
j Exi

MoveCandy:
jal newRandomObjectPosition # G�n�re des positions al�atoires pour le nouveau bonbon
sw $v0 candy #Sauvegarde la position en X du nouveau bonbon
sw $v1 candy + 4 #Sauvegarde la position en Y du nouveau bonbon

NewObstacle:
lw $t1 numObstacles
la $t2 obstaclesPosX
la $t3 obstaclesPosY

li $s1 4
mul $t1 $t1 $s1
add $t2 $t2 $t1
add $t3 $t3 $t1

jal newRandomObjectPosition
sw $v0 0($t2)
sw $v1 0($t3)

#Augmente le nombre d'obstacles
lw $t1 numObstacles
addi $t1 $t1 1
sw $t1 numObstacles

Exi:
lw $ra 0($sp)
lw $t0 4($sp)
lw $t1 8($sp)
lw $t2 12($sp)
lw $t3 16($sp)
lw $t4 20($sp)
lw $t5 24($sp)
lw $t6 28($sp)
lw $t7 32($sp)
lw $t8 36($sp)
lw $t9 40($sp)
lw $s1 44($sp)
lw $s2 48($sp)
lw $s3 52($sp)
addu $sp $sp 56
jr $ra

############################### conditionFinJeu ################################
# Paramètres: Aucun
# Retour: $v0 La valeur 0 si le jeu doit continuer ou toute autre valeur sinon.
################################################################################

conditionFinJeu:

# Aide: Remplacer cette instruction permet d'avancer dans le projet.
li $v0 1

jr $ra

############################### affichageFinJeu ################################
# Paramètres: Aucun
# Retour: Aucun
# Effet de bord: Affiche le score du joueur dans le terminal suivi d'un petit
#                mot gentil (Exemple : «Quelle pitoyable prestation!»).
# Bonus: Afficher le score en surimpression du jeu.
################################################################################

affichageFinJeu:

la $t1 scoreJeu
lw $a0 0($t1)
li $v0 1
syscall

la $a0 motgentil
li $v0 4
syscall

# Fin.

jr $ra
