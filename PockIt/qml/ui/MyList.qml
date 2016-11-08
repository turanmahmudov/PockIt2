import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: myListPage

    header: PageHeader {
        title: i18n.tr("PockIt")

        leadingActionBar {
            actions: navActions
        }
        trailingActionBar {
            numberOfSlots: 2
            actions: [searchAction, switchTileViewAction, refreshAction, settingsAction, helpAction]
        }
        extension: Sections {
            anchors {
                bottom: parent.bottom
            }
            actions: [
                Action {
                    text: i18n.tr("My List")
                    onTriggered: {
                    }
                },
                Action {
                    text: i18n.tr("Articles")
                    onTriggered: {
                    }
                },
                Action {
                    text: i18n.tr("Videos")
                    onTriggered: {
                    }
                },
                Action {
                    text: i18n.tr("Images")
                    onTriggered: {
                    }
                }
            ]
        }
    }
}
