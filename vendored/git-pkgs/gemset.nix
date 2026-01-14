{
  addressable = {
    dependencies = ["public_suffix"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mxhjgihzsx45l9wh2n0ywl9w0c6k70igm5r0d63dxkcagwvh4vw";
      type = "gem";
    };
    version = "2.8.8";
  };
  base64 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0yx9yn47a8lkfcjmigk79fykxvr80r4m1i35q82sxzynpbm7lcr7";
      type = "gem";
    };
    version = "0.3.0";
  };
  bigdecimal = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "19y406nx17arzsbc515mjmr6k5p59afprspa1k423yd9cp8d61wb";
      type = "gem";
    };
    version = "4.0.1";
  };
  csv = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0gz7r2kazwwwyrwi95hbnhy54kwkfac5swh2gy5p5vw36fn38lbf";
      type = "gem";
    };
    version = "3.3.5";
  };
  ecosystems-bibliothecary = {
    dependencies = ["csv" "json" "ox" "racc" "tomlrb"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1sz41jrxzg3zp3mg0bskf7vqfndkps6fpqx9xcxq7gqq6am8qg6w";
      type = "gem";
    };
    version = "15.3.0";
  };
  git-pkgs = {
    dependencies = ["base64" "ecosystems-bibliothecary" "purl" "rugged" "sarif-ruby" "sbom" "sequel" "sqlite3" "vers"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1c0irxjwip1fhnhdz5q9rc9m2pyyszgr0jbzvh9vs1bx1pg9vmwp";
      type = "gem";
    };
    version = "0.9.0";
  };
  hana = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "03cvrv2wl25j9n4n509hjvqnmwa60k92j741b64a1zjisr1dn9al";
      type = "gem";
    };
    version = "1.3.7";
  };
  json = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "01fmiz052cvnxgdnhb3qwcy88xbv7l3liz0fkvs5qgqqwjp0c1di";
      type = "gem";
    };
    version = "2.18.0";
  };
  json_schemer = {
    dependencies = ["bigdecimal" "hana" "regexp_parser" "simpleidn"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "15p31bq932bfpsi1wgrkgwm71l7z1h1w53q6vl44w6kjrr6gn09g";
      type = "gem";
    };
    version = "2.5.0";
  };
  mini_portile2 = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12f2830x7pq3kj0v8nz0zjvaw02sv01bqs1zwdrc04704kwcgmqc";
      type = "gem";
    };
    version = "2.8.9";
  };
  ostruct = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04nrir9wdpc4izqwqbysxyly8y7hsfr4fsv69rw91lfi9d5fv8lm";
      type = "gem";
    };
    version = "0.6.3";
  };
  ox = {
    dependencies = ["bigdecimal"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0rhv8qdnm3s34yvsvmrii15f2238rk3psa6pq6x5x367sssfv6ja";
      type = "gem";
    };
    version = "2.14.23";
  };
  public_suffix = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0mx84s7gn3xabb320hw8060v7amg6gmcyyhfzp0kawafiq60j54i";
      type = "gem";
    };
    version = "7.0.2";
  };
  purl = {
    dependencies = ["addressable"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1lvfwlrbgainq1z3vmnivj0w1xwsncqmg252mzgrn6g2w3ryr6j5";
      type = "gem";
    };
    version = "1.7.1";
  };
  racc = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0byn0c9nkahsl93y9ln5bysq4j31q8xkf2ws42swighxd4lnjzsa";
      type = "gem";
    };
    version = "1.8.1";
  };
  regexp_parser = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "192mzi0wgwl024pwpbfa6c2a2xlvbh3mjd75a0sakdvkl60z64ya";
      type = "gem";
    };
    version = "2.11.3";
  };
  rexml = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0hninnbvqd2pn40h863lbrn9p11gvdxp928izkag5ysx8b1s5q0r";
      type = "gem";
    };
    version = "3.4.4";
  };
  rugged = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1b7gcf6pxg4x607bica68dbz22b4kch33yi0ils6x3c8ql9akakz";
      type = "gem";
    };
    version = "1.9.0";
  };
  sarif-ruby = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "1l1x319m5wywzjks27dhq6x9yi7fsz8a8n4y11fmgh8bmhp5n6lg";
      type = "gem";
    };
    version = "0.1.0";
  };
  sbom = {
    dependencies = ["json_schemer" "purl" "rexml"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0dqzb6fan6j8zryn0sxsycjphx048w33d9faxb3m73q48ffb830c";
      type = "gem";
    };
    version = "0.4.1";
  };
  sequel = {
    dependencies = ["bigdecimal"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "04jakfg8l46s84n4w5qvw3xa75s4q5cngm7aisv1v8474av2j0yb";
      type = "gem";
    };
    version = "5.100.0";
  };
  simpleidn = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0a9c1mdy12y81ck7mcn9f9i2s2wwzjh1nr92ps354q517zq9dkh8";
      type = "gem";
    };
    version = "0.2.3";
  };
  sqlite3 = {
    dependencies = ["mini_portile2"];
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "0v19bypbf46ms3gvk47hi4smcf6pm0gc8daa786mapzc685w1sgc";
      type = "gem";
    };
    version = "2.9.0";
  };
  tomlrb = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "168v339gqaly00i4zqg2ag2h10r3rl7999d0cqrrpb63gaa7fbr6";
      type = "gem";
    };
    version = "2.0.4";
  };
  vers = {
    groups = ["default"];
    platforms = [];
    source = {
      remotes = ["https://rubygems.org"];
      sha256 = "12dw46cqlz9sm1yqan7k1bwr911ksxx6s2jbp5d528va2h7mpvyi";
      type = "gem";
    };
    version = "1.0.3";
  };
}
