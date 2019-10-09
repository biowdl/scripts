Release checklist
- [ ] Check outstanding issues on JIRA and Github
- [ ] Publish documentation (`updateDocs.sh`) from `develop` branch
  - [ ] Copy docs folder to `gh-pages` branch
  - [ ] Overwrite existing develop folder with docs folder on `gh-pages`
  - [ ] Push changes to `gh-pages branch`
- [ ] Check [latest documentation
](https://biowdl.github.io/) looks fine
- [ ] Update all submodules to latest master with: `git submodule foreach "git checkout master;git pull; git submodule foreach --recursive 'git fetch'; git submodule update --init --recursive"`
- [ ] check all submodules are tagged correctly with `git submodule`
- [ ] run tests to confirm to be released version works.
- [ ] Change current development version in `CHANGELOG.md` to stable version.
- [ ] Run the release script `release.sh`
  - [ ] Check all submodules are tagged
  - [ ] Merge the develop branch into `master`
  - [ ] Created an annotated tag with the stable version number. Include changes 
    from changelog.md.
  - [ ] Confirm or set stable version to be used for tagging
  - [ ] Push tag to remote.
  - [ ] Merge `master` branch back into `develop`.
  - [ ] Add updated version number to develop
- [ ] Publish documentation (`updateDocs.sh`) from `master` branch
  - [ ] Copy docs folder to `gh-pages` branch
  - [ ] Rename docs to new stable version on `gh-pages`
  - [ ] Set latest version to new version
  - [ ] Push changes to `gh-pages branch`
- [ ] Create a new release from the pushed tag on github
  
  
