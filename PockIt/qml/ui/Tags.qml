import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3

import "../components"

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

Page {
    id: tagsPage

    property bool isEmpty: true

    header: PageHeader {
        title: i18n.tr("Tags")

        leadingActionBar {
            actions: navActions
        }
        trailingActionBar {
            numberOfSlots: (isArticleOpen && wideScreen) || !wideScreen ? 2 : 5
            actions: (isArticleOpen && wideScreen) || !wideScreen ? [searchAction, refreshAction, settingsAction, helpAction] : [helpAction, settingsAction, refreshAction, searchAction]
        }
    }

    function get_tags() {
        var list_sort = listSort == 'DESC' ? "DESC" : "ASC";

        var db = LocalDB.init();
        db.transaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM Tags GROUP BY tag ORDER BY tag");

            if (rs.rows.length === 0) {
                isEmpty = true
            } else {
                isEmpty = false

                var dbTagsData = []
                for (var i = 0; i < rs.rows.length; i++) {
                    dbTagsData.push(rs.rows.item(i))
                }

                // Start tags worker
                tags_worker.sendMessage({'db_tags': dbTagsData, 'model': tagsModel, 'clear_model': true});
            }
        })
    }

    function home() {
        tagsModel.clear()
        get_tags()
    }

    Component.onCompleted: {
        get_tags()
    }

    SyncingProgressBar {
        id: syncingProgressBar
        anchors.top: tagsPage.header.bottom
        visible: syncing
    }

    TagsListView {
        id: tagsView
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: !syncing ? tagsPage.header.bottom : syncingProgressBar.bottom
        }
        cacheBuffer: parent.height*2
        model: tagsModel
        page: tagsPage
    }

    EmptyBox {
        visible: isEmpty
        anchors {
            top: !syncing ? tagsPage.header.bottom : syncingProgressBar.bottom
            topMargin: units.gu(3)
            horizontalCenter: parent.horizontalCenter
        }
        width: parent.width

        icon: false
        title: i18n.tr("Tags List Empty")
        description: i18n.tr("To create a tag, swipe from right on an item in your list and tap the Tag button.")
    }
}
