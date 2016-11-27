import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3

import "../components"

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

Page {
    id: archivePage

    header: state == "default" ? defaultHeader : multiselectableHeader
    state: "default"

    ItemMultiSelectableHeader {
        id: multiselectableHeader
        visible: archivePage.state == "selection"
        title: i18n.tr("Archive")
        listview: archiveView
        itemstype: "archive"
    }

    ItemDefaultHeader {
        id: defaultHeader
        visible: archivePage.state == "default"
        title: i18n.tr("Archive")
    }

    function home() {

    }

    Component.onCompleted: {

    }

    ItemListView {
        id: archiveView
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: archivePage.header.bottom
        }
        cacheBuffer: parent.height*2
        model: myListModel
        page: archivePage
    }
}
