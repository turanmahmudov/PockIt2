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

    property bool isEmpty: true

    ItemMultiSelectableHeader {
        id: multiselectableHeader
        visible: archivePage.state == "selection"
        title: i18n.tr("Archive")
        listview: archiveView
        itemstype: "archive"
        pageId: "archivePage"
        pageIdObject: archivePage
    }

    ItemDefaultHeader {
        id: defaultHeader
        visible: archivePage.state == "default"
        title: i18n.tr("Archive")
    }

    function get_archive_list() {
        var list_sort = listSort == 'DESC' ? "DESC" : "ASC";

        var db = LocalDB.init();
        db.transaction(function(tx) {
            var rs = tx.executeSql("SELECT item_id, given_title, resolved_title, resolved_url, sortid, favorite, has_video, has_image, image, images, is_article, status, time_added FROM Entries WHERE status = ? ORDER BY time_added " + list_sort, "1")

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
                entries_worker.sendMessage({'entries_feed': 'archiveList', 'db_entries': dbEntriesData, 'db_tags': all_tags, 'entries_model': archiveListModel, 'clear_model': true});
            }
        })
    }

    function home() {
        archiveListModel.clear()
        get_archive_list()
        reinit_archive_onvisible = false
    }

    Component.onCompleted: {
        get_archive_list()
    }

    SyncingProgressBar {
        id: syncingProgressBar
        anchors.top: archivePage.header.bottom
        visible: syncing
    }

    ItemListView {
        id: archiveView
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: !syncing ? archivePage.header.bottom : syncingProgressBar.bottom
        }
        cacheBuffer: parent.height*2
        model: archiveListModel
        page: archivePage
        pageString: "archivePage"
    }

    EmptyBox {
        visible: isEmpty
        anchors {
            top: !syncing ? archivePage.header.bottom : syncingProgressBar.bottom
            topMargin: units.gu(3)
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width

        icon: false
        title: i18n.tr("Archive Empty")
        description: i18n.tr("The Archive can be used to list items that you're finished with.")
        description2: i18n.tr("To add items to your Archive, tap the checkmark button after opening an item.")
    }
}
