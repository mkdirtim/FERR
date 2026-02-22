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

4) Reapply fork maintenance commits:

  PRUNE_SHA=aec6239af
  FORK_FIX_SHA=c8ec2b563
  git cherry-pick ${PRUNE_SHA}
  git cherry-pick ${FORK_FIX_SHA}

5) Regenerate lockfile and validate:

  bun install
  bun turbo typecheck
  bun turbo test

6) Push and open a PR:

  git push -u origin HEAD
  gh pr create --base openhack --head upgrade/opencode-${NEW_TAG} --fill

7) After the PR is merged to `openhack`, tag the upstream base commit (not the merge commit):

  git checkout openhack
  git pull --ff-only origin openhack

  UPSTREAM_SHA="$(git rev-parse ${NEW_TAG}^{commit})"
  git tag -a "upstream-opencode-${NEW_TAG}" "${UPSTREAM_SHA}" -m "Upstream base: anomalyco/opencode ${NEW_TAG}"
  git push origin "upstream-opencode-${NEW_TAG}"

8) Clean up merged upgrade branch:

  git branch -d upgrade/opencode-${NEW_TAG}
  git push origin --delete upgrade/opencode-${NEW_TAG}

9) Update upgrade docs for next cycle:
- `upgrading/HOWTO.md`
  - update `Current prune commit`
  - update `Current fork-fix commit`
  - add upgrade history row

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

  SHA: aec6239af
  Message: fork: prune upstream-only directories (v1.2.10)

### Current fork-fix commit

  SHA: c8ec2b563
  Message: fork: fix workspace and patch consistency

These are cherry-picked onto each upgrade. The prune commit deletes whole
directories only (no individual file changes within kept packages) to
minimize conflicts.

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

After resolving, update the prune commit SHA in this file.

### Full upgrade + prune example

  git fetch upstream --tags --prune-tags

  NEW_TAG=vX.Y.Z
  PRUNE_SHA=aec6239af
  FORK_FIX_SHA=c8ec2b563

  git checkout openhack
  git pull --ff-only origin openhack
  git rev-parse -q --verify "refs/tags/${NEW_TAG}^{commit}"
  git checkout -b upgrade/opencode-${NEW_TAG}

  git merge --no-ff "${NEW_TAG}" -m "Upgrade upstream opencode to ${NEW_TAG}"
  git cherry-pick ${PRUNE_SHA}
  git cherry-pick ${FORK_FIX_SHA}
  bun install
  bun turbo typecheck
  bun turbo test
  git add bun.lock && git commit -m "chore: regenerate bun.lock after ${NEW_TAG} upgrade"

  git push -u origin HEAD
  gh pr create --base openhack --head upgrade/opencode-${NEW_TAG} --fill
  # merge PR, then tag + clean up (see steps 7-9 above)

## Worked example
Latest upgrade from `v1.2.5` to `v1.2.10` (PR #3, merge 6b88eb639):

  git fetch upstream --tags --prune-tags

  NEW_TAG=v1.2.10
  PRUNE_SHA=aec6239af
  FORK_FIX_SHA=c8ec2b563

  git checkout openhack
  git pull --ff-only origin openhack
  git rev-parse -q --verify "refs/tags/${NEW_TAG}^{commit}"

  git checkout -b upgrade/opencode-${NEW_TAG}
  git merge --no-ff "${NEW_TAG}" -m "Upgrade upstream opencode to ${NEW_TAG}"
  git cherry-pick ${PRUNE_SHA}
  git cherry-pick ${FORK_FIX_SHA}
  bun install
  bun turbo typecheck
  bun turbo test
  git add bun.lock && git commit -m "chore: regenerate bun.lock after ${NEW_TAG} upgrade"
  git push -u origin HEAD
  gh pr create --base openhack --head upgrade/opencode-${NEW_TAG} --fill

After merging that PR:

  git checkout openhack
  git pull --ff-only origin openhack
  UPSTREAM_SHA="$(git rev-parse ${NEW_TAG}^{commit})"
  git tag -a "upstream-opencode-${NEW_TAG}" "${UPSTREAM_SHA}" -m "Upstream base: anomalyco/opencode ${NEW_TAG}"
  git push origin "upstream-opencode-${NEW_TAG}"
  git branch -d upgrade/opencode-${NEW_TAG}
  git push origin --delete upgrade/opencode-${NEW_TAG}

## Upgrade history

| From | To | PR | Merge SHA | Upstream commits | Notes |
|------|----|----|-----------|-----------------|-------|
| v1.1.52 | v1.1.53 | #1 | — | — | Initial upgrade |
| v1.1.64 | v1.2.5 | #2 | 711e18650 | 72 | Prune only touched 2 patch files; share module refactored to config-driven URL |
| v1.2.5 | v1.2.10 | #3 | 6b88eb639 | 301 | Prune/fork-fix baseline advanced to `aec6239af` / `c8ec2b563`; upstream base tagged as `upstream-opencode-v1.2.10` |
