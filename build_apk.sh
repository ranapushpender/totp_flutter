#!/bin/bash
apt install curl file -y
flutter clean
flutter build apk
HEAD_COMMIT_ID=`git rev-parse HEAD`
TAG_NAME=`git tag --points-at $HEAD_COMMIT_ID`
API_JSON=$(printf '{"tag_name": "%s","target_commitish": "master","name": "TOTP-Flutter-%s","body": "Release of version %s","draft": false,"prerelease": false}' $TAG_NAME $TAG_NAME $TAG_NAME)
result=`curl -H "Authorization: token $GITHUB_PAT" --data "$API_JSON" https://api.github.com/repos/ranapushpender/totp_flutter/releases?access_token=$GITHUB_PAT`
UPLOAD_URL=`echo $result | grep -oP 'https://uploads.github.com[^{]*'`
FILE=build/app/outputs/apk/release/app-release.apk
curl -H "Authorization: token $GITHUB_PAT" -H "Content-Type: $(file -b --mime-type $FILE)" --data-binary @$FILE "$UPLOAD_URL?name=app-release.apk"