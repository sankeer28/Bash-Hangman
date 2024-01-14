#!/bin/bash
mapfile -t words < words.txt
mapfile -t hints < hints.txt
words=("${words[@],,}")
index=$((RANDOM % ${#words[@]}))
word=${words[$index]}
hint=${hints[$index]}
guess=$(echo "$word" | sed 's/./_/g')
lives=6
hangman=("
  +---+
  |   |
  O   |
 /|\  |
 / \  |
      |
=========" "
  +---+
  |   |
  O   |
 /|\  |
 /    |
      |
=========" "
  +---+
  |   |
  O   |
 /|\  |
      |
      |
=========" "
  +---+
  |   |
  O   |
 /|   |
      |
      |
=========" "
  +---+
  |   |
  O   |
  |   |
      |
      |
=========" "
  +---+
  |   |
  O   |
      |
      |
      |
=========" "
  +---+
  |   |
      |
      |
      |
      |
=========")

echo "Welcome to Bash Hangman!"
echo "Hint: $hint"

while (( lives > 0 )); do
    echo "${hangman[6-lives]}"
    echo "You have $lives lives left."
    echo "Word: $guess"
    read -p "Guess a letter: " -n 1 -r letter
    echo
    letter=${letter,,}

    if [[ $word == *$letter* ]]; then
        for (( i=0; i<${#word}; i++ )); do
            if [[ ${word:$i:1} == $letter ]]; then
                guess=${guess:0:$i}$letter${guess:$((i+1))}
            fi
        done
    else
        ((lives--))
        echo "Incorrect! You have $lives lives left."
    fi

    if [[ $guess == $word ]]; then
        echo "Congratulations, you won! The word was $word."
        exit
    fi
done

echo "${hangman[6-lives]}"
echo "Sorry, you lost. The word was $word."

