#!/bin/bash

DECRYPT_THIS_BASE64_STRING=fileb://"${3:-secret}"
PROFILE="${2:-dev}"

output=$(aws kms decrypt --ciphertext-blob fileb://<(echo $DECRYPT_THIS_BASE64_STRING | base64 -D) --query Plaintext --output text --profile ${PROFILE} | base64 -D)
echo "Decrypted Ciphertext Is: $output"
echo -n "$output" > /tmp/output.txt