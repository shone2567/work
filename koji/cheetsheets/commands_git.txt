Command	Chapter		Example	Remark
git init				
git clone <git URL>				
git clone -o <remote name> <git URL>				clone with different remote name (instead of origin)
git add <file name>				bring the change to staging
git rm <removed file name>				bring the change to staging (change = remove file) remove the file from both index and workingspace
git rm /\*.log				
git rm \*~				
git rm --cached <file name>				removed form the index (staging) and keep the file "untracted" and keep the file in workingspace
git mv <file from> <file to>				"the same as:
mv <file from> <file to>
git rm <file from>
git add <file to>"
git status				
git status -s				
				
git diff --staged			git diff --cached	will not take care (add any) of those untracked files.
git commit -m "<message>"				
git commit -a -m "<message>"				
				
git log				
git log -p				showing detail  in diff
git log -2				showing last 2 log
git log -p -2				
git log --stat				showing log in abbreviated format
git log --pretty=oneline				
git log --pretty=format:"%h - %an, %ar : %s"				example: ca82a6d - Scott Chacon, 6 years ago : changed the version number
git log --pretty=format:"%h %s" --graph				
				
git commit --amend	2.4			updating within the same commit = replace current branch by creating a new commit
git reset HEAD <file name>				to unstage from staging.
git checkout -- <file name>				unmodifying a modified file
				
git remote				
git remote -v				showing remote name
git remote show <remote name>				
git remote add <short name> <git reop url>				adding remote repositories
				
git remote rename <remote from> <remote to>				
git remote rm <remote to be delteted>	2.5			
				
				
git clone <url>				
git fetch <remote name>				will add new work from remote but do not merge, you need to merge yourself
git pull <remote name>				will add new work from remote but do merge
git push <remote name> <branch name>				
				
git tag -a <tag> -m <comment>			git tag -a v1.4 -m "my ver 1.4"	for current commit to tag
git tag -a <tag> <commit checksum>	2.6			for later to tag on certain commit (checksum)
git tag <tag>				
git tag				list all tags
git show <tag>				
				
git push <remote name> <tag>				push one tag
git push <remote name> --tags				push many tags
				
git config --global alias.<short aliases> "<command keywords>"			git config --global alias.unstage 'reset HEAD --'	
				
				
				
git branch <new branch name>				create new branch (but HEAD is not pointing at the new branch yet.)
git checkout <branch name>				HEAD moves and pointing to the branch name
				
git log --oneline --decorate				Note: --decorate option will show the branch and HEAD pointer
				
git checkout -b <new created branch>			git branch <new branch> + git checkout <new branch>	
git merge <to another branch merge in>				
git branch -v				show all branch in detail
git branch --merged				show merged branched you are on
git branch --no-merged				show non merged branches
git branch -d <branch>				delete merged branch
git branch -D <branch>				delete branch where not yet merged (force delete)
				
git fetch <remote>				
				
git push <remote> <your branch>				
				
git checkout -b <branch> <remote>/<branch>	3.5		git checkout --track <remote>/<branch>	this will trach the branch instead of master
				
git push <remote> --delete <branch>				delete remote branch
				
				
git rebase <branch basedwith>	3.6		"git checkout currentbranch
git rebase master
git checkout master
git merge currentbranch #now merge and currentbranch are at the same commit."	from current branch rebase to the <branch to>
git rebase --onto <branch base> <branch sibling> <branch main>	3.6	Fig. 3-32		

