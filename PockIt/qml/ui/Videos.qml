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
    property bool isEmpty: true
    property bool isArchiveEmpty: true

    ItemMultiSelectableHeader {
        id: multiselectableHeader
        visible: videosPage.state == "selection"
        title: i18n.tr("Videos")
        listview: active_section == 0 ? videosView : videosArchiveView
        itemstype: active_section == 0 ? "all" : "archive"
        pageId: "videosPage"
        pageIdObject: videosPage
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
                isEmpty = true
            } else {
                isEmpty = false

                var all_tags = {}
                var dbEntriesData = []
                for(var i = 0; i < rs.rows.length; i++) {
                    dbEntriesData.push(rs.rows.item(i));

                    // Tags
                    var rs_t = tx.executeSql("SELECT * FROM Tags WHERE entry_id = ?", rs.rows.item(i).item_id);
                    var tags = [];
                    for (var j = 0; j < rs_t.rows.length; j++) {
                        tags.push(rs_t.rows.item(j));
                    }
                    all_tags[rs.rows.item(i).item_id] = tags
                }

                // Start entries worker
                entries_worker.sendMessage({'entries_feed': 'videosList', 'db_entries': dbEntriesData, 'db_tags': all_tags, 'entries_model': videosListModel, 'clear_model': true});
            }
        })
    }

    function get_videos_archive_list() {
        var list_sort = listSort == 'DESC' ? "DESC" : "ASC";

        var db = LocalDB.init();
        db.transaction(function(tx) {
            var rs = tx.executeSql("SELECT item_id, given_title, resolved_title, resolved_url, sortid, favorite, has_video, has_image, image, images, is_article, status, time_added FROM Entries WHERE has_video = ? AND status = ? ORDER BY time_added " + list_sort, ["2", "1"])

            if (rs.rows.length === 0) {
                isArchiveEmpty = true
            } else {
                isArchiveEmpty = false

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
                entries_worker.sendMessage({'entries_feed': 'videosList', 'db_entries': dbEntriesData, 'db_tags': all_tags, 'entries_model': videosArchiveListModel, 'clear_model': true});
            }
        })
    }

    function home() {
        videosListModel.clear()
        videosArchiveListModel.clear()
        get_videos_list()
        get_videos_archive_list()
        reinit_videos_onvisible = false
    }

    Component.onCompleted: {
        get_videos_list()
        get_videos_archive_list()
    }

    SyncingProgressBar {
        id: syncingProgressBar
        anchors.top: videosPage.header.bottom
        visible: syncing
    }

    ItemListView {
        id: videosView
        visible: active_section == 0
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: !syncing ? videosPage.header.bottom : syncingProgressBar.bottom
        }
        cacheBuffer: parent.height*2
        model: videosListModel
        page: videosPage
        pageString: "videosPage"
    }

    ItemListView {
        id: videosArchiveView
        visible: active_section == 1
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: !syncing ? videosPage.header.bottom : syncingProgressBar.bottom
        }
        cacheBuffer: parent.height*2
        model: videosArchiveListModel
        page: videosPage
        pageString: "videosPage"
    }

    EmptyBox {
        visible: isEmpty && active_section == 0
        anchors {
            top: !syncing ? videosPage.header.bottom : syncingProgressBar.bottom
            topMargin: units.gu(3)
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width

        icon: false
        title: i18n.tr("No Videos Found")
        description: i18n.tr("There are no videos in your List.")
    }

    EmptyBox {
        visible: isArchiveEmpty && active_section == 1
        anchors {
            top: !syncing ? videosPage.header.bottom : syncingProgressBar.bottom
            topMargin: units.gu(3)
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width

        icon: false
        title: i18n.tr("No Videos Found")
        description: i18n.tr("There are no videos in your Archive.")
    }
}
