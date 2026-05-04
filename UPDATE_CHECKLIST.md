# Update Checklist

This is the repeatable flow for merging upstream updates while keeping the VW manual-transmission fixes intact.

## 1. Update `opendbc_repo` first

```bash
cd /Users/robkoehler/Documents/GitHub/openpilot-clean/opendbc_repo
git fetch upstream
git checkout master
git merge upstream/master
```

If Git opens the editor:

1. Press `Esc`
2. Type `:wq`
3. Press `Enter`

Verify the VW manual-transmission fix is still present:

```bash
grep -n "TransmissionType.manual\\|BCM1_Rueckfahrlicht_Schalter\\|0xAD in fingerprint\\[0\\] or docs" opendbc/car/volkswagen/interface.py opendbc/car/volkswagen/carstate.py
```

Push `opendbc_repo`:

```bash
git push origin master
```

## 2. Update the parent `openpilot-clean` repo

```bash
cd /Users/robkoehler/Documents/GitHub/openpilot-clean
git reset --hard HEAD
git clean -fd
git lfs install --local --skip-smudge
git config lfs.skipSmudge 1
git config fetch.recurseSubmodules false
git submodule update --init --recursive opendbc_repo
git fetch upstream
git checkout master
git merge upstream/master
```

If `opendbc_repo` conflicts during the parent merge:

```bash
git checkout --ours opendbc_repo
git add opendbc_repo
GIT_EDITOR=true git commit
```

Push the parent repo:

```bash
git push origin master
```

If GitHub/LFS complains about a missing docs or image object:

```bash
git config lfs.allowincompletepush true
git push origin master
git config --unset lfs.allowincompletepush
```

## 3. Sanity-check the submodule pointer

```bash
cd /Users/robkoehler/Documents/GitHub/openpilot-clean
git -C opendbc_repo rev-parse HEAD
git ls-tree HEAD opendbc_repo
```

If the SHAs match, the parent repo and submodule are aligned.

## 4. Update the comma

1. Open `Settings`
2. Open `Software`
3. Tap `Check for Update`

## 5. Quick post-update check

Verify:

- the install completes cleanly
- the car still identifies correctly
- engagement still works
- `wrongGear` does not come back

## 6. Optional: tag a known-good state

```bash
cd /Users/robkoehler/Documents/GitHub/openpilot-clean
git tag -a post-update-YYYYMMDD -m "Known good update state"
git push origin post-update-YYYYMMDD
```
