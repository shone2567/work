#Some useful commands
##About basic writing and formatting syntax in github:
###https://help.github.com/articles/basic-writing-and-formatting-syntax/

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


##disconnect network interface (=ifdown)
sudo nmcli device disconnect [eno33554984]
##adding network connection/device (this will create ifcfg-mgmt file…)
sudo nmcli connection add type ethernet con-name [mgmt.] ifname [eno33554984] ip4 [10.0.0.11/24] gw4 [10.0.0.1] #this will create ifcfg-mgmt file
##similiar to ifup….
sudo nmcli connection up [mgmt] ifname [eno33554984]
##check network device status
nmcli device status
##changing ip address
nmcli connection modify [mgmt] ipv4.addresses [new ipaddress/bitmast]
##changing onboot=yes
nmcli connection modify [mgmt] connect.autoconnect yes
##check network connection status in detail
nmcli -p connection show [mgmt]
##disconnect network interface (=ifdown) again…
sudo nmcli device disconnect eno33554984
##delete the ifcfg file (if you want…)
sudo nmcli connection delete mgmt.


source:
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/sec-Using_the_NetworkManager_Command_Line_Tool_nmcli.html

##renaming network device (example):
/sbin/ip link set eth1 down
/sbin/ip link set eth1 name eth123
/sbin/ip link set eth123 up

###see also:
http://unix.stackexchange.com/questions/205010/centos-7-rename-network-interface-without-rebooting

##Changing file contents and back up original file:
example 1: `echo "test.txt" | xargs sed -i .bkup -E "s/# ServerName .+/ServerName controller/"`
example 2: `sed -i .bkup -E "s/# ServerName .+/ServerName controller/" test.txt`
##Use `sed` to output matched string
try the followings and check output:
####1. `echo "today is friday." | sed "s/friday/monday/"`
####2. `echo "today is friday." | sed -E "s/(.+day) is (.+day)./\2 is \1/"`
####3. `echo "today is friday." | sed -E "s/.+(fri.*).+/\1/"`
####4. `echo "today is friday." | sed -E "s/(fri.*)./\1/"`
####4. `echo "today is friday." | sed -E "s/(fri.*)/\1/"`
