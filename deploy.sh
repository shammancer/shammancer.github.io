git checkout master
git pull
cp -rf build/* ./
git add ./
git commit -m "New version (`date`) deployed using deploy.sh"
git push
git checkout source
