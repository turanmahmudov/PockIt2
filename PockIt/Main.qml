import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import QtSystemInfo 5.0
import Qt.labs.settings 1.0
import Ubuntu.Components 1.3
import Ubuntu.Connectivity 1.0
import Ubuntu.Content 1.1

import "qml/components"
import "qml/ui" as Ui
import "qml/themes" as Themes

import "qml/js/localdb.js" as LocalDB
import "qml/js/user.js" as User
import "qml/js/apiKeys.js" as ApiKeys
import "qml/js/scripts.js" as Scripts

MainView {
    id: mainView
    objectName: "mainView"
    applicationName: "pockit.turan-mahmudov-l"

    automaticOrientation: true
    anchorToKeyboard: true

    width: units.gu(50)
    height: units.gu(80)

    Settings {
        id: settings

        property bool firstRun: true

        property bool firstSync: true

        property bool darkTheme: false
        property bool justifiedText: false
        property bool openBestView: true
        property bool autoSync: true
        property bool downloadArticlesSync: true
        property string listSort: 'DESC'
    }

    // Keep screen on
    ScreenSaver {
        id: screenSaver
        screenSaverEnabled: true
    }

    // Connectivity
    Connections {
        target: Connectivity
    }

    // Themes
    Themes.ThemeManager {
        id: themeManager
        themes: [
            {name: i18n.tr('Light'), source: Qt.resolvedUrl('qml/themes/Light.qml')},
            {name: i18n.tr('Dark'), source: Qt.resolvedUrl('qml/themes/Dark.qml')}
        ]
        source: settings.darkTheme == true ? "Dark.qml" : "Light.qml"
    }
    property alias currentTheme: themeManager.theme
    property var themeManager: themeManager
    theme.name: currentTheme.baseThemeName

    // Variables
    property string appVersion: '0.2'

    property alias firstRun: settings.firstRun

    property alias firstSync: settings.firstSync

    property alias darkTheme: settings.darkTheme
    property alias justifiedText: settings.justifiedText
    property alias openBestView: settings.openBestView
    property alias autoSync: settings.autoSync
    property alias downloadArticlesSync: settings.downloadArticlesSync
    property alias listSort: settings.listSort

    property bool wideScreen: width > units.gu(100)
    property bool loadedUI: false
    property bool isArticleOpen: false
    property bool syncing: false

    // Navigation Menu Actions
    property list<Action> navActions: [
        Action {
            objectName: "myListTabAction"
            text: i18n.tr("My List")
            iconName: "view-list-symbolic"
            onTriggered: {
                pageLayout.replacePage(myListPage)
            }
        },
        Action {
            objectName: "articlesTabAction"
            text: i18n.tr("Articles")
            iconSource: Qt.resolvedUrl("qml/images/blank.png")
            onTriggered: {
                pageLayout.replacePage(articlesPage)
            }
        },
        Action {
            objectName: "videosTabAction"
            text: i18n.tr("Videos")
            iconSource: Qt.resolvedUrl("qml/images/blank.png")
            onTriggered: {
                pageLayout.replacePage(videosPage)
            }
        },
        Action {
            objectName: "imagesTabAction"
            text: i18n.tr("Images")
            iconSource: Qt.resolvedUrl("qml/images/blank.png")
            onTriggered: {
                pageLayout.replacePage(imagesPage)
            }
        },
        Action {
            objectName: "favoritesTabAction"
            text: i18n.tr("Favorites")
            iconName: "starred"
            onTriggered: {
                pageLayout.replacePage(favoritesPage)
            }
        },
        Action {
            objectName: "archiveTabAction"
            text: i18n.tr("Archive")
            iconName: "tick"
            onTriggered: {
                pageLayout.replacePage(archivePage)
            }
        },
        Action {
            objectName: "tagsTabAction"
            text: i18n.tr("Tags")
            iconName: "tag"
            onTriggered: {
                pageLayout.replacePage(tagsPage)
            }
        }
    ]

    // Actions
    actions: [
        Action {
            id: searchAction
            text: i18n.tr("Search")
            keywords: i18n.tr("Search")
            iconName: "search"
            onTriggered: {
                isArticleOpen = false
                pageLayout.addPageToCurrentColumn(pageLayout.primaryPage, Qt.resolvedUrl("qml/ui/Search.qml"))
            }
        },
        Action {
            id: settingsAction
            text: i18n.tr("Settings")
            keywords: i18n.tr("Settings")
            iconName: "settings"
            onTriggered: {
                isArticleOpen = false
                pageLayout.addPageToCurrentColumn(pageLayout.primaryPage, Qt.resolvedUrl("qml/ui/Settings.qml"))
            }
        },
        Action {
            id: refreshAction
            text: syncing ? i18n.tr("Stop Refresh") : i18n.tr("Refresh")
            keywords: syncing ? i18n.tr("Stop Refresh") : i18n.tr("Refresh")
            iconName: "sync"
            onTriggered: {
                if (syncing) {

                } else {

                }
            }
        },
        Action {
            id: helpAction
            text: i18n.tr("Help")
            keywords: i18n.tr("Help")
            iconName: "help"
            onTriggered: {
                isArticleOpen = false
                pageLayout.addPageToCurrentColumn(pageLayout.primaryPage, Qt.resolvedUrl("qml/ui/Help.qml"))
            }
        }
    ]

    Component.onCompleted: {
        loading.visible = false

        loadedUI = true;

        //settings.firstRun = true

        init()
    }

    // Functions
    function init() {

        if (firstRun) {
            pageLayout.replacePageSource(Qt.resolvedUrl("qml/components/Walkthrough/FirstRunWalkthrough.qml"))
        } else {
            pageLayout.replacePage(myListPage)

            // Login required
            if (!User.getKey('access_token')) {
                //Scripts.get_request_token()     
            } else {
                Scripts.get_list()
            }
        }
    }

    // Workers
    // Sync Worker
    WorkerScript {
        id: sync_worker
        source: "qml/js/sync_worker.js"
        onMessage: {
            if (messageObject.action === "ENTRIES_WORKS") {
                Scripts.complete_entries_works(messageObject.entries_works, messageObject.api_entries)
            }
        }
    }

    // Models
    ListModel {
        id: myListModel
    }

    AdaptivePageLayout {
        id: pageLayout
        anchors.fill: parent
        layouts: PageColumnsLayout {
            when: wideScreen && isArticleOpen
            PageColumn {
                minimumWidth: units.gu(50)
                maximumWidth: units.gu(70)
                preferredWidth: units.gu(60)
            }
            PageColumn {
                fillWidth: true
            }
        }

        // Pages
        Ui.MyList {
            id: myListPage
        }
        Ui.Articles {
            id: articlesPage
        }
        Ui.Images {
            id: imagesPage
        }
        Ui.Videos {
            id: videosPage
        }
        Ui.Favorites {
            id: favoritesPage
        }
        Ui.Archive {
            id: archivePage
        }
        Ui.Tags {
            id: tagsPage
        }

        // Functions
        function replacePageSource(pageSource) {
            pageLayout.removePages(pageLayout.primaryPage)
            isArticleOpen = false
            pageLayout.primaryPageSource = pageSource
        }

        function replacePage(pageId) {
            pageLayout.removePages(pageLayout.primaryPage)
            isArticleOpen = false
            pageLayout.primaryPage = pageId
        }
    }

    LoadingSpinnerComponent {
        id: loading
    }
}
