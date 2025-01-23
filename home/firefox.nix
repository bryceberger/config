{
  pkgs,
  inputs,
  ...
}: let
  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    bitwarden
    darkreader
    firefox-color
    sidebery
    ublock-origin
  ];

  search-engines = {
    "nixpkgs" = {
      urls = pkgs.lib.lists.singleton {
        template = "https://search.nixos.org/packages";
        params = pkgs.lib.attrsToList {
          type = "packages";
          query = "{searchTerms}";
        };
      };
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = ["@np" "@nixpkgs"];
    };
  };

  disable-suggestion = val: {
    name = "browser.urlbar.suggest.${val}";
    value = false;
  };
  suggest-disable = builtins.listToAttrs (builtins.map disable-suggestion [
    "engines"
    "fakespot"
    "mdn"
    "pocket"
    "quicksuggest.nonsponsored"
    "quicksuggest.sponsored"
    "recentsearches"
    "searches"
    "topsites"
    "trending"
    "yelp"
  ]);

  settings =
    {
      "browser.newtab.url" = "";
      "browser.toolbars.bookmarks.visibility" = "never";
      "signon.rememberSignons" = false;

      # begin ultima config
      # theme
      "user.theme.dark.a" = false;
      "user.theme.light.a" = true;
      "user.theme.adaptive" = false;
      "user.theme.dark.catppuccin" = false;
      "user.theme.dark.catppuccin-frappe" = false;
      "user.theme.dark.catppuccin-mocha" = true;
      "user.theme.dark.gruvbox" = false;
      "user.theme.light.gruvbox" = false;
      "user.theme.dark.midnight" = false;

      # titlebar and tabs
      "ultima.disable.alltabs.button" = true;
      "ultima.disable.contextmenu.collapsing" = true;
      "ultima.disable.windowcontrols.button" = true;
      "ultima.disable.verticaltab.bar" = true;
      "ultima.disable.verticaltab.bar.withindicator" = false;
      "ultima.tabs.autohide" = true;
      "ultima.tabs.belowURLbar" = true;
      "ultima.tabs.width.small" = false;
      "ultima.tabs.width.medium" = true;
      "ultima.tabs.width.large" = false;
      "ultima.tabs.width.huge" = false;
      "ultima.spacing.compact.tabs" = false;

      # sidebar
      "ultima.sidebar.autohide" = false;
      "ultima.sidebery.autohide" = true;
      "ultima.sidebar.hidden" = false;
      "ultima.sidebar.longer" = false;

      # extra theming
      "ultima.theme.extensions" = true;
      "ultima.theme.icons" = true;
      "ultima.theme.menubar" = true;
      "ultima.theme.color.swap" = false;

      # url bar
      "ultima.navbar.autohide" = false;
      "ultima.urlbar.suggestions" = true;
      "ultima.urlbar.centered" = false;
      "ultima.urlbar.hidebuttons" = false;
      "ultima.xstyle.urlbar" = false;

      # alternate styles
      "ultima.spacing.compact" = false;
      "ultima.xstyle.tabgroups.i" = true;
      "ultima.xstyle.tabgroups.ii" = false;
      "ultima.xstyle.containertabs.i" = false;
      "ultima.xstyle.containertabs.ii" = false;
      "ultima.xstyle.containertabs.iii" = true;
      "ultima.xstyle.pinnedtabs.i" = false;
      "ultima.xstyle.private" = false;
      "ultima.xstyle.bookmarks.fading" = false;
      "ultima.xstyle.newtab.rounded" = false;

      # override wallpapers
      "user.theme.wallpaper.catppuccin" = false;
      "user.theme.wallpaper.catppuccin-mocha" = true;
      "user.theme.wallpaper.catppuccin-frappe" = false;
      "user.theme.wallpaper.dusky" = false;
      "user.theme.wallpaper.fullmoon" = false;
      "user.theme.wallpaper.green" = false;
      "user.theme.wallpaper.gruvbox" = false;
      "user.theme.wallpaper.gruvbox.flowers" = false;
      "user.theme.wallpaper.gruvbox.light" = false;
      "user.theme.wallpaper.midnight" = false;
      "user.theme.wallpaper.midnight2" = false;
      "user.theme.wallpaper.seasonal" = false;
      "user.theme.wallpaper.seasonal2" = false;

      # other
      "ultima.enable.nightly.config" = false;
      "ultima.enable.js.config" = true;

      # other other
      "browser.aboutConfig.showWarning" = false;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "devtools.debugger.remote-enabled" = true;
      "devtools.chrome.enabled" = true;
      "devtools.debugger.prompt-connection" = false;
      "svg.context-properties.content.enabled" = true;
      "layout.css.has-selector.enabled" = true;
      "toolkit.tabbox.switchByScrolling" = false;
      "widget.gtk.ignore-bogus-leave-notify" = 1;
      "widget.gtk.rounded-bottom-corners.enabled" = false;
      "widget.gtk.native-context-menus" = false;
      "sidebar.revamp" = true;
      "sidebar.verticalTabs" = true;
      "browser.tabs.groups.enabled" = true;
      "browser.tabs.hoverPreview.enabled" = true;
      "browser.newtabpage.activity-stream.newtabWallpapers.v2.enabled" = false;
      "media.videocontrols.picture-in-picture.enable-when-switching-tabs.enabled" = false;
      "browser.newtabpage.activity-stream.improvesearch.handoffToAwesomebar" = false;

      # accessibility
      "findbar.highlightAll" = true;
      "browser.tabs.insertAfterCurrent" = true;
      "browser.search.context.loadInBackground" = true;
      "browser.bookmarks.openInTabClosesMenu" = false;
      "full-screen-api.transition-duration.enter" = "0 0";
      "full-screen-api.transition-duration.leave" = "0 0";
      "full-screen-api.warning.timeout" = 0;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "network.http.max-connections" = 300;
      "browser.urlbar.suggest.calculator" = false;
      "apz.overscroll.enabled" = true;
      "general.smoothScroll" = true;
      "general.smoothScroll.msdPhysics.enabled" = true;

      # privacy
      "browser.send_pings" = false;
      "dom.event.clipboardevents.enabled" = false;
      "dom.battery.enabled" = false;
      "extensions.pocket.enabled" = false;
      "datareporting.healthreport.uploadEnabled" = false;
    }
    // suggest-disable;
in {
  programs.firefox = {
    enable = true;
    profiles.nix = {
      inherit extensions settings;
      search.engines = search-engines;
      search.force = true;
    };
  };

  home.file.".mozilla/firefox/nix/chrome".source = inputs.ff-ultima;
}
