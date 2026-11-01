# 02 Git and GitHub

How I use version control for data work: commits, branches, pull requests and reviewing changes.

**Git** records every change to my files, so I can see what changed, when, and go back if something breaks. 
**GitHub** is the website where I keep a Git project online and share it.

## Words I use

- **Repository (repo):** a project folder with its full history. Mine: Data-analytics-engineer-roadmap.
- **Commit:** a saved snapshot with a short message. Example from my repo: "Add SQL notes, practice queries and interview answers".
- **Branch:** a separate line of work, so I can try something without touching the main version. The default branch is called `main`.
- **Pull request:** a proposal to merge a branch into `main`, so someone can review the changes first.
- **Clone, push, pull:** copy a repo to my laptop (clone), send my commits to GitHub (push), get new changes from GitHub (pull).

## Good commit messages

One line, starting with a verb, saying what changed: "Add pandas ETL notes", not "update" or "stuff".

## Commands I will practise

    git clone <repo-url>      copy the repo to my laptop
    git status                see what changed
    git add <file>            choose what goes into the next commit
    git commit -m "message"   save the snapshot
    git push                  send it to GitHub
    git pull                  get the latest version
    git switch -c my-branch   start a new branch

## Why it matters for data work

SQL and data models are code. Version history, reviews before changes go live, and automatic tests (CI/CD, later in this repo) all depend on Git.
