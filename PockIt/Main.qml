import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3
import Ubuntu.Content 1.1
import Ubuntu.Components.Popups 1.3
import com.canonical.Oxide 1.0 as Oxide
import Ubuntu.Web 0.2
import Ubuntu.Connectivity 1.0
import "components"
import "ui"
import "themes" as Themes
import "js/localdb.js" as LocalDb
import "js/user.js" as User
import "js/scripts.js" as Scripts

MainView {
    id: mainView
    objectName: "mainView"
    applicationName: "pockit.turan-mahmudov-l"

    automaticOrientation: true
    anchorToKeyboard: true

    width: units.gu(50)
    height: units.gu(75)

    // Properties
    property string consumer_key: "37879-9a829576cdc1d9842620f694"
    property string current_version: "0.1"
    property int downloaded: 0
    property int totaldownloads: 0
    property bool finished: true
    property bool empty: false

    // Themes
    Themes.ThemeManager {
        id: themeManager
        themes: [
            {name: i18n.tr('Light'), source: Qt.resolvedUrl('themes/Light.qml')},
            {name: i18n.tr('Dark'),   source: Qt.resolvedUrl('themes/Dark.qml')}
        ]
        source: User.getKey('dark_theme') == 'true' ? "Dark.qml" : "Light.qml"
    }
    property alias currentTheme: themeManager.theme
    property var themeManager: themeManager

    headerColor: currentTheme.backgroundHeaderColor
    backgroundColor: currentTheme.backgroundColor
    footerColor: currentTheme.backgroundFooterColor
    theme.name: currentTheme.baseThemeName

    Connections {
        target: Connectivity
    }

    // Main Actions for page header
    actions: [
        Action {
            id: searchAction
            text: i18n.tr("Search")
            iconName: "search"
            onTriggered: {
                pageStack.push(Qt.resolvedUrl("ui/Search.qml"))
            }
        },
        Action {
            id: settingsAction
            text: i18n.tr("Settings")
            iconName: "settings"
            onTriggered: {
                pageStack.push(Qt.resolvedUrl("ui/Settings.qml"))
            }
        },
        Action {
            id: refreshAction
            text: i18n.tr("Sync")
            iconName: "sync"
            onTriggered: {
                myListPage.get_list()
            }
        },
        Action {
            id: aboutAction
            text: i18n.tr("About")
            iconName: "info"
            onTriggered: {
                pageStack.push(Qt.resolvedUrl("ui/About.qml"))
            }
        }
    ]

    function home(refr) {
        // Check if user is logged in
        if (User.getKey('access_token')) {
            pageStack.clear();
            pageStack.push(tabs);

            if (!User.getKey('app_rotation')) {
                User.setKey('app_rotation', 'true');
                mainView.automaticOrientation = true;
            } else {
                mainView.automaticOrientation = User.getKey('app_rotation');
            }
            if (!User.getKey('dark_theme')) {
                User.setKey('dark_theme', 'false');
            }
            if (!User.getKey('justified_text')) {
                User.setKey('justified_text', 'false');
            }
            if (!User.getKey('open_best_view')) {
                User.setKey('open_best_view', 'true');
            }
            if (!User.getKey('auto_download')) {
                User.setKey('auto_download', 'false');
            }
            if (!User.getKey('auto_download_articles')) {
                User.setKey('auto_download_articles', 'true');
            }

            if (refr == true) {
                myListPage.home(true)
            }
        // Not logged in
        } else {
            // First obtain a request token
            Scripts.get_request_token();
        }
    }

    // Share url to the PockIt
    Connections {
        target: ContentHub
        onShareRequested: {
            var title = transfer.items[0]['title'];
            var url = transfer.items[0]['url'];

            if (Connectivity.online) {
                Scripts.add_item(url, title);
            }
        }
    }
    Component {
        id: shareComponent
        ContentItem { }
    }

    // Share dialog for sharing url to other apps
    Component {
        id: shareDialog
        ContentShareDialog { }
    }

    // Article Styles
    Component {
        id: stylesComponent
        ArticleStyles { }
    }

    // Sync dialog
    Component {
        id: downloadDialog
        DownloadingPopup { }
    }

    // Tag Edit dialog
    Component {
        id: tagEditDialog
        TagEditDialog { }
    }

    PageStack {
        id: pageStack
        Component.onCompleted: home()
    }

    Tabs {
        id: tabs
        visible: false

        Tab {
            id: myListTab
            MyListTab {
                id: myListPage
            }
        }

        Tab {
            id: favListTab
            FavListTab {
                id: favListPage
            }
        }

        Tab {
            id: archiveListTab
            ArchiveListTab {
                id: archiveListPage
            }
        }

        Tab {
            id: tagsTab
            TagsListTab {
                id: tagsListPage
            }
        }
    }

    Page {
        id: tagEntries
        visible: false
        header: PageHeader {
            title: i18n.tr("Tag")
            StyleHints {
                backgroundColor: currentTheme.backgroundColor
                foregroundColor: currentTheme.baseFontColor
            }
            trailingActionBar {
                numberOfSlots: 2
                actions: [searchAction, settingsAction, refreshAction, aboutAction]
            }
        }
        TagEntriesPage {
            id: tagEntriesPage
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                top: tagEntries.header.bottom
            }
        }
    }

    Page {
        id: entryTags
        visible: false
        header: PageHeader {
            title: i18n.tr("Edit Tags")
            StyleHints {
                backgroundColor: currentTheme.backgroundColor
                foregroundColor: currentTheme.baseFontColor
            }
            trailingActionBar {
                actions: [
                    Action {
                        id: saveAction
                        text: i18n.tr("Save")
                        iconName: "save"
                        onTriggered: {
                            entryTagsPage.save()
                        }
                    }
                ]
            }
        }
        EntryTagsPage {
            id: entryTagsPage
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                top: entryTags.header.bottom
            }
        }
    }

    // Article view
    Page {
        id: articleView
        visible: false

        property var entry_url
        property var entry_id
        property var entry_title
        property var favorite
        property var archived
        property var view

        header: PageHeader {
            title: i18n.tr(" ")
            StyleHints {
                backgroundColor: currentTheme.backgroundColor
                foregroundColor: currentTheme.baseFontColor
            }
            flickable: articleBody
            trailingActionBar {
                numberOfSlots: 3
                actions: [
                    Action {
                        id: switchToWebView
                        enabled: articleView.entry_url != ''
                        text: articleView.view == 'article' ? i18n.tr("Web View") : i18n.tr("Article View")
                        iconName: articleView.view == 'article' ? "stock_website" : "stock_note"
                        onTriggered: {
                            if (articleView.view == 'article') {
                                articleBody.url = articleView.entry_url;
                                articleView.view = 'web';
                            } else {
                                Scripts.parseArticleView(articleView.entry_url, articleView.entry_id, true);
                            }
                        }
                    },
                    Action {
                        id: external
                        enabled: articleView.entry_url != ''
                        text: i18n.tr("External")
                        iconName: "external-link"
                        onTriggered: {
                            Qt.openUrlExternally(articleView.entry_url)
                        }
                    },
                    Action {
                        enabled: Connectivity.online
                        id: refresh
                        text: i18n.tr("Refresh")
                        iconName: "reload"
                        onTriggered: {
                            if (articleView.view == 'article') {
                                Scripts.get_article(articleView.entry_id, articleView.entry_url, false, 0, false, false, false, true, true);
                            } else {
                                articleBody.url = articleView.entry_url;
                            }
                        }
                    },
                    Action {
                        enabled: Connectivity.online
                        iconName: "share"
                        text: i18n.tr("Share")
                        onTriggered: {
                            PopupUtils.open(shareDialog, pageStack, {"contentType": ContentType.Links, "path": articleView.entry_url});
                        }
                    },
                    Action {
                        enabled: Connectivity.online
                        iconName: "tick"
                        text: articleView.archived == "1" ? i18n.tr("Re-add") : i18n.tr("Archive")
                        onTriggered: {
                            if (articleView.archived == "1") {
                                Scripts.archive_item(articleView.entry_id, '0')
                                text = i18n.tr("Archive")
                                articleView.archived = "0"
                            } else {
                                Scripts.archive_item(articleView.entry_id, '1')
                                text = i18n.tr("Re-add")
                                articleView.archived = "1"
                            }
                            myListPage.home(true, true)
                            favListPage.home()
                            archiveListPage.home()
                        }
                    },
                    Action {
                        enabled: Connectivity.online
                        iconName: "tag"
                        text: i18n.tr("Tags")
                        onTriggered: {
                            entryTagsPage.entry_id = articleView.entry_id
                            entryTagsPage.home()
                            pageStack.push(entryTags)
                        }
                    },
                    Action {
                        enabled: Connectivity.online
                        iconName: "starred"
                        text: articleView.favorite == "1" ? i18n.tr("Unfavorite") : i18n.tr("Favorite")
                        onTriggered: {
                            if (articleView.favorite == "1") {
                                Scripts.fav_item(articleView.entry_id, 0)
                                text = i18n.tr("Favorite")
                                articleView.favorite = "0"
                            } else {
                                Scripts.fav_item(articleView.entry_id, 1)
                                text = i18n.tr("Unfavorite")
                                articleView.favorite = "1"
                            }
                            favListPage.home()
                            archiveListPage.home()
                            myListPage.home(true, true)
                        }
                    },
                    Action {
                        enabled: Connectivity.online
                        iconName: "delete"
                        text: i18n.tr("Remove")
                        onTriggered: {
                            Scripts.delete_item(articleView.entry_id)
                            myListPage.home(true, true)
                            favListPage.home()
                            archiveListPage.home()
                        }
                    },
                    Action {
                        id: displaySettings
                        enabled: articleView.view == 'article'
                        text: i18n.tr("Display Settings")
                        iconName: "settings"
                        onTriggered: {
                            PopupUtils.open(stylesComponent)
                        }
                    }
                ]
            }
        }

        WebContext {
            id: webcontext
            userAgent: "Mozilla/5.0 (Linux; U; Android 4.0.3; ko-kr; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30"
        }

        Oxide.WebView {
            id: articleBody
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                top: articleView.header.bottom
            }
            context: webcontext
            onNavigationRequested: {
                request.action = Oxide.NavigationRequest.ActionReject;
                Qt.openUrlExternally(request.url);
            }
        }
    }
}

