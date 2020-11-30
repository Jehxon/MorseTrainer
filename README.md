# MorseTrainer
This is a python program to help one to learn morse letters. It is a mini-game that plays audio morse letters,
and wait for the user to guess what letter the sound corresponds to. The user has 3 attempts.

It allows the user to choose between to modes : 
* #### Infinity mode :
This mode plays letters in a completely random way, and doesn't have an end. It can be stopped by typing "stop" instead of an answer.
* #### Elimination mode :
In this mode, correctly guessed letters won't be played again. The program then ends when there is no letters left.

## Installation
This requires the sox package to be installed. It can be installed with `sudo apt-get install sox`.
This is a simple python script. Launch it directly in a console with python 3.
