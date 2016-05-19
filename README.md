# git-memo
a handy list of git commands

## Adding a local project on remote
https://help.github.com/articles/adding-an-existing-project-to-github-using-the-command-line/

## Creating branch
```
#creates local branch
git checkout -b [branch-name]
# update remote on github and updates tracking
git push origin [branch name]
```

## Moving to a branch
`git checkout [branch-name]`

## Updating list of available branches
`git remote update origin --prune`


## Merging and deleting a branch
```
#change to master branch
git checkout master
#merge from branch to master
git merge [branch-name]
#update master
git push
#delete local branch
git branch -d [branch-name]
#delete remote branch
git push origin :[branch-name]
# OR
# git push origin --delete {{nome branch}}
```

## Removes local orphan branches
`git fetch --all --prune`

## Reset single file to the last commit
`git checkout HEAD -- my-file.txt`


