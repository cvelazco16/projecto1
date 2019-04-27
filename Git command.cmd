$ git

$ git init

$ git config --global user.name "Cesar Velazco"

$ git config --global user.email "cvelazco@gmail.com"

$ echo "Git rocks" >> file.txt

$ git add file.txt

$ git status

$ git commit --message "First commit"
$ git commit -m "First commit"

$ echo "file modified" >>file.txt
$ git add file.txt

$ git commit
Vim
$ :wq


$git add .

$ git commit --amend --reset-author

$ git log
$ git log --format=fuller
$ git log --format=raw
$ git cat-file -p a57d7

Porcelain commands and plumbing commands
Porcelain commands as interface commands to the user, while the plumbing works at a low level.

There are four types of objects in git:
Commit, tree, blob and annotated tag.

$ git cat-file -p 54efd02356267
tree 962294e6ac218d1d6ba59492686ff7e9b3047fca
author Cesar Eloy <cvelazco16@gmail.com> 1553057629 -0500
committer Cesar Eloy <cvelazco16@gmail.com> 1553057629 -0500
Comentario de Commit 1

Tree - The tree is a container for blobs and othe/objer trees.
$ git cat-file -p 962294e
100644 blob 4cd7b4a07948301fa08e6619ee7cafe3517cd6dc    pruebas texto.txt

Blobs -  Git blobs represent the files
[17] ~/grocery (master)
$ git cat-file -p 637a0
banana

Blobs are binary files. Retain inside information belonging to any file, whether binary or textual, images, source code, archives, and so on. Everything is compressed and transformed into a blob before archiving it into a Git repository.
each file is marked with a hash; this hash uniquely identifies.

-files with different content will have different hashes


$ echo "banana" | git hash-object --stdin
637a09b86af61897fb72f26bfb874f2ae726db82

The git hash-object command is the plumbing command to calculate the hash of any object.

if you have two different files with the same content, even if they have different names and paths, in Git you will end up having only one blob.


Even deeper - the Git storage object model
storage in .git folder

[22] ~/grocery (master) 
$ ll .git/objects/63/
total 1
drwxr-xr-x 1 san 1049089 0 Aug 18 17:15 ./
drwxr-xr-x 1 san 1049089 0 Aug 18 17:15 ../
-r--r--r-- 1 san 1049089 20 Aug 17 13:34 7a09b86af61897fb72f26bfb874f2ae726db82

63 + 7a09b86af61897fb72f26bfb874f2ae726db82 is actually the hash of our shoppingList.txt blob!

those files are plain text files, but Git compresses them using the zlib library to reserve space on your disk. This is why we use the git cat-file -p command, which decompresses them on the fly for us.

$ git log --oneline # Allows us to see the log in a more compact way
718fb3a (HEAD -> master) Add an apple
f46c6b5 prueba

$ git cat-file -p e4a5e7b
tree 4c931e9fd8ca4581ddd5de9efd45daf0e5c300a0
parent a57d783905e6a35032d9b0583f052fb42d5a1308
author Ferdinando Santacroce <ferdinando.santacroce@gmail.com> 1503586854 +0200
committer Ferdinando Santacroce <ferdinando.santacroce@gmail.com> 1503586854 +0200

Add an apple

A parent of a commit is simply the commit that precedes it. In fact, the a57d783 hash is actually the hash of the first commit we made.

-the first commit did not have a parent.

Git doesn't use deltas

when you do a new commit, Subversion creates a new numbered revision that only contains deltas between the previous one; this is a smart way to archive changes to files, especially among big text files, because if only a line of text changes, the size of the new commit will be much smaller.
Instead, in Git even if you change only a char in a big text file, it always stores a new version of the file: Git doesn't do deltas (at least not in this case)

Git references
-the root-commit
-Master is precisely the name of the default branch of a Git repository, somewhat like trunk is for Subversion.

-In Git, a branch is nothing more than a label, a mobile label placed on a commit.

every leaf on a Git branch has to be labeled with a meaningful name to allow us to reach

$ git log --oneline --graph --decorate
* e4a5e7b (HEAD -> master) Add an apple
* a57d783 Add a banana to the shopping list
--graph : add an asterisk
--decorate : print (HEAD - > master) on the e4a5e7b
--oneline It resports every commit using one line

I made a commit without first making git add; the trick in the -a (--add)  option added to the git commit command.

$ git log --online --graph --decorate
* 0e4a5e7b (HEAD -> master) Add an orange

Branches are movable labels

How references work
Every time we make a commit to a branch, the reference that identifies that branch will move accordingly to always stay associated with the tip commit.

$ ls -l .git/refs/heads
-rw-r--r-- 1 san 1049089 41 Aug 25 11:20 master

$ cat .git/refs/heads/master
0e8b5cf1c1b44110dd36dea5ce0ae29ce22ad4b8

with a trivial text file! It contains the hash of the last commit made on the branch.

Creating a new branch
=====================
$ git branch berries

There are some (complicated) rules to be respected and things to know about the possible name of a branch (all you need to know is here: https://git-scm.com/docs/git-check-ref-format)

$ git log --oneline --graph --decorate
* 0e8b5cf (HEAD -> master, berries) Add an orange
* e4a5e7b Add an apple
* a57d783 Add a banana to the shopping list

$ git checkout berries
Switched to branch 'berries'

$ git log --oneline --graph --decorate
* 0e8b5cf (HEAD -> berries, master) Add an orange
* e4a5e7b Add an apple

HEAD, or you are here
=====================
As branches are, HEAD is a reference. It represents a pointer to the place on where we are right now.

$ cat .git/HEAD
ref: refs/heads/berries

The ref: part is the convention Git uses internally to declare a pointer to another branch.

$ git commit -am "Add a blackberry"
[berries ef6c382] Add a blackberry
 1 file changed, 1 insertion(+)
 
 $ git log --oneline --graph --decorate
* ef6c382 (HEAD -> berries) Add a blackberry
* 0e8b5cf (master) Add an orange
* e4a5e7b Add an apple
* a57d783 Add a banana to the shopping list

a branch is just a label that follows you while doing new commits, getting stuck to the last one.

$ cat .git/HEAD
ref: refs/heads/master

Reachability and undoing commits
===================================

$ git checkout -
Switched to branch 'berries'

Move me to the branch Previous ~/grocery (berries)

$ git reset --hard master

The git reset actually moves a branch from the current position to a new one; here we said Git to move the current berries branch to where master is,
commit is not more reachable when no branches points to it directly, nor it figures as a parent of another commit in a branch. Our blackberry commit was the las
from it, made it unreachable, and it disappears from our repository.

$ git reset --hard ef6c382
HEAD is now at ef6c382 Add a blackberry
recovered the lost commit!

won't delete unreachable commits, at least not immediately.
garbage collection features (look at the git gc command
undo a commit using the git reset command
you often have the need to point to a preceding commit

the tilde~ and the caret^. A caret basically means a back step, while two carets means two steps back, and so on.
you can use tilde: similarly, ~1 means a back step, while ~25 means 25 steps back, and so on.

$ git reset --hard HEAD^
HEAD is now at ef6c382 Add a blackberry

$ git reset --hard HEAD~3

Detached HEAD
=============
$ git checkout HEAD^
Note: checking out 'HEAD^'.

git checkout -b <new-branch-name>
detached HEAD state. Being in this state basically means that HEAD does not reference a branch, but directly a commit

[43] ~/grocery ((e4a5e7b...))

$ git log --oneline --graph --decorate --all
* a8c6219 (melons) Add a watermelon
* ef6c382 (berries) Add a blackberry
* 0e8b5cf (master) Add an orange
* e4a5e7b (HEAD) Add an apple

$ cat .git/HEAD
e4a5e7b3c64bee8b60e23760626e2278aa322f0

Git says that in this state we can look around, make experiments, doing new commits if we like, and then discard them simply by checking out an existing branch, or save them if you like creating a new branch.

#It exists the risk to lost the change

[49] ~/grocery ((07b1858...))
$ git checkout master

Warning: you are leaving 1 commit behind, not connected to
any of your branches.

#You can create a new branch.
$ git branch bug 07b1858

The reflogs
===========
the reference log, or reflog for short. Basically, the reflog (or better the reflogs, as there is one for every reference) records what happens in the repository while you commit, reset, check out, and so on

reflog records all the times that tips of the branches and other references (such as HEAD) where updated.

$ git reflog show
0e8b5cf HEAD@{0}: checkout: moving from 07b18581801f9c2c08c2 to master
07b1858 HEAD@{1}: commit: Bug eats all the fruits!
e4a5e7b HEAD@{2}: checkout: moving from master to HEAD^

this log will be cleared at some point; the default retention is 90 days

the movements berries branch did in the past:
[54] ~/grocery (master)
$ git reflog berries

Tags are fixed labels
=====================
Tags are labels you can pin to a commit, but unlike branches, they will stay there.

$ git tag bugTag

#Sirve para marcar un commit
$ git log --oneline --graph --decorate --all
* 07b1858 (HEAD -> bug, tag: bugTag) Bug eats all the fruits!

Tags are useful to give a particular meaning to some particular commits.

$ cat .git/refs/tags/bugTag
07b18581801f9c2c08c25cad3b43aeee7420ffdd

To delete a tag:
$ git tag -d <tag name>.

#By default the tag is set to last commit. You can reference a particular commit.
$ git tag myTag 07b1858.

Annotated tags
==============
Git has two kinds of tags; this is because in some situations you may want to add a message to the tag.

$ git tag -a annotatedTag 07b1858

At this point Git opens the default editor, to allow you to write the tag message.


* 5d605c6 (HEAD -> bug) Another bug!
* 07b1858 (tag: bugTag, tag: annotatedTag) Bug eats all the fruits!

$ cat .git/refs/tags/annotatedTag
17c289ddf23798de6eee8fe6c2e908cf0c3a6747

Staging area, working tree, and HEAD commit
===========================================
When you change the content of a file, when you add a new one or delete an existing one, you have to tell Git what of these modifications will be part of the next commit: the staging area is the container for this kind of data.

staging area (also known as an index)

[1] ~/grocery (master)
$ git status
On branch master
nothing to commit, working tree clean

Git says there's nothing to commit, our working tree is clean.

If I'm in the root of the repository I'm in a working directory, but if I walk through a subfolder, I'm in another working directory. This is technically true by a filesystem perspective, but while in Git, doing some operations such as checkout or reset does not affect the current working directory, but the entire... working tree. So, to avoid confusion, Git stopped talking about working directory in its messages and "renamed" it as working tree.


$ git status
On branch master
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

modified:   shoppingList.txt

no changes added to commit (use "git add" and/or "git commit -a")

added to the staging area, so they will be part of the next commit.

Git informs us: it tells that there is a modified file (in red color), and then offers two possibilities: stage it (add it to the staging area), or discard the modification, using the git checkout -- <file> command.

#Add all the files in this folder and subfolders to the staging area.
#the same as git add -A (or --all),
$ git add .

- Files in this folder and sub-folders I added in the past at least one time: This set of files is also known as the tracked files
- New files: These are called untracked files
- Files marked for deletion

#Stage all (new, modified, deleted) files
$ git add -A
#Stage all (new, modified, deleted) files
$ git add .
#Stage new and modified files only
git add --ignore-removal .
#Stage modified and deleted files only
$ git add -u

#Use wildcards
$ git add *.java


$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

modified:   shoppingList.txt
 
 if you want to unstage the change, you can use the git reset HEAD command: what does it mean? Unstage is a word to say remove a change from the staging area,
 
our  working tree is clean again; yes, because the effect of git commit is to create a new commit with the content of the staging area, and then empty it.

#Cuando ya hicimos unas primera vez git add file
#volvemos a modificar el mismo archivo (sin usar git add)
#nos muestra el siguiente mensaje

$ git status
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

modified:   shoppingList.txt

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

modified:   shoppingList.txt

$ git diff
# if you want to see the difference between the working tree version and the staging area one

$ git diff
diff --git a/shoppingList.txt b/shoppingList.txt
index f961a4c..20238b5 100644
--- a/shoppingList.txt
+++ b/shoppingList.txt
@@ -3,3 +3,4 @@ apple
 orange
 peach
 onion
+garlic

#working tree : After commit
#staging area : Before commit

$ git diff --cached HEAD
diff --git a/shoppingList.txt b/shoppingList.txt
index 175eeef..f961a4c 100644
--- a/shoppingList.txt
+++ b/shoppingList.txt
@@ -2,3 +2,4 @@ banana
 apple
 orange
 peach
+onion

the staging area, also known as an index, sometimes is called cache, hence the --cached option.

$ git diff HEAD
diff --git a/shoppingList.txt b/shoppingList.txt
index 175eeef..20238b5 100644
--- a/shoppingList.txt
+++ b/shoppingList.txt
@@ -2,3 +2,5 @@ banana
 apple
 orange
 peach
+onion
+garlic

Removing changes from staging area
==================================

add changes to the staging area, then you realize they fit better in a future commit

git reset HEAD <file>

$ git reset HEAD shoppingList.txt
Unstaged changes after reset:
M   shoppingList.txt

M on the left side means Modified; here Git is telling us we have unstaged a modification to a file.

A Added
D Deleted

using git status we see that now the staging area is empty, there's nothing staged.

#Head - Index
$ git dif --cached

#Head - Working tree
$ git diff

#Index Working tree
$ git diff HEAD

#Undo the modification we did
#be careful: git checkout -- is a destructive
#the double-dash is the way to tell Git I want to handle files, not branches.
$ git checkout -- <file>


#$ git reset -- <file> = git reset HEAD <file>


File status lifcycle
====================
$ git status

untracked file; an untracked file is basically a new file Git has never seen before.

(Untracked) -add file-> (Unmodified) -edit file-> (modified) -stage file-> (staged)

(Untracked) <-remove file- (Unmodified) <--------------commit------------- (staged)


All you need to know about checkout and reset
=============================================
$ git reset --hard master
HEAD is now at 603b9d1 Add a peach

This allows us to discard all the latest changes and go back to the latest commit on master, cleaning up even the staging area.

#delete the brach "bug"
$ git branch -d bug
error: The branch 'bug' is not fully merged.
If you are sure you want to delete it, run 'git branch -D bug'.

$ git branch -D bug
Deleted branch bug (was 07b1858).

Git checkout overwrites all the tree areas
===========================================

Git reset can be hard, soft, or mixed
=====================================

#heckout directly the penultimate commit on the master branch:

$ git checkout HEAD~1

check the differences with the staging area
$ git diff --cached HEAD

Check the differences between the working tree and HEAD commit:
$ git diff HEAD


$ git reset --soft master
$ git diff --cached HEAD
#moved the HEAD reference to the last commit in the master branch, the 603b9d1.

This soft-reset technique can help you quickly compare changes between two commits, as it only overwrites the HEAD commit area.
--mixed option (or simply using no options, as this is the default)

$ git reset --hard master
HEAD is now at 603b9d1 Add a peach

[47] ~/grocery ((603b9d1...))
$ git diff --cached HEAD

[48] ~/grocery ((603b9d1...))
$ git diff HEAD

This hard-reset technique is used to completely discard all the changes we did, with a git reset --hard HEAD command, as we did in our previous experiment


Rebasing
========
with git rebase you rewrite history; with this statement.

you can use rebase command to achieve the following:
-Combine two or more commits into a new one
-Discard a previous commit you did
-Change the starting point of a branch, split it, and much more

Reassembling commits
====================
git rebase command is for reordering or combining commits

$ echo -n "gr" >> shoppingList.txt
$ git commit -am "Add half a grape"

$ echo -n "ape" >> shoppingList.txt
$ git commit -am "Add the other half of the grape"

$ git log --oneline
f81402d (HEAD -> 2019-002) half grape
e4d809d half grape

# repair the mistake with an interactive rebase
# -i means interactive, while the HEAD~2 argument means I want to rebase the last two commits.

$ git rebase -i HEAD~2

#OPEN Vim
# we can change the order the commit lines.
pick = commit ok
reword =use commit, edit commit message
edit = use commit, stop amending
squash = use commit, meld (combinar) into previous commit
fixup = like squash but discard this commit's log
message = fixup is like squasr but let's provide you with a new commit message.
exec = run command (the rest of the line) using shell
drop = remove commit

reword edac12c Add half a grape
f 4142add9 Add the other half of the grape

Rebasing branches
=================
git rebase command you can also modify the story of branches
move the point where a branch started, bringing it to another point of the tree.

[1] ~/grocery (master)
$ git branch nuts 0e8b5cf

$ git checkout nuts

[6] ~/grocery (nuts)
$ git log --oneline --graph --decorate --all
* 9a52383 (HEAD -> nuts) Add a walnut
| * 6409527 (master) Add a grape
| * 603b9d1 Add a peach
|/
| * a8c6219 (melons) Add a watermelon
| * ef6c382 (berries) Add a blackberry
|/
* 0e8b5cf Add an orange
* e4a5e7b Add an apple
* a57d783 Add a banana to the shopping list

Now we want to move the nuts branch starting point, form an orange commit to a grape commit, as if the nuts branch is just one commit next to the master.

[7] ~/grocery (nuts)
$ git rebase master

# if you see the generated conflict
$ vi shoppingList.txt
$ git add shoppingList.txt
$ git rebase --continue
Applying: Add a walnut


Merging branches
================
-Files in their tip commit are different, so some conflict will rise
-Files do not conflict
-Commits of the target branch are directly behind commits of the branch we are merging, so a fast-forward will happen

Merge commit -> new commit
Fast-forward->Target branch + branch merging -> Target commit


#Merge the melons branch into the master
[1] ~/grocery (master)
$ git merge melons

Auto-merging shoppingList.txt
CONFLICT (content): Merge conflict in shoppingList.txt
Automatic merge failed; fix conflicts and then commit the result.

$ git merge 2019-003

Updating d44f750..9487598
Fast-forward
 prueba1.txt | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

#In case of conflict.
#To see
[2] ~/grocery (master|MERGING)
$ git diff
diff --cc shoppingList.txt
index 862debc,7786024..0000000
--- a/shoppingList.txt
+++ b/shoppingList.txt
@@@ -1,5 -1,5 +1,10 @@@
  banana
++<<<<<<< HEAD
 +peach
- grape
++grape
++=======
+ blackberry
+ watermelon
++>>>>>>> melons

#After saving the file
$ git add shoppingList.txt
$ git commit -m "Merged melons branch into master"

$ git cat-file -p HEAD
tree 2916dd995ee356351c9b49a5071051575c070e5f
parent 6409527a1f06d0bbe680d461666ef8b137ac7135
parent a8c62190fb1c54d1034db78a87562733a6e3629c
author Ferdinando Santacroce <ferdinando.santacroce@gmail.com> 15037542

#This commit has two parents! In fact, this is the result of the merge of two previous commits

Fast forwarding
===============
#This kind of merge not generates a new commit
#to merge the melons branch into a berries
#Git only needs to move the berries label to the same tip commit
#between the two are not in conflict

[8] ~/grocery (berries)
$ git merge melons
Updating ef6c382..a8c6219
Fast-forward
 shoppingList.txt | 1 +
 1 file changed, 1 insertion(+)
 
 
#If you want to force Git always create a new merge commit
$ git merge --no-ff melons

#Vim is opened for writer our comment. Accept the default message, save and exit.

#To undo un merge.
$ git reset --hard HEAD^

Cherry picking
==============
#you don't want to merge two branches, but simply your desire is to apply the same changes in a commit on top to another branch.
[1] ~/grocery (master)
$ git cherry-pick ef6c382
error: could not apply ef6c382... Add a blackberry

#Take commit ef6c382 (Add a blackberry) to insert in master.

#in case of conflict.
[2] ~/grocery (master|CHERRY-PICKING)
$ git diff

#Edit
[3] ~/grocery (master|CHERRY-PICKING)
$ vi shoppingList.txt

$ git add shoppingList.txt
$ git commit -m "Add a cherry-picked blackberry"

#to track what was the commit you cherry-picked, you can append the -x option to the git cherry-pick command

Git Fundamentals - Working Remotely
===================================
the main topics:
-Dealing with remotes
-Cloning a remote repository
-Working with online hosting services, such as GitHub

Git is a distributed version control syste

Working with remotes
====================
#a Git remote is another "place" that has the same repository you have on your computer. That can exchange data between themselves.
#custom git:// protocol

Clone a local repository
========================
$ git clone ~/grocery .

The dot . argument at the end of the command means clone the repository in the current folder, while the ~/grocery argument is actually the path where Git has to look for the repository.

$ git clone /e/05_git/pruebas .
Cloning into '.'...
done.

As you can see, other than the green master branch label, we have some red origin/<branch> labels on our log output.

The origin
==========
Git uses origin as the default name of a remote. Like with master for branches, origin is just a convention: you can call remotes whatever you want.

[5] ~/grocery-cloned (master)
$ git checkout berries
Branch berries set up to track remote branch berries from origin.
Switched to a new branch 'berries'

Look at the message, Git says that a local branch has been set up to track the remote one; this means that, from now on, Git will actively track differences between the local branch and the remote one.

[6] ~/grocery-cloned (berries)
$ git log --oneline --graph --decorate --all
* 6409527 (origin/master, origin/HEAD, master) Add a grape
| * ef6c382 (HEAD -> berries, origin/berries) Add a blackberry

Now a green berries label appears, just near the red origin/berries one; this makes us aware that the local berries branch and remote origin/berries branch point to the same commit.

$ git commit -am "Add a blueberry"
[berries ab9f231] Add a blueberry
Committer: Santacroce Ferdinando <san@intre.it>

To suppress this message by setting them explicitly:

git config --global user.name "Your Name"
git config --global user.email you@example.com

git commit --amend --reset-author

Sharing local commits with git push
===================================
#Git works locally
#if you want to share it with a remote counterpart. In Git, this is called push.
#to push the modifications in the berries branch to the origin

[10] ~/grocery-local (berries)
$ git push origin berries
Counting objects: 3, done.

#send only the objects it knows are not present in the remote to the remote
#Git tells us where it is sending object

Getting remote commits with git pull
====================================
#retrieving updates from the remote repository and applying them to our local copy.
#you have to be sure to be in the right local target branch.

$ git pull origin 2019-004
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.

#ANOTHER WAY

#it simply downloads remote objects; it won't merge them.

[20] ~/grocery-cloned (master)
$ git fetch
remote: Counting objects: 3, done.
remote: Compressing objects: 100% (2/2), done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (3/3), done.
From C:/Users/san/Google Drive/Packt/PortableGit/home/grocery
   741ed56..50851d2  master     -> origin/master

#Git found new objects on the remote, and it downloaded them.

$ git status
On branch master
Your branch is behind 'origin/master' by 1 commit

[22] ~/grocery-cloned (master)
$ git merge origin master
Updating 741ed56..50851d2
Fast-forward
 shoppingList.txt | 1 +
 1 file changed, 1 insertion(+)
 
 How Git keeps track of remotes
 ==============================
 #Git stores remote branch labels in a similar way to how it stores the local branches ones.
 
# in refs for the scope, with the symbolic name we used for the remote.
 
 [23] ~/grocery-cloned (master)
$ ll .git/refs/remotes/origin/

#The command to deal with remotes is git remote; you can add, remove, rename, list, and do a lot of other things with them; there's no room here to see all the options.


Working with a public server on GitHub
======================================
Setting up a new GitHub account
#In GitHub, you have to pay only if you need private repositories; for example, to store closed source code you base your business

https://github.com

Cloning the repository
======================
$ git clone https://github.com/fsantacroce/Cookbook.git















