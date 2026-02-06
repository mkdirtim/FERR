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
