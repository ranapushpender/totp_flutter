#!/bin/bash
apt install curl file -y
PATH=$PATH:/home/build/tools/bin:/home/build/tools/platform-tools:/home/build/flutter/bin
HEAD_COMMIT_ID=`git rev-parse HEAD`
echo "Head is at "$HEAD_COMMIT_ID
echo "TAG_NAME is "$TAG_NAME
echo "At Line 11"
API_JSON=$(printf '{"tag_name": "%s","target_commitish": "master","name": "TOTP-Flutter-%s","body": "Release of version %s","draft": false,"prerelease": true}' $TAG_NAME $TAG_NAME $TAG_NAME)
echo $API_JSON
echo "At Line 13"
result=`curl --data "$API_JSON" https://api.github.com/repos/ranapushpender/totp_flutter/releases?access_token=$GITHUB_PAT`
echo $result
echo "At Line 15"
UPLOAD_URL=`echo $result | grep -oP 'https://uploads.github.com[^{]*'`
echo "At Line 17"
FILE=build/app/outputs/flutter-apk/app-release.apk
echo "At Line 19"
flutter clean
flutter build apk
curl -H "Authorization: token $GITHUB_PAT" -H "Content-Type: $(file -b --mime-type $FILE)" --data-binary @$FILE "$UPLOAD_URL?name=app-release.apk"
echo "at 19"
