import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3

import "../components"

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

Page {
    id: myListPage

    header: PageHeader {
        title: i18n.tr("PockIt")

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
                }
            ]
        }
    }

    Component.onCompleted: {
        if (!myListWorked) {

        }
    }

    ListView {
        id: myListView
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: myListPage.header.bottom
        }
        cacheBuffer: parent.height*2
        clip: true
        model: myListModel
        delegate: ItemListDelegate {
            pageId: myListPage
        }
    }
}
