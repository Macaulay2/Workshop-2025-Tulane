# Git intro tutorial

20 years ago Linus Torvalds created `git` (in 10 days). 

* Clone the workshop repo (see the detailed instructions on the wiki)
```
git clone git@github.com:Macaulay2/Workshop-2025-Tulane.git 
```
* Switch to the mini school branch:
 ```
 cd Workshop-2025-Tulane
 git checkout MiniSchool
 ``` 
* Create file `FirstLastname.md` in the directory `HelloWorld/` and fill it with your personal message to the world
* Check status (do this often; every time you don't remember exactly what the status is):
```
git status
```  
* _Stage_ the file:
```
git add HelloWorld/FirstLastname.md 
```
* Check status
* Basic "update loop":
  - _Pull_ changes (e.g. your friends' commits) from the _remote_: 
  ```
  git pull
  ```
  - _Commit_ changes
  ```
  git commit -m "hello world from ..."
  ```
  - _Push_ your commits
  ```
  git push
  ```
* Conflicts...
  - ...are inevitable in large projects
  - check status (at any time) to see if you have any 
  - a basic way to resolve 
    * edit the conflicted file, e.g. `file-with-conflict.m2`
    * stage the changes when done (`git add file-with-conflict.m2`)
    * execute the "update loop" above

     