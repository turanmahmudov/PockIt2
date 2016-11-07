import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import QtSystemInfo 5.0
import Qt.labs.settings 1.0
import Ubuntu.Components 1.3
import Ubuntu.Connectivity 1.0
import Ubuntu.Content 1.1

import "qml/components"
import "qml/ui"

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

        property bool firstRun: false
    }

    ScreenSaver {
        id: screenSaver
        screenSaverEnabled: true
    }

    // Variables
    property string appVersion: '0.2'

    property alias firstRun: settings.firstRun

    property bool wideAspect: width >= units.gu(95) && loadedUI
    property bool loadedUI: false

    // Navigation Menu
    property list<Action> navActions: [
        Action {
            objectName: "myListTabAction"
            text: i18n.tr("My List")
            iconName: "view-list-symbolic"
            onTriggered: pageLayout.primaryPageSource = Qt.resolvedUrl("qml/ui/MyList.qml")
        },
        Action {
            objectName: "favoritesTabAction"
            text: i18n.tr("Favorites")
            iconName: "starred"
            onTriggered: pageLayout.primaryPageSource = Qt.resolvedUrl("qml/ui/Favorites.qml")
        },
        Action {
            objectName: "archiveTabAction"
            text: i18n.tr("Archive")
            iconName: "tick"
            onTriggered: pageLayout.primaryPageSource = Qt.resolvedUrl("qml/ui/Archive.qml")
        },
        Action {
            objectName: "tagsTabAction"
            text: i18n.tr("Tags")
            iconName: "tag"
            onTriggered: pageLayout.primaryPageSource = Qt.resolvedUrl("qml/ui/Tags.qml")
        }
    ]

    Component.onCompleted: {
        loading.visible = true

        loadedUI = true;
    }

    AdaptivePageLayout {
        id: pageLayout
        anchors.fill: parent
        primaryPage: MyList {
            anchors.fill: parent
        }
        layouts: PageColumnsLayout {
            when: width > units.gu(80)
            PageColumn {
                minimumWidth: units.gu(40)
                maximumWidth: units.gu(50)
                preferredWidth: units.gu(50)
            }
            PageColumn {
                fillWidth: true
            }
        }
    }

    Component {
        id: articleViewComponent

        ArticleViewPage {
            anchors.fill: parent
        }
    }

    LoadingSpinnerComponent {
        id: loading
    }
}
