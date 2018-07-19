#!/bin/bash

KMS_KEY_ID=arn:aws:kms:us-east-1:728517735075:key/b28c8401-d0fe-44ee-a4e0-f20044af227d # Arn of the key
PROFILE="${2:-dev}"
ENCRYPT_THIS_FILE_AT_PATH=fileb://"${3:-secret}"

output=$(aws kms encrypt --key-id ${KMS_KEY_ID} --plaintext ${ENCRYPT_THIS_FILE_AT_PATH} --query CiphertextBlob --output text --profile ${PROFILE})
echo "Base64 Encoded Ciphertext Is: $output"