# ace-postgres-jdbc
Example of connecting to Postgres from App Connect Enterprise with JDBC (v10 edition)

Create setdbparms information from the command line:
```
mqsisetdbparms JDBC_v10_Broker -n jdbc::postgres -u postgres -p passw0rd
```

Create the PostgresJDBC configurable service:
```
mqsicreateconfigurableservice JDBC_v10_Broker -c JDBCProviders -o PostgresJDBC -n 'databaseName,databaseType,databaseVersion,type4DriverClassName,type4DatasourceClassName,connectionUrlFormat,connectionUrlFormatAttr1,connectionUrlFormatAttr2,connectionUrlFormatAttr3,connectionUrlFormatAttr4,connectionUrlFormatAttr5,serverName,portNumber,jarsURL,databaseSchemaNames,description,maxConnectionPoolSize,securityIdentity,environmentParms,jdbcProviderXASupport,useDeployedJars' -v 'postgres,Postgres,0.0,org.postgresql.Driver,org.postgresql.xa.PGXADataSource,jdbc:postgresql://[serverName]:[portNumber]/[databaseName]?user=[user]&password=[password],,,,,,localhost,5432,,useProvidedSchemaNames,,0,postgres,,false,true'
```

Copy postgresql-42.6.0.jar to /var/mqsi/shared-classes, create a BAR file without 
the DemoPolicies project (policies are v11 and above), and then deploy the BAR file
to an execution group.

The flow should start, and print messages to syslog of the form
```
Jul 11 13:33:01 IBM-PF3K066L IIB[7955]: IBM Integration Bus v100026 (JDBC_v10_Broker.default)
[Thread 8045] (Msg 1/1) BIP4360I: Java node information:
[BIPmsgs:8099]BIP8099I: Database statement: SELECT count(*) from pg_tables  -  result : 68.
```
