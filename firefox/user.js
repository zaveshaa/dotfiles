user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.toolbars.bookmarks.visibility", "never");
user_pref("browser.tabs.inTitlebar", 1);
user_pref("browser.tabs.closeWindowWithLastTab", false);
user_pref("browser.uidensity", 1);

user_pref("browser.search.suggest.enabled", false);
user_pref("browser.search.suggest.enabled.private", false);
user_pref("browser.urlbar.suggest.searches", false);
user_pref("browser.urlbar.suggest.history", false);
user_pref("browser.urlbar.suggest.bookmark", false);
user_pref("browser.urlbar.suggest.openpage", false);
user_pref("browser.urlbar.suggest.topsites", false);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("browser.urlbar.suggest.quickactions", false);
user_pref("browser.urlbar.suggest.recentsearches", false);
user_pref("browser.urlbar.suggest.quicksuggest.nonsponsored", false);
user_pref("browser.urlbar.suggest.quicksuggest.sponsored", false);
user_pref("browser.urlbar.maxRichResults", 0);
user_pref("browser.urlbar.groupLabels.enabled", false);
user_pref("browser.formfill.enable", false);

user_pref("accessibility.typeaheadfind.flashBar", 0);
user_pref("browser.contentblocking.category", "standard");
user_pref("browser.download.always_ask_before_handling_new_types", true);
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.widgets.sportsWidget.enabled", false);
// Google is in the installed engine list. RU region expects Yandex, which is not
// installed, leaving no default engine and making Enter treat input as a hostname.
user_pref("browser.search.region", "US");
user_pref("browser.urlbar.placeholderName", "Google");
user_pref("browser.urlbar.placeholderName.private", "Google");
user_pref("dom.forms.autocomplete.formautofill", true);
user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
user_pref("extensions.pictureinpicture.enable_picture_in_picture_overrides", true);
user_pref("intl.locale.requested", "en-US,ru");
user_pref("layout.css.prefers-color-scheme.content-override", 0);
// This profile had DoH rollout self-enabled, but system DNS works and IPv6 is
// broken here (curl -6 fails). Use native DNS/IPv4 only to avoid dnsNotFound.
user_pref("doh-rollout.mode", 0);
user_pref("network.trr.mode", 5);
user_pref("network.dns.disableIPv6", true);
user_pref("network.dns.disablePrefetch", true);
user_pref("network.http.speculative-parallel-limit", 0);
user_pref("network.prefetch-next", false);
user_pref("privacy.clearOnShutdown_v2.formdata", true);
