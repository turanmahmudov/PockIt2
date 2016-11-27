import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3

import "../components"

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

Page {
    id: favoritesPage

    header: state == "default" ? defaultHeader : multiselectableHeader
    state: "default"

    ItemMultiSelectableHeader {
        id: multiselectableHeader
        visible: favoritesPage.state == "selection"
        title: i18n.tr("Favorites")
        listview: favoritesView
        itemstype: "favorites"
    }

    ItemDefaultHeader {
        id: defaultHeader
        visible: favoritesPage.state == "default"
        title: i18n.tr("Favorites")
    }

    function home() {

    }

    Component.onCompleted: {

    }

    ItemListView {
        id: favoritesView
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: favoritesPage.header.bottom
        }
        cacheBuffer: parent.height*2
        model: myListModel
        page: favoritesPage
    }
}
