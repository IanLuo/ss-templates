sslib:

{
pkgs
, username ? "admin"
, password ? "admin"
, database ? "database"
, host ? "" 
, folder
, stdenv
}:
let 
  init-db = pkgs.writeScriptBin "init_db" ''
              #!/bin/sh

              if [ ! -d $PGDATA ]; then
                mkdir -p $PGDATA
              fi

              set -e
              set -x
              psql -v ON_ERROR_STOP=1 --username "$username" <<-EOSQL
                  CREATE USER $username WITH PASSWORD '$password';
                  CREATE DATABASE $database;
                  GRANT ALL PRIVILEGES ON DATABASE $database TO $username;  
            '';

  restart-db = pkgs.writeScriptBin "restart_db" ''
              #!/bin/sh

              if [ ! -d $PGDATA ]; then
                echo "No PGDATA folder found, initializing database"
                init_db
              fi

              set -e
              set -x
              pg_ctl -D $PGDATA -l logfile restart
            '';

  env = {
    PGUSER = username;
    PGPASSWORD = password;
    PGDATABASE = database;
    PGDATA = folder;
    PGHOST = if host == "" then folder else host;
  };
in
  sslib.defineUnit {
    name = "postgres";

    dependencies = [ pkgs.postgresql init-db restart-db ];

    envs = env;
  }
