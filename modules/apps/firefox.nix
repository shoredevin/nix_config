{ config, pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true; 
    preferences = {
      "browser.newtabpage.activity-stream.showWeather" = true;
      "browser.newtabpage.activity-stream.feeds.topsites" = false;
      "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
      "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
      "browser.newtabpage.activity-stream.system.showSponsored" = false;
    };
  };
}
