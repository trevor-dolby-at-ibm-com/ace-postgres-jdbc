#!/bin/bash

# Assumes a shell with the ACE profile already loaded

# Print commands to the screen
set -x

# Exit on any error
set -e

echo ""
echo "================ Building and running JDBCApplication tests"
echo ""
ibmint deploy --input-path $PWD --output-work-directory $PWD/PostgresTestWorkDir --project JDBCApplication --project JDBCApplicationJava --project JDBCApplication_ComponentTest
IntegrationServer -w $PWD/PostgresTestWorkDir --no-nodejs --start-msgflows no --test-project JDBCApplication_ComponentTest

# Clean up JARs left by ibmint - git will notice if we leave them around; while
# we could ignore JAR files with .gitignore, that would make it harder to upgrade
# cucumber JARs later. Maven solves this (see maven branch) . . . 
rm *_*/*_*.jar
