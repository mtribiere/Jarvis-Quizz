#!/bin/sh

#Initialisation des fichiers pour le test
jv_pg_initQuizzQuestion(){

#Definir le chemin d'acces
chemin=${PWD}"/plugins_installed/Jarvis-Quizz"

#Effacer les resultats des precedents quizzs
echo -n ""> $chemin/operations.txt;
echo -n "">$chemin/results.txt;
echo "0">$chemin/currentQuestion.txt;
echo -n "">$chemin/userResponses.txt;

#Ecrire les opérations et les résultats dans les fichiers textes
for i in {1..5}
do
   a=$(( $RANDOM % 10 ));
   let "a = a+1";
   b=$(( $RANDOM % 10 ));
   let "b = b+1";
   let "c=a*b";
   echo "$a fois $b">>$chemin/operations.txt;
   echo "$c">>$chemin/results.txt;
done
}



#Passage a la question suivante
jv_pg_quizzNextQuestion(){

#Definir le chemin d'acces
chemin=${PWD}"/plugins_installed/Jarvis-Quizz";

#Recuperer la question courrante, afficher la suivante, et mettre a jour l'indice courrant
typeset -i currentQuestion=$(cat $chemin/currentQuestion.txt);
say "Question $currentQuestion :";

#Stocker la reponse
if [ $currentQuestion -ne 0 ]
then
	echo "$response" >> $chemin/userResponses.txt;
fi

#Afficher la ligne correspondante
declare -i currentLine=0;

while read LINE;
do
        if [ $currentLine = $currentQuestion ]
        then
                say "$LINE";
        fi
        let "currentLine = currentLine+1";
done < $chemin/operations.txt

#Mettre a jour l'indice courrant
let "currentQuestion = currentQuestion + 1";
echo "$currentQuestion">$chemin/currentQuestion.txt;
}




#A la fin du questionnnaire
jv_pg_quizzResults(){

#Definir le chemin d'acces
chemin=${PWD}"/plugins_installed/Jarvis-Quizz";

#Ajouter la dernière reponse
echo "$response" >> $chemin/userResponses.txt

#Recuperer toutes les reponses utilisateurs
declare -i currentLine=0;
while read LINE
do
	Responses[currentLine]=$LINE;
	let "currentLine = currentLine + 1";
done < $chemin/userResponses.txt;

#Calculer le score
declare -i currentLine=0;
declare -i score=0;
while read LINE;
do
        if [ "$LINE" = "${Responses[$currentLine]}" ]
        then
                let "score = score+1";
        fi
        let "currentLine = currentLine+1";
done < $chemin/results.txt
say "Fin du questionnaire ! Votre score est de $score sur 5";
}
