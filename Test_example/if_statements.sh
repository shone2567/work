# why bash tends to use -ge or -eq instaed of >= or ++, it's because this condition type originates from command, where -ge and -eq are options

# Different Condition syntaxes
# 1. Single-Bracket conditions
# 	file-based conditions, if [-L symboliclink]; then
# 	string-based conditions,  if ["$stringvar1" == "cheese"]; then
# 	arithmetic conditions, if [$num -lt 1]; then
#

# 2. Double-bracket syntax  (double -bracket syntax serves as an enchanced version of the single-bracket syntax)
#	Globing features, if [[ "$stringvar" == *[sS]tring* ]]; then
#	word splitting ,  if [[ $stringvarwithspace != foo ]]; then
#       not exapnding filenames, if [[ -a *.sh]]; then
#       combing expressions, if [[$num -eq 3 && "$stringvar" == foo]]; then
#	  
#	** double-bracket syntax may have portable issue. It is not in POXSI standard	

# 3. Double-parenthesis syntax
#	arithmetic conditions, if (($num <=5 )); then


echo "interger comparsion"

decimal=15
octal=017                 # = 15 (decimal)
hex=0x0f                  # = 15 (decimal)

echo "single bracket"

if [ "$decimal" -eq "$octal" ]
then
	echo "$decimal equals $octal"
else
	echo "$decimal is not equal $octal"
fi

echo
echo "double brackets"

if [[ "$decimal" -eq "$octal" ]]
then
	echo "$decimal equals $octal"
else
	echo "$decimal is not equal $octal"
fi

echo
echo "double brackets"

if [[ "$decimal" -eq "$hex" ]]
then
	echo "$decimal equals $hex"
else
	echo "$decimal is not equal $hex"
fi

echo
echo "double parenthesis"

if (( decimal == hex))
then
	echo "$decimal equals $hex"
else
	echo "$decimal is not equal $hex"
fi


echo
echo string comaprsion
echo 

a="I eat an apple"
b="I eat two apples"



if [ "$a" = "$b" ]
then
	echo "string $a equal string $b"
else
	echo "string $a is not equal string $b"
fi

if [ "$a" != "$b" ]
then
	echo "string \"$a\" is not equal string \"$b\""
else
	echo "string \"$a\" is equal string \"$b\""
fi


echo
echo compund comparsion
echo

expr1=1
expr2=$false

if [ 1 -eq 2 -a "expr2" ]
then
	echo "Both expr1 and expr2 are true"
else
	echo "Either expr1 or expr2 is false"
fi


exit 0















