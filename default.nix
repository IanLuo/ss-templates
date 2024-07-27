{pkgs}:
  let
    sslib = pkgs.callPackage ./sslib { };
    commonParams = { inherit pkgs sslib; };
  in
  with pkgs; {
    lib = sslib;
  }
