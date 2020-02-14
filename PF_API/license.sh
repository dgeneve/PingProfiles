#!/bin/bash
echo "Accepting license"
curl --insecure --ipv4 -X PUT \
  'https://localhost:9999/pf-admin-api/v1/license/agreement' \
  -H 'Content-Type: application/json' \
  -H 'X-XSRF-Header: PingFederate' \
  -H 'cache-control: no-cache' \
  -d '{
  "licenseAgreementUrl": "https://localhost:9999/pf/pf-admin-api/license-agreement",
  "accepted": true
}'
printf "\n"
printf "\n"
echo "Running curl --insecure --ipv4 --header "X-XSRF-Header: PingFederate" -v https://localhost:9999/pf-admin-api/v1/license/agreement
"
curl --insecure --ipv4 --header "X-XSRF-Header: PingFederate" -v https://localhost:9999/pf-admin-api/v1/license/agreement

echo "Importing PingFederate License /tmp/pingfederate.1586243.licE"
BASE64_LICENSE=$(base64 -w 0 /tmp/pingfederate.1586243.lic)
curl --insecure --ipv4 -X PUT \
  'https://localhost:9999/pf-admin-api/v1/license' \
  -H 'Content-Type: application/json' \
  -H 'X-XSRF-header: PingFederate' \
  -H 'cache-control: no-cache' \
  -d '{ "fileData": "'${BASE64_LICENSE}'" }'
printf "\n"
printf "\n"

#ADMIN_PW=$(echo ENC_ADMIN_PW | openssl enc -aes-128-cbc -a -d -salt -pass pass:wtf)
echo "Updating administrator password"
curl --insecure --ipv4 -X POST \
  https://localhost:9999/pf-admin-api/v1/administrativeAccounts \
  -H 'Content-Type: application/json' \
  -H 'X-XSRF-Header: PingFederate' \
  -H 'cache-control: no-cache' \
  -d '{
  "username": "Administrator",
  "password": "1D3ntr0py",
  "active": true,
  "description": "Initial Admin User",
  "auditor": false,
  "emailAddress": "admin@mydomain.com",
  "roles": [
    "USER_ADMINISTRATOR",
    "ADMINISTRATOR",
    "CRYPTO_ADMINISTRATOR"
  ]
}'
printf "\n"
printf "\n"
