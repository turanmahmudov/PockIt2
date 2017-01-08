import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3

import "../components"

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

Page {
    id: searchPage

    header: state == "default" ? defaultHeader : multiselectableHeader
    state: "default"

    property bool noQuery: true
    property bool isEmpty: true

    property string s_query: ""

    ItemMultiSelectableHeader {
        id: multiselectableHeader
        visible: searchPage.state == "selection"
        title: i18n.tr("Search")
        listview: searchView
        itemstype: "all"
        pageId: "searchPage"
        pageIdObject: searchPage
    }

    PageHeader {
        id: defaultHeader
        visible: searchPage.state == "default"
        title: i18n.tr("Search")
        leadingActionBar {
            actions: [
                Action {
                    id: closePageAction
                    text: i18n.tr("Close")
                    iconName: "back"
                    onTriggered: {
                        isArticleOpen = false
                        pageLayout.removePages(searchPage)
                    }
                }

            ]
        }

        contents: TextField {
            id: searchField
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            primaryItem: Icon {
                anchors.leftMargin: units.gu(0.2)
                height: parent.height*0.5
                width: height
                name: "find"
            }
            hasClearButton: true
            inputMethodHints: Qt.ImhNoPredictiveText
            onVisibleChanged: {
                if (visible) {
                    forceActiveFocus()
                }
            }
            onTextChanged: {
                if (searchField.text == "") {
                    s_query = ""
                    searchEntriesModel.clear()
                    noQuery = true
                } else {
                    s_query = searchField.text
                    home(searchField.text)
                    noQuery = false
                }
            }
        }
    }

    function get_search_list(search_query) {
        var list_sort = listSort == 'DESC' ? "DESC" : "ASC";

        var db = LocalDB.init();
        db.transaction(function(tx) {
            var lq = '%' + search_query + '%';
            var rs = tx.executeSql("SELECT item_id, given_title, resolved_title, given_url, resolved_url, sortid, favorite, has_video, has_image, image, images, is_article, status, time_added FROM Entries WHERE given_title LIKE ? OR resolved_title LIKE ? OR given_url LIKE ? OR resolved_url LIKE ? ORDER BY time_added " + list_sort, [lq, lq, lq, lq])

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
                entries_worker.sendMessage({'entries_feed': 'searchList', 'db_entries': dbEntriesData, 'db_tags': all_tags, 'entries_model': searchEntriesModel, 'clear_model': true});
            }
        })
    }

    function home(search_query) {
        searchEntriesModel.clear()
        get_search_list(search_query)
    }

    SyncingProgressBar {
        id: syncingProgressBar
        anchors.top: searchPage.header.bottom
        visible: syncing
    }

    ItemListView {
        id: searchView
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: !syncing ? searchPage.header.bottom : syncingProgressBar.bottom
        }
        cacheBuffer: parent.height*2
        model: searchEntriesModel
        page: searchPage
        pageString: "searchPage"
    }

    EmptyBox {
        visible: noQuery
        anchors {
            top: !syncing ? searchPage.header.bottom : syncingProgressBar.bottom
            topMargin: units.gu(3)
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width

        icon: true
        iconName: "find"
        subtitle: i18n.tr("Search by title or URL")
    }

    EmptyBox {
        visible: isEmpty && !noQuery
        anchors {
            top: !syncing ? searchPage.header.bottom : syncingProgressBar.bottom
            topMargin: units.gu(3)
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width

        icon: false
        title: i18n.tr("No Results Found")
        description: i18n.tr('There were no items in your list that matched your search for "'+searchField.text+'"')
    }
}
