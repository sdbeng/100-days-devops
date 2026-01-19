## set up PostgreSQL database server
The Nax application development team has shared that they are planning to deploy one newly developed application on Nax infra in South DC. The application uses PostgreSQL database, so as pre-requisite we need to set up PostgreSQL database server as per requirements shared below:
PostgreSQL database server is already installed on the Nax database server.

a. Create a database user kodekloud_aim and set its password to xxxxxxxxxx.

b. Create a database kodekloud_db10 and grant full permissions to user kodekloud_aim on this database.
Note: Please do not try to restart PostgreSQL server service.

## Complete command sequence:
sudo su - postgres
psql

# In psql:
CREATE USER kodekloud_aim WITH PASSWORD 'xxxxxxxxx';
CREATE DATABASE kodekloud_db10;
GRANT ALL PRIVILEGES ON DATABASE kodekloud_db10 TO kodekloud_aim;
\q
exit

### outcomes
[postgres@stdb01 ~]$ psql
psql (13.14)
postgres=# create user kodekloud_aim with password 'xxxxxxxxxx';
CREATE ROLE
postgres=# create database kodekloud_db10;
CREATE DATABASE
postgres=# grant all privileges on database kodekloud_db10 to kodekloud_aim;
GRANT
postgres=# \q
[postgres@stdb01 ~]$ exit
logout
[peter@stdb01 ~]$ sudo su - postgres
[postgres@stdb01 ~]$ psql -U kodekloud_aim -d kodekloud_db10 -W
-check out
kodekloud_db10=> \l kodekloud_db10
                                  List of databases
      Name      |  Owner   | Encoding  | Collate | Ctype |     Access privileges      
----------------+----------+-----------+---------+-------+----------------------------
 kodekloud_db10 | postgres | SQL_ASCII | C       | C     | =Tc/postgres              +
                |          |           |         |       | 