{
pkgs
, username ? "admin"
, password ? "admin"
, database ? "sample"
, folder
}:
let 
  init_db = pkgs.writeText "init_db.sh" ''
              #!/bin/sh
              set -e
              set -x
              psql -v ON_ERROR_STOP=1 --username "$username" <<-EOSQL
                  CREATE USER $username WITH PASSWORD '$password';
                  CREATE DATABASE $database;
                  GRANT ALL PRIVILEGES ON DATABASE $database TO $username;  
            '';

  env = {
    PGUSER = username;
    PGPASSWORD = password;
    PGDATABASE = database;
    PGDATA = folder.postgresqlData;
  };
in
{
  stdenv.mkDerivation {
    name = "postgres_tools";
    shellHook = ''
    '';
  }
}
