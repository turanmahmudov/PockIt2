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

    function get_favorites_list() {
        var list_sort = listSort == 'DESC' ? "DESC" : "ASC";

        var db = LocalDB.init();
        db.transaction(function(tx) {
            var rs = tx.executeSql("SELECT item_id, given_title, resolved_title, resolved_url, sortid, favorite, has_video, has_image, image, images, is_article, status, time_added FROM Entries WHERE favorite = ? AND status = ? ORDER BY time_added " + list_sort, ["1", "0"])

            if (rs.rows.length === 0) {

            } else {
                var all_tags = {}
                var dbEntriesData = []
                for (var i = 0; i < rs.rows.length; i++) {
                    dbEntriesData.push(rs.rows.item(i))

                    // Tags
                    var rs_t = tx.executeSql("SELECT * FROM Tags WHERE entry_id = ?", rs.rows.item(i).item_id);
                    var tags = []
                    for (var j = 0; j < rs_t.rows.length; j++) {
                        tags.push(rs_t.rows.item(j))
                    }
                    all_tags[rs.rows.item(i).item_id] = tags
                }

                // Start entries worker
                entries_worker.sendMessage({'entries_feed': 'favoritesList', 'db_entries': dbEntriesData, 'db_tags': all_tags, 'entries_model': favoritesListModel, 'clear_model': true});
            }
        })
    }

    function home() {
        favoritesListModel.clear()
        get_favorites_list()
    }

    Component.onCompleted: {
        get_favorites_list()
    }

    SyncingProgressBar {
        id: syncingProgressBar
        anchors.top: favoritesPage.header.bottom
        visible: syncing
    }

    ItemListView {
        id: favoritesView
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: !syncing ? favoritesPage.header.bottom : syncingProgressBar.bottom
        }
        cacheBuffer: parent.height*2
        model: favoritesListModel
        page: favoritesPage
    }
}
