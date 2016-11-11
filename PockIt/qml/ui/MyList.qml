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

    header: state == "default" ? defaultHeader : multiselectableHeader
    state: "default"

    ItemMultiSelectableHeader {
        id: multiselectableHeader
        visible: myListPage.state == "selection"
        title: i18n.tr("PockIt")
        listview: myListView
        itemstype: "all"
    }

    ItemDefaultHeader {
        id: defaultHeader
        visible: myListPage.state == "default"
        title: i18n.tr("PockIt")
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

    }

    ItemListView {
        id: myListView
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: myListPage.header.bottom
        }
        cacheBuffer: parent.height*2
        model: myListModel
        page: myListPage
    }
}
