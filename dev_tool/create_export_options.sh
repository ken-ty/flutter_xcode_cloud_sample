#!/bin/bash

# ExportOptions.plist.template から ExportOptions.plist を生成する。
# 使用例: `./dev_tool/create_export_options.sh --teamid="xxxxx" --provisioning-profile-name="xxxxx" --app-bundle-id="xxxxx"`

# 引数の処理
for i in "$@"
do
case $i in
    --teamid=*)
    TEAMID="${i#*=}"
    shift
    ;;
    --provisioning-profile-name=*)
    PROVISIONING_PROFILE_NAME="${i#*=}"
    shift
    ;;
    --app-bundle-id=*)
    APP_BUNDLE_ID="${i#*=}"
    shift
    ;;
    *)
    ;;
esac
done

# 引数のチェック
if [ -z $TEAMID ]; then
    echo "Error: --teamid が指定されていません。"
    exit 1
fi

if [ -z $PROVISIONING_PROFILE_NAME ]; then
    echo "Error: --provisioning-profile-name が指定されていません。"
    exit 1
fi

if [ -z $APP_BUNDLE_ID ]; then
    echo "Error: --app-bundle-id が指定されていません。"
    exit 1
fi

# テンプレートファイルのパス
TEMPLATE_FILE_PATH="./ios/ExportOptions.plist.template"

# 出力ファイルのパス
OUTPUT_FILE_PATH="./ios/ExportOptions.plist"

# テンプレートファイルの存在チェック
if [ ! -e $TEMPLATE_FILE_PATH ]; then
    echo "Error: テンプレートファイルが存在しません。"
    exit 1
fi

# テンプレートファイルの内容を読み込む
TEMPLATE_CONTENT=$(cat $TEMPLATE_FILE_PATH)

# テンプレートファイルの内容を置換する
OUTPUT_CONTENT=${TEMPLATE_CONTENT//__TEAMID__/$TEAMID}
OUTPUT_CONTENT=${OUTPUT_CONTENT//__PROVISIONING_PROFILE_NAME__/$PROVISIONING_PROFILE_NAME}
OUTPUT_CONTENT=${OUTPUT_CONTENT//__APP_BUNDLE_ID__/$APP_BUNDLE_ID}

# 出力ファイルに書き込む
echo "$OUTPUT_CONTENT" > $OUTPUT_FILE_PATH

echo "ExportOptions.plist を生成しました。"

exit 0
