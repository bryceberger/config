{pkgs, ...}: let
  extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
    bitwarden
    firefox-color
    ublock-origin
  ];
  extensions.force = true;

  search.engines = {
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
  search.force = true;

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

  settings = {
    "browser.newtab.url" = "about:blank";
    # open previous tabs
    "browser.startup.page" = 3;
    "browser.toolbars.bookmarks.visibility" = "never";
    "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":[],"nav-bar":["alltabs-button","firefox-view-button","back-button","forward-button","urlbar-container","vertical-spacer","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":[],"vertical-tabs":["tabbrowser-tabs"],"PersonalToolbar":["personal-bookmarks"]},"seen":["developer-button"],"dirtyAreaCache":["nav-bar","TabsToolbar","vertical-tabs","toolbar-menubar","PersonalToolbar"],"currentVersion":21,"newElementCount":2}'';
    "signon.rememberSignons" = false;

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
    "browser.ml.chat.enabled" = false;
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
  };
in {
  programs.firefox = {
    enable = true;
    profiles.nix = {
      inherit extensions search;
      settings = settings // suggest-disable;
    };
  };
}
