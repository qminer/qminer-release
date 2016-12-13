echo "Creating $1 release for QMiner"

# create local clone
git clone git@github.com:qminer/qminer.git qminer_master
# install qminer and its dependancies
cd qminer_master
npm install
# update version
npm version $1 -m "New release: %s"
# update documentation
cd tools
./genNodeDoc.sh
cd ..
# commint new docs
git status
git commit -a -m "Documentation update"
# push updated version and master to main repo
git push
cd ..

# update CI branch
git config --global merge.ours.driver true
git clone git@github.com:qminer/qminer.git qminer_ci
cd qminer_ci
git checkout -b ci_matrix origin/ci_matrix
git merge master -m "[publish binary]"
git push origin ci_matrix:ci_matrix
cd ..

# update OSX binaries
git config --global merge.ours.driver true
git clone git@github.com:qminer/qminer.git qminer_osx
cd qminer_osx
git checkout -b osx-binaries origin/osx-binaries
git merge master -m "[publish binary]"
git push origin osx-binaries:osx-binaries
cd ..

# Wait for one hour and publish to NPM
echo "Waiting for stuff to build"
sleep 3600
cd qminer_master
npm publish
