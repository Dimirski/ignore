#!/bin/bash


# Retries a command a with backoff.
#
# The amount of retries left is given by ATTEMPTS 
# Initial backoff timeout is given by TIMEOUT in seconds
#
# Successive backoffs double the timeout.
#
function with_backoff {
  local max_attempts=${ATTEMPTS-3}
  local timeout=${TIMEOUT-5}
  local attempt=0
  local exitCode=0

  while [[ $attempt < $max_attempts ]]
  do
    "$@"
    exitCode=$?

    if [[ $exitCode == 0 ]]
    then
      echo "Success!"
      break
    fi

    echo "Failed... Retrying in $timeout.." 1>&2
    sleep $timeout
    attempt=$(( attempt + 1 ))
    timeout=$(( timeout * 2 ))
  done

  if [[ $exitCode != 0 ]]
  then
    echo "Command ($@) failed all attempts\n" 1>&2
    exit 1
  fi

  return $exitCode
}

function test_POST {
  local max_attempts=${ATTEMPTS-2}
  local timeout=${TIMEOUT-5}
  local attempt=0
  local exitCode=0

  while [[ $attempt < $max_attempts ]]
  do
    curl POST https://mailer.dev.paperplanes.services/client/000 -H 'Authorization: test000000000000000000' -d @src/tests/sampleInput.json --output POSToutput.txt 
    ls
    cat POSToutput.txt
    echo ${response}

    if [[ 1 == 1]]
    then
      echo "Success!"
      break
    fi

    echo "Failed... Retrying in $timeout.." 1>&2
    sleep $timeout
    attempt=$(( attempt + 1 ))
    timeout=$(( timeout * 2 ))
  done

  if [[ $exitCode != 0 ]]
  then
    echo "Command ($@) failed all attempts\n" 1>&2
    exit 1
  fi

  return $exitCode
}

ls

echo "Test 1 - Test POST"
echo ""
test_POST
echo ""
echo "Test 2 - Test GET"
curl https://mailer.dev.paperplanes.services/client/000/TEST/data -H 'Authorization: test000000000000000000' --output GEToutput.txt
ls
cat GEToutput.txt


####### IN DEVELPOMENT #########

