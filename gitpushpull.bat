@echo off
cd "G:/My Drive/Methods/ML_R"

REM Check if the folder is already a Git repository
if not exist .git (
    git init
    echo Initialized Git repository.
) else (
    echo Git repository already exists.
)

REM Check if the remote origin is already set
git remote | find "origin" >nul
if errorlevel 1 (
    git remote add origin https://github.com/r4miao/ML_r.git
    echo Remote origin added.
) else (
    echo Remote origin already exists.
)

git pull origin main --allow-unrelated-histories
git add .
git commit -m "Automated commit"
git push origin main
pause
