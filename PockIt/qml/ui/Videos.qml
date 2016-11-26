import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3

import "../components"

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

Page {
    id: videosPage

    header: state == "default" ? defaultHeader : multiselectableHeader
    state: "default"

    property int active_section: 0

    ItemMultiSelectableHeader {
        id: multiselectableHeader
        visible: videosPage.state == "selection"
        title: i18n.tr("Videos")
        listview: videosView
        itemstype: "all"
    }

    ItemDefaultHeader {
        id: defaultHeader
        visible: videosPage.state == "default"
        title: i18n.tr("Videos")
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
                },
                Action {
                    text: i18n.tr("Archive")
                    onTriggered: {
                        active_section = 1
                    }
                }
            ]
        }
    }

    function get_videos_list() {
        var list_sort = listSort == 'DESC' ? "DESC" : "ASC";

        var db = LocalDB.init();
        db.transaction(function(tx) {
            var rs = tx.executeSql("SELECT item_id, given_title, resolved_title, resolved_url, sortid, favorite, has_video, has_image, image, images, is_article, status, time_added FROM Entries WHERE has_video = ? AND status = ? ORDER BY time_added " + list_sort, ["2", "0"])

            if (rs.rows.length === 0) {

            } else {
                var dbEntriesData = []
                for(var i = 0; i < rs.rows.length; i++) {
                    dbEntriesData.push(rs.rows.item(i));

                    // Tags
                    var rs_t = tx.executeSql("SELECT * FROM Tags WHERE entry_id = ?", rs.rows.item(i).item_id);
                    var tags = [];
                    for (var j = 0; j < rs_t.rows.length; j++) {
                        tags.push(rs_t.rows.item(j));
                    }
                }

                // Start entries worker
                entries_worker.sendMessage({'entries_feed': 'videosList', 'db_entries': dbEntriesData, 'db_tags': tags, 'entries_model': videosListModel, 'clear_model': true});
            }
        })
    }

    function get_videos_archive_list() {
        var list_sort = listSort == 'DESC' ? "DESC" : "ASC";

        var db = LocalDB.init();
        db.transaction(function(tx) {
            var rs = tx.executeSql("SELECT item_id, given_title, resolved_title, resolved_url, sortid, favorite, has_video, has_image, image, images, is_article, status, time_added FROM Entries WHERE has_video = ? AND status = ? ORDER BY time_added " + list_sort, ["2", "1"])

            if (rs.rows.length === 0) {

            } else {
                var dbEntriesData = []
                for(var i = 0; i < rs.rows.length; i++) {
                    dbEntriesData.push(rs.rows.item(i));

                    // Tags
                    var rs_t = tx.executeSql("SELECT * FROM Tags WHERE entry_id = ?", rs.rows.item(i).item_id);
                    var tags = [];
                    for (var j = 0; j < rs_t.rows.length; j++) {
                        tags.push(rs_t.rows.item(j));
                    }
                }

                // Start entries worker
                entries_worker.sendMessage({'entries_feed': 'videosList', 'db_entries': dbEntriesData, 'db_tags': tags, 'entries_model': videosArchiveListModel, 'clear_model': true});
            }
        })
    }

    function home() {
        videosListModel.clear()
        videosArchiveListModel.clear()
        get_videos_list()
        get_videos_archive_list()
    }

    Component.onCompleted: {
        get_videos_list()
        get_videos_archive_list()
    }

    ItemListView {
        id: videosView
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: videosPage.header.bottom
        }
        cacheBuffer: parent.height*2
        model: active_section == 0 ? videosListModel : videosArchiveListModel
        page: videosPage
    }
}
