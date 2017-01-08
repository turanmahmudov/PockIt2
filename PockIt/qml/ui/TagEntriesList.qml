import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3

import "../components"

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

Page {
    id: tagEntriesPage

    // Params come from Tags
    property string tag: "0"

    header: state == "default" ? defaultHeader : multiselectableHeader
    state: "default"

    ItemMultiSelectableHeader {
        id: multiselectableHeader
        visible: tagEntriesPage.state == "selection"
        title: tag == "0" ? i18n.tr("All Untagged Items") : tag
        listview: tagEntriesView
        itemstype: "all"
        pageId: "tagEntriesPage"
        pageIdObject: tagEntriesPage
    }

    PageHeader {
        id: defaultHeader
        visible: tagEntriesPage.state == "default"
        title: tag == "0" ? i18n.tr("All Untagged Items") : tag
        leadingActionBar {
            actions: [
                Action {
                    id: closePageAction
                    text: i18n.tr("Close")
                    iconName: "back"
                    onTriggered: {
                        isTagOpen = false
                        isArticleOpen = false
                        pageLayout.removePages(tagEntriesPage)
                    }
                }

            ]
        }
    }

    function get_tag_list() {
        var list_sort = listSort == 'DESC' ? "DESC" : "ASC";

        var db = LocalDB.init();
        db.transaction(function(tx) {
            if (tag == "0") {
                var rs = tx.executeSql("SELECT item_id, given_title, resolved_title, resolved_url, sortid, favorite, has_video, has_image, image, images, is_article, status, time_added FROM Entries WHERE item_id NOT IN (SELECT entry_id FROM Tags) AND status = ? ORDER BY time_added " + list_sort, ["0"]);
            } else {
                var rs = tx.executeSql("SELECT item_id, given_title, resolved_title, resolved_url, sortid, favorite, has_video, has_image, image, images, is_article, status, time_added FROM Entries WHERE item_id IN (SELECT entry_id FROM Tags WHERE Tags.tag = ?) AND status = ? ORDER BY time_added " + list_sort, [tag, "0"]);
            }

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
                entries_worker.sendMessage({'entries_feed': 'tagEntriesList', 'db_entries': dbEntriesData, 'db_tags': all_tags, 'entries_model': tagEntriesModel, 'clear_model': true});
            }
        })
    }

    function home() {
        tagEntriesModel.clear()
        get_tag_list()
    }

    SyncingProgressBar {
        id: syncingProgressBar
        anchors.top: tagEntriesPage.header.bottom
        visible: syncing
    }

    ItemListView {
        id: tagEntriesView
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: !syncing ? tagEntriesPage.header.bottom : syncingProgressBar.bottom
        }
        cacheBuffer: parent.height*2
        model: tagEntriesModel
        page: tagEntriesPage
        pageString: "tagEntriesPage"
    }
}
