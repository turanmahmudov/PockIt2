import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: articlesPage

    header: PageHeader {
        title: i18n.tr("Articles")

        leadingActionBar {
            actions: navActions
        }
        trailingActionBar {
            numberOfSlots: (isArticleOpen && wideScreen) || !wideScreen ? 2 : 5
            actions: (isArticleOpen && wideScreen) || !wideScreen ? [searchAction, refreshAction, settingsAction, helpAction] : [helpAction, settingsAction, refreshAction, searchAction]
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
                    text: i18n.tr("Archive")
                    onTriggered: {
                    }
                }
            ]
        }
    }
}
