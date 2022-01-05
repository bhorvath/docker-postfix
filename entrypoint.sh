#!/bin/bash

function initial_config {
  env_vars=(
  "MAIL_DOMAIN"
  "TLS_CERT_FILE"
  "TLS_KEY_FILE"
  "RELAY_HOST"
  )
  env_vars_subst=${env_vars[@]/#/$}
  postfix_staging_directory=/tmp/postfix_staging
  postfix_directory=/etc/postfix

  # Check if all required variables have been set
  for each in "${env_vars[@]}"; do
    if ! [[ -v $each ]]; then
      echo "$each has not been set!"
      var_unset=true
    fi
  done

  if [ $var_unset ]; then
    echo "One or more required variables are unset. You must set them before setup can continue."
    exit 1
  fi

  # Copy postfix config files into place
  echo "Preparing configuration files"
  cd $postfix_staging_directory
  find . -type f -exec sh -c "cat {} | envsubst '$env_vars_subst' > $postfix_directory/{}" \;

  # Clean up
  cd $postfix_directory
  rm -r $postfix_staging_directory
  echo 'This file is used by docker to check whether the container has already been configured' > $configured_file
}

configured_file=/etc/docker.configured
if [ -f "$configured_file" ]; then
  echo "Starting postfix..."
else
  echo "Configuring postfix..."
  initial_config
  echo "Done. Starting postfix..."
fi

exec /usr/sbin/postfix start-fg
