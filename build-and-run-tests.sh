#!/bin/bash

# Assumes a shell with the ACE profile already loaded

# Print commands to the screen
set -x

# Exit on any error
set -e

echo ""
echo "================ Building and running JDBCApplication tests"
echo ""

# We have to copy the work directory out to avoid issues with ibmint, but this
# also reduces the likelihood of accidentally checking in user/pw information.
echo $PWD
/bin/pwd
ls -la 
ls -la PostgresTestWorkDir
ls -l /tmp

cp -r $PWD/PostgresTestWorkDir /tmp/PostgresTestWorkDir
mqsisetdbparms -w /tmp/PostgresTestWorkDir -n jdbc::postgres -u postgres -p ${POSTGRES_PASSWORD}

# Fix up the postgres host and port to work in containers
sed -i "s/localhost/${POSTGRES_HOST}/g" /tmp/PostgresTestWorkDir/run/DemoPolicies/PostgresJDBC.policyxml
sed -i "s/5432/${POSTGRES_PORT}/g" /tmp/PostgresTestWorkDir/run/DemoPolicies/PostgresJDBC.policyxml

ibmint deploy --input-path $PWD --output-work-directory /tmp/PostgresTestWorkDir --project JDBCApplication --project JDBCApplicationJava --project JDBCApplication_ComponentTest
IntegrationServer -w /tmp/PostgresTestWorkDir --no-nodejs --start-msgflows no --test-project JDBCApplication_ComponentTest

# Clean up JARs left by ibmint - git will notice if we leave them around; while
# we could ignore JAR files with .gitignore, that would make it harder to upgrade
# cucumber JARs later. Maven solves this (see maven branch) . . . 
rm *_*/*_*.jar
