import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import QtSystemInfo 5.0
import Qt.labs.settings 1.0
import Ubuntu.Components 1.3
import Ubuntu.Connectivity 1.0
import Ubuntu.Content 1.1

import "qml/components"
import "qml/themes" as Themes

import "qml/js/localdb.js" as LocalDB

MainView {
    id: mainView
    objectName: "mainView"
    applicationName: "pockit.turan-mahmudov-l"

    automaticOrientation: true
    anchorToKeyboard: true

    width: units.gu(100)
    height: units.gu(80)

    Settings {
        id: settings

        property bool firstRun: true

        property bool firstSync: true

        property bool darkTheme: false
        property bool justifiedText: false
        property bool openBestView: true
        property bool autoSync: false
        property bool downloadArticlesSync: false
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
    property bool wideScreen: width > units.gu(100)
    property bool loadedUI: false
    property bool isArticleOpen: false

    // Navigation Menu Actions
    property list<Action> navActions: [
        Action {
            objectName: "myListTabAction"
            text: i18n.tr("My List")
            iconName: "view-list-symbolic"
            onTriggered: {
                pageLayout.replacePage(Qt.resolvedUrl("qml/ui/MyList.qml"))
            }
        },
        Action {
            objectName: "favoritesTabAction"
            text: i18n.tr("Favorites")
            iconName: "starred"
            onTriggered: {
                pageLayout.replacePage(Qt.resolvedUrl("qml/ui/Favorites.qml"))
            }
        },
        Action {
            objectName: "archiveTabAction"
            text: i18n.tr("Archive")
            iconName: "tick"
            onTriggered: {
                pageLayout.replacePage(Qt.resolvedUrl("qml/ui/Archive.qml"))
            }
        },
        Action {
            objectName: "tagsTabAction"
            text: i18n.tr("Tags")
            iconName: "tag"
            onTriggered: {
                pageLayout.replacePage(Qt.resolvedUrl("qml/ui/Tags.qml"))
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
                pageLayout.addPageToCurrentColumn(pageLayout.primaryPage, Qt.resolvedUrl("qml/ui/Search.qml"))
            }
        },
        Action {
            id: settingsAction
            text: i18n.tr("Settings")
            keywords: i18n.tr("Settings")
            iconName: "settings"
            onTriggered: {
                pageLayout.addPageToCurrentColumn(pageLayout.primaryPage, Qt.resolvedUrl("qml/ui/Settings.qml"))
            }
        },
        Action {
            id: refreshAction
            text: i18n.tr("Refresh")
            keywords: i18n.tr("Refresh")
            iconName: "sync"
            onTriggered: {

            }
        },
        Action {
            id: helpAction
            text: i18n.tr("Help")
            keywords: i18n.tr("Help")
            iconName: "help"
            onTriggered: {
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
            pageLayout.replacePage(Qt.resolvedUrl("qml/components/Walkthrough/FirstRunWalkthrough.qml"))
        } else {
            pageLayout.replacePage(Qt.resolvedUrl("qml/ui/MyList.qml"))
        }

    }

    AdaptivePageLayout {
        id: pageLayout
        anchors.fill: parent
        layouts: PageColumnsLayout {
            when: wideScreen && isArticleOpen
            PageColumn {
                minimumWidth: units.gu(50)
                maximumWidth: units.gu(50)
                preferredWidth: units.gu(50)
            }
            PageColumn {
                fillWidth: true
            }
        }

        // Functions
        function replacePage(pageSource) {
            isArticleOpen = false
            pageLayout.primaryPageSource = pageSource
        }
    }

    LoadingSpinnerComponent {
        id: loading
    }
}
