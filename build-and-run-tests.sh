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
mqsicreateworkdir /tmp/PostgresTestWorkDir
cp -v -r PostgresTestWorkDir/* /tmp/PostgresTestWorkDir/

# Add user/pw information
mqsisetdbparms -w /tmp/PostgresTestWorkDir -n jdbc::postgres -u postgres -p ${POSTGRES_PASSWORD}

# Fix up the postgres host and port to work in containers
sed -i "s/localhost/${POSTGRES_HOST}/g" /tmp/PostgresTestWorkDir/run/DemoPolicies/PostgresJDBC.policyxml
sed -i "s/5432/${POSTGRES_PORT}/g" /tmp/PostgresTestWorkDir/run/DemoPolicies/PostgresJDBC.policyxml

# Build the application and test project
ibmint deploy --input-path $PWD --output-work-directory /tmp/PostgresTestWorkDir --project JDBCApplication --project JDBCApplicationJava --project JDBCApplication_ComponentTest

# Run the tests; the script will exit if this step fails
IntegrationServer -w /tmp/PostgresTestWorkDir --no-nodejs --start-msgflows no --test-project JDBCApplication_ComponentTest

# Clean up JARs left by ibmint - not a problem for the CI build but git 
# will notice if we leave them around while running locally.
rm *_*/*_*.jar
