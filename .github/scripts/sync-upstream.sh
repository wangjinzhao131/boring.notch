#!/usr/bin/env bash
set -euo pipefail
repo=wangjinzhao131/boring.notch
base=feat/all-reminders
head=sync/upstream

git fetch https://github.com/TheBoredTeam/boring.notch.git main
upstream_sha=$(git rev-parse FETCH_HEAD)
printf 'upstream_sha=%s\n' "$upstream_sha" >> "$GITHUB_OUTPUT"
# Fast-forward only: never overwrite personal commits if main diverges.
git push origin "$upstream_sha:refs/heads/main"
if git merge-base --is-ancestor "$upstream_sha" HEAD; then
  echo 'changed=false' >> "$GITHUB_OUTPUT"
  echo 'Custom branch already contains official upstream.' >> "$GITHUB_STEP_SUMMARY"
  exit 0
fi
# This branch contains only upstream commits. No reset of the custom branch.
git push origin "$upstream_sha:refs/heads/$head"
pr_url=$(gh pr list --repo "$repo" --base "$base" --head "$head" --state open --json url --jq '.[0].url // empty')
if [[ -z "$pr_url" ]]; then
  body=$(mktemp)
  trap 'rm -f "$body"' EXIT
  cat > "$body" <<BODY
Merge official upstream into the custom reminders branch, preserving undated tasks, list categories, expand/collapse controls and the compact panel.

The Sync official upstream run tests the actual merge, runs reminder checks and builds an ad-hoc signed macOS package. A conflict or failed build leaves this PR for manual resolution. No automatic merge or local installation is performed.

Validation run: $GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID
BODY
  pr_url=$(gh pr create --repo "$repo" --base "$base" --head "$head" --title 'Sync official upstream into custom reminders' --body-file "$body")
fi
echo 'changed=true' >> "$GITHUB_OUTPUT"
printf 'Sync PR: %s\n\nValidation: %s/%s/actions/runs/%s\n' "$pr_url" "$GITHUB_SERVER_URL" "$GITHUB_REPOSITORY" "$GITHUB_RUN_ID" >> "$GITHUB_STEP_SUMMARY"
