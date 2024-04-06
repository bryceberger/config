{pkgs, ...}: {
  lua = let
    toLua = indent: val:
      with builtins;
      with pkgs.lib; let
        toLua' = toLua (indent + 1);
        ind' = i: concatStrings (replicate i "  ");
        ind = ind' indent;
        prev_ind = ind' (indent - 1);
        mapVal = {
          null = _: "nil";
          bool = b:
            if b
            then "true"
            else "false";
          string = s: "'${s}'";
          list = l: ''
            {
            ${ind}${concatMapStringsSep ",\n${ind}" toLua' l},
            ${prev_ind}}'';
          set = s:
            if s.__isLuaFunc or false
            then "${s.name} ${toLua indent s.arg}"
            else if s.__isLuaName or false
            then "${s.name}"
            else let
              luaVals =
                attrsets.mapAttrsToList
                (name: value: "${name} = ${toLua' value}")
                s;
              joined = concatStringsSep ",\n${ind}" luaVals;
            in ''
              {
              ${ind}${joined},
              ${prev_ind}}'';
          lambda = throw "lambda not supported";
        };
      in "${(mapVal.${typeOf val} or toString) val}";
  in {
    from = toLua 1;

    call = name: arg: {
      __isLuaFunc = true;
      inherit name arg;
    };

    name = name: {
      __isLuaName = true;
      inherit name;
    };
  };
}
