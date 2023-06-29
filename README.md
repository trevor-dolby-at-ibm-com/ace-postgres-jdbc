# ace-postgres-jdbc
Example of connecting to Postgres from App Connect Enterprise with JDBC 

Create setdbparms information as either a CP4i configuration or else from the command line:
```
mqsisetdbparms -w ~/tmp/postgres-jdbc-work-dir -n jdbc::postgres -u postgres -p passw0rd
```
