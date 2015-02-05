PGPASSWORD=helena psql -h localhost -U helena postgres -c 'drop database helena'
PGPASSWORD=helena psql -h localhost -U helena postgres -c 'create database helena'
PGPASSWORD=helena psql -h localhost -U helena helena < helena.sql
