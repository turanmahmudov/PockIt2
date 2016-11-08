import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import QtSystemInfo 5.0
import Qt.labs.settings 1.0
import Ubuntu.Components 1.3
import Ubuntu.Connectivity 1.0
import Ubuntu.Content 1.1

import "qml/components"

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

        property bool firstRun: false
    }

    ScreenSaver {
        id: screenSaver
        screenSaverEnabled: true
    }

    // Variables
    property string appVersion: '0.2'

    property alias firstRun: settings.firstRun

    property bool loadedUI: false

    // Navigation Menu Actions
    property list<Action> navActions: [
        Action {
            objectName: "myListTabAction"
            text: i18n.tr("My List")
            iconName: "view-list-symbolic"
            onTriggered: {
                pageLayout.pushPage(Qt.resolvedUrl("qml/ui/MyList.qml"))
            }
        },
        Action {
            objectName: "favoritesTabAction"
            text: i18n.tr("Favorites")
            iconName: "starred"
            onTriggered: {
                pageLayout.pushPage(Qt.resolvedUrl("qml/ui/Favorites.qml"))
            }
        },
        Action {
            objectName: "archiveTabAction"
            text: i18n.tr("Archive")
            iconName: "tick"
            onTriggered: {
                pageLayout.pushPage(Qt.resolvedUrl("qml/ui/Archive.qml"))
            }
        },
        Action {
            objectName: "tagsTabAction"
            text: i18n.tr("Tags")
            iconName: "tag"
            onTriggered: {
                pageLayout.pushPage(Qt.resolvedUrl("qml/ui/Tags.qml"))
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
            id: switchTileViewAction
            text: i18n.tr("Switch to Tile View")
            keywords: i18n.tr("Switch to Tile View")
            iconName: "view-grid-symbolic"
            onTriggered: {

            }
        },
        Action {
            id: switchListViewAction
            text: i18n.tr("Switch to List View")
            keywords: i18n.tr("Switch to List View")
            iconName: "view-list-symbolic"
            onTriggered: {

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
        loading.visible = true

        loadedUI = true;

        pageLayout.pushPage(Qt.resolvedUrl("qml/ui/MyList.qml"))
    }

    AdaptivePageLayout {
        id: pageLayout
        anchors.fill: parent
        layouts: PageColumnsLayout {
            when: width > units.gu(60)
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
        function pushPage(pageSource) {
            pageLayout.primaryPageSource = pageSource
        }
    }

    LoadingSpinnerComponent {
        id: loading
    }
}
