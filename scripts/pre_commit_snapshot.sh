#!/bin/bash
mkdir -p ~/.claude/snapshots
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
git diff > ~/.claude/snapshots/diff_$DATE.patch
echo "📸 Snapshot saved: $DATE"
