#showing all commits log
git log --all --oneline --decorate --graph
#shoing all remote commits and branches 
git ls-remote <remote>

#USE CASE: Undo a commit and redo (Example - Before Push!!)
git commit -m "Something terribly misguided"              (1)
git reset --soft HEAD~                                    (2)
<< edit files as necessary >>                             (3)
git add ...                                               (4)
git commit -c ORIG_HEAD                                   (5)

#NOTE: Please also check "man git - Example section"... very useful as well...
