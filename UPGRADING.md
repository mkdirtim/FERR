# Upgrading from upstream (opencode)

Policy: only merge upstream release tags into `openhack` (never merge upstream branches).

## Notes
- Upstream release tags are `vX.Y.Z` (leading `v`). Example: `v1.5.4`.
- To see whether a tag exists without fetching:

  git ls-remote --tags --refs upstream | rg -n 'v1\\.5\\.4$'

  # grep alternative (if rg isn't available)
  git ls-remote --tags --refs upstream | grep -E 'refs/tags/v1\\.5\\.4$'

## Upgrade steps
1) Fetch tags:

  git fetch upstream --tags --prune-tags

2) Create upgrade branch:

  NEW_TAG=vX.Y.Z
  git checkout openhack
  git pull --ff-only origin openhack

  # sanity check the tag exists locally
  git rev-parse -q --verify "refs/tags/${NEW_TAG}^{commit}"

  git checkout -b upgrade/opencode-${NEW_TAG}

3) Merge the tag with an explicit merge commit:

  git merge --no-ff "${NEW_TAG}" -m "Upgrade upstream opencode to ${NEW_TAG}"

4) Push and open a PR:

  git push -u origin HEAD

5) After the PR is merged to `openhack`, tag the upstream base commit (not the merge commit):

  git checkout openhack
  git pull --ff-only origin openhack

  UPSTREAM_SHA="$(git rev-parse ${NEW_TAG}^{commit})"
  git tag -a "upstream-opencode-${NEW_TAG}" "${UPSTREAM_SHA}" -m "Upstream base: anomalyco/opencode ${NEW_TAG}"
  git push origin "upstream-opencode-${NEW_TAG}"

## Reapplying fork customizations

After merging an upstream tag, cherry-pick the fork-maintenance commits:
- prune upstream-only directories
- reapply fork root manifest/patch consistency

  git cherry-pick <PRUNE_COMMIT_SHA>
  git cherry-pick <FORK_FIX_COMMIT_SHA>
  # resolve any conflicts, then test:
  bun run typecheck
  cd packages/opencode && bun run test

### Current prune commit

  SHA: ef477d051
  Message: fork: prune upstream-only directories

### Current fork-fix commit

  SHA: eea6468ee
  Message: fork: fix workspace and patch consistency

This commit deletes 715 files (116,053 lines) — whole-directory removals only,
no individual file changes within kept packages. This minimizes conflicts.

### Directories removed by the prune commit

  README*.md, .github/, .opencode/agent/, .opencode/tool/, .vscode/,
  github/, infra/, nix/, packages/console/, packages/containers/,
  packages/docs/, packages/enterprise/, packages/extensions/,
  packages/function/, packages/identity/, packages/slack/,
  packages/web/, patches/, script/, sdks/, specs/

### Resolving conflicts

If upstream added new files in a pruned directory, the cherry-pick will
conflict. Resolution is straightforward — accept the deletion:

  git rm -r <conflicting-directory>
  git cherry-pick --continue

After resolving, update the prune commit SHA in this file and in TODOs.md.

### Full upgrade + prune example

  git fetch upstream --tags --prune-tags

  NEW_TAG=vX.Y.Z
  PRUNE_SHA=ef477d051
  FORK_FIX_SHA=eea6468ee

  git checkout openhack
  git pull --ff-only origin openhack
  git checkout -b upgrade/opencode-${NEW_TAG}

  git merge --no-ff "${NEW_TAG}" -m "Upgrade upstream opencode to ${NEW_TAG}"
  git cherry-pick ${PRUNE_SHA}
  git cherry-pick ${FORK_FIX_SHA}
  # resolve conflicts if any, run tests

  bun run typecheck
  cd packages/opencode && bun run test
  cd ../..

  git push -u origin HEAD
  # open PR, merge, then tag (see step 5 below)

## Worked example
Upgrade from `v1.1.52` to `v1.1.53`:

  git fetch upstream --tags --prune-tags

  NEW_TAG=v1.1.53
  git checkout openhack
  git pull --ff-only origin openhack
  git rev-parse -q --verify "refs/tags/${NEW_TAG}^{commit}"

  git checkout -b upgrade/opencode-${NEW_TAG}
  git merge --no-ff "${NEW_TAG}" -m "Upgrade upstream opencode to ${NEW_TAG}"
  git push -u origin HEAD

After merging that PR:

  git checkout openhack
  git pull --ff-only origin openhack
  UPSTREAM_SHA="$(git rev-parse ${NEW_TAG}^{commit})"
  git tag -a "upstream-opencode-${NEW_TAG}" "${UPSTREAM_SHA}" -m "Upstream base: anomalyco/opencode ${NEW_TAG}"
  git push origin "upstream-opencode-${NEW_TAG}"
