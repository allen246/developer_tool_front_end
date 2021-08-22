#!/usr/bin/env sh

set -e

npm run build

git init
git add -A
git commit -m 'Deployment'
git push -f git@github.com:allen246/developer_tool_front_end.git master:main

cd -