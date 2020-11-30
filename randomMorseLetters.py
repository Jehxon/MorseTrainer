from time import sleep
import os
from random import randrange

tempo = 0.1 #Un dixième de seconde par temps
frequency = 500

class Lettre:
    #Une lettre est constituée d'un nom, d'un son (enchaînement de dash et de dot)
    #On doit pouvoir les jouer, et les afficher

    def __init__(self, name, sound):
       self.name = name
       self.sound = sound

    def play(self):
        for s in self.sound:
            if(s == '.'):
                duration = 1
            elif(s == '-'):
                duration = 3
            else:
                duration = 0
                print('Lettre non reconnue !')


            os.system('play -nq -t alsa synth %s sin %s ' % (duration * tempo, frequency))

with open('lettersInMorse.txt') as f:
    alphabet = f.readlines()

letters = []

for i,l in enumerate('ABCDEFGHIJKLMNOPQRSTUVWXYZ'):
    letters.append(Lettre(l,alphabet[i].strip()))

print('Bienvenue dans ce programme d\'entraînement au morse ! Dans ce programme vous allez pouvoir entendre des lettres morses jouées et vous devrez les identifier. Bonne chance !')

# Choix du mode
print("Choisissez un mode : Elimination / Infini")
mode = input("e/i ?")

if(mode == 'e'):
    mode = "Elimination"
else:
    mode = "Infini"


print("Entrez 'stop' pour arrêter")



nbLetters = 26
score = 0

while nbLetters > 0:
    # Choix de la lettre
    choice = randrange(nbLetters)
    print('Quelle est cette lettre ?')
    l = letters[choice]

    # On donne 3 essais
    essais = 0
    while(essais < 3):

        # On joue le son
        l.play()

        # User input
        ans = input().capitalize()
        essais += 1

        if(ans == "Stop"):
            break

        if(ans != l.name):
            print('Raté ! Il reste %s essais.' % str(3-essais))
        else:
            os.system('play -nq -t alsa synth %s sin %s ' % (0.2, 200))
            os.system('play -nq -t alsa synth %s sin %s ' % (0.2, 1000))
            if(mode == "Elimination"):
                nbLetters -= 1
                letters.pop(choice)
            score += 1
            #print("Score : %i" %score)
            break

    if(essais > 1):
        print("C'était la lettre %s." % l.name)
        l.play()

    sleep(1)

    if(ans == "Stop"):
        break
