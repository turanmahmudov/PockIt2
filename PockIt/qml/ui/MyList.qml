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

    property int active_section: 0
    property bool isEmpty: true

    ItemMultiSelectableHeader {
        id: multiselectableHeader
        visible: myListPage.state == "selection"
        title: i18n.tr("PockIt")
        listview: myListView
        pageId: "myListPage"
        pageIdObject: myListPage
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
                        active_section = 0
                    }
                }
            ]
        }
    }

    function get_my_list() {
        var list_sort = listSort == 'DESC' ? "DESC" : "ASC";

        var db = LocalDB.init();
        db.transaction(function(tx) {
            var rs = tx.executeSql("SELECT item_id, given_title, resolved_title, resolved_url, sortid, favorite, has_video, has_image, image, images, is_article, status, time_added FROM Entries WHERE status = ? ORDER BY time_added " + list_sort, "0")

            if (rs.rows.length === 0) {
                isEmpty = true
            } else {
                isEmpty = false

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
                entries_worker.sendMessage({'entries_feed': 'myList', 'db_entries': dbEntriesData, 'db_tags': all_tags, 'entries_model': myListModel, 'clear_model': true});
            }
        })
    }

    function home() {
        myListModel.clear()
        get_my_list()
        reinit_mylist_onvisible = false
    }

    Component.onCompleted: {
        get_my_list()
    }

    SyncingProgressBar {
        id: syncingProgressBar
        anchors.top: myListPage.header.bottom
        visible: syncing
    }

    ItemListView {
        id: myListView
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: !syncing ? myListPage.header.bottom : syncingProgressBar.bottom
        }
        cacheBuffer: parent.height*2
        model: myListModel
        page: myListPage
        pageString: "myListPage"
    }

    EmptyBox {
        visible: isEmpty && active_section == 0
        anchors {
            top: !syncing ? myListPage.header.bottom : syncingProgressBar.bottom
            topMargin: units.gu(3)
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width

        icon: false
        title: i18n.tr("Your List Empty")
        description: i18n.tr("There are many ways to add content to your List.")
    }
}
