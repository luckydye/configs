function encrypt() {
  openssl enc -aes-256-cbc -salt -in $1 -out $1.enc
}

function decrypt() {
  replace=".enc"
  replacewith=""
  out="${1/${replace}/${replacewith}}"
  openssl enc -d -aes-256-cbc -in $1 -out $out
}
