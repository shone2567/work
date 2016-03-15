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
#	

#3. Double-parenthesis syntax
#	arithmetic conditions, if (($num <=5 )); then


