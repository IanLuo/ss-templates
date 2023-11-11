sslib:

{
pkgs
, username ? "admin"
, password ? "admin"
, database ? "database"
, host ? "" 
, folder ? "db/postgres"
, stdenv
}:
let 
  setup-db = pkgs.writeScriptBin "setup-db" ''
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

  restart-db = pkgs.writeScriptBin "restart-db" ''
              #!/bin/sh

              if [ ! -d $PGDATA ]; then
                echo "No PGDATA folder found, initializing database"
                setup-db
              fi

              if pg_ctl status >/dev/null 2>&1; then
                pg_ctl stop
              fi

              pg_ctl -D $PGDATA start
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

    dependencies = [ pkgs.postgresql setup-db restart-db ];

    envs = env;
  }
