sslib:

{
pkgs
, username ? "admin"
, password ? "admin"
, database ? "database"
, host ? "" 
, folder ? "${sslib.env.dataFolder}/db/postgres"
, stdenv
}:
let 
  init-db = pkgs.writeScriptBin "init_db" ''
              #!/bin/sh

              if [ ! -d $PGDATA ]; then
                mkdir -p $PGDATA
              fi

              psql -v ON_ERROR_STOP=1 --username "$username" <<-EOSQL
                  CREATE USER $username WITH PASSWORD '$password';
                  CREATE DATABASE $database;
                  GRANT ALL PRIVILEGES ON DATABASE $database TO $username;  
              EOSQL
            '';

  restart-db = pkgs.writeScriptBin "restart_db" ''
              #!/bin/sh

              if [ ! -d $PGDATA ]; then
                echo "No PGDATA folder found, initializing database"
                init_db
              fi

              pg_ctl -D $PGDATA -l logfile restart
            '';

  env = {
    PGUSER = username;
    PGPASSWORD = password;
    PGDATABASE = database;
    PGDATA = sslib.env.pathInDataFolder folder;
    PGHOST = if host == "" then folder else host;
  };
in
  sslib.defineUnit {
    name = "postgres";

    dependencies = [ pkgs.postgresql init-db restart-db ];

    envs = env;
  }
