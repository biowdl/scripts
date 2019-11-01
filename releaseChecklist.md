Release checklist
- [ ] Check outstanding issues on JIRA and Github
- [ ] Generate inputs overview using wdl-aid:
  `wdl-aid --strict -t scripts/docs_template.md.j2 pipeline.wdl > docs/inputs.md`
- [ ] Publish documentation (`updateDocs.sh`) from `develop` branch
  - [ ] Copy docs folder to `gh-pages` branch
  - [ ] Overwrite existing develop folder with docs folder on `gh-pages`
  - [ ] Push changes to `gh-pages branch`
- [ ] Check [latest documentation
](https://biowdl.github.io/) looks fine
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
  
  
