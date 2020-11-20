TRUORA_CLI_URL="https://truora-cli.s3.amazonaws.com/truora"

if [ -z "$GOPATH" ]; then
    GOPATH=$HOME/go
    echo "GOPATH is not set, using $GOPATH"
fi

DOWNLOAD_FOLDER=$GOPATH/bin
if [[ $PATH != *"$DOWNLOAD_FOLDER"* ]];then
    echo "Download folder $DOWNLOAD_FOLDER is not in the PATH env var"
    exit 1
fi

BINARY_NAME=truora
TRUORA_CLI_OUTPUT=$DOWNLOAD_FOLDER/$BINARY_NAME

echo "Downloading Truora CLI from $TRUORA_CLI_URL"

curl $TRUORA_CLI_URL -o $TRUORA_CLI_OUTPUT
if [ $? -ne 0 ]; then
    echo "Download file $TUORA_CLI_URL failed, please review the cli download URL and download folder: $DOWNLOAD_FOLDER"
    exit 1
fi

chmod +x $TRUORA_CLI_OUTPUT # add execution permissions over truora cli
echo "Truora cli has been downloaded to $DOWNLOAD_FOLDER"