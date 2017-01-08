import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

PageHeader {
    property var listview
    property var itemstype
    property string pageId
    property var pageIdObject

    leadingActionBar {
        actions: [
            Action {
                text: i18n.tr("Cancel selection")
                iconName: "back"
                onTriggered: listview.closeSelection()
            }
        ]
    }
    trailingActionBar {
        numberOfSlots: 5
        actions: [
            Action {
                iconName: "delete"
                text: i18n.tr("Delete")
                visible: listview !== null ? listview.getSelectedIndices().length > 0 : false
                onTriggered: {
                    var items = []
                    var indicies = listview.getSelectedIndices()

                    listview.clearSelection()

                    for (var i = 0; i < indicies.length; i++) {
                        items.push(listview.model.get(indicies[i], listview.model.RoleModelData).item_id)
                    }

                    Scripts.delete_item(items, pageId)

                    listview.closeSelection()
                }
            },
            Action {
                iconName: "tag"
                text: i18n.tr("Add tag")
                visible: listview !== null ? listview.getSelectedIndices().length > 0 : false
                onTriggered: {
                    var items = []
                    var indicies = listview.getSelectedIndices()

                    listview.clearSelection()

                    for (var i = 0; i < indicies.length; i++) {
                        items.push(listview.model.get(indicies[i], listview.model.RoleModelData).item_id)
                    }

                    isArticleOpen = true
                    pageLayout.addPageToNextColumn(pageIdObject, itemTagsPage, {"items_ids":items})
                    itemTagsPage.home()

                    listview.closeSelection()
                }
            },
            Action {
                iconName: "starred"
                text: i18n.tr("Favorite")
                visible: listview !== null ? listview.getSelectedIndices().length > 0 : false
                onTriggered: {
                    var items = []
                    var favs = []
                    var indicies = listview.getSelectedIndices()

                    listview.clearSelection()

                    for (var i = 0; i < indicies.length; i++) {
                        items.push(listview.model.get(indicies[i], listview.model.RoleModelData).item_id)
                        if (listview.model.get(indicies[i], listview.model.RoleModelData).favorite == 1) {
                            favs.push(listview.model.get(indicies[i], listview.model.RoleModelData).favorite == 1)
                        }
                    }

                    if (items.length == favs.length) {
                        Scripts.fav_item(items, 0, pageId)
                    } else {
                        Scripts.fav_item(items, 1, pageId)
                    }

                    listview.closeSelection()
                }
            },
            Action {
                iconName: itemstype == "archive" ? "add" : "tick"
                text: itemstype == "archive" ? i18n.tr("Re-add") : i18n.tr("Archive")
                visible: listview !== null ? listview.getSelectedIndices().length > 0 : false
                onTriggered: {
                    var items = []
                    var indicies = listview.getSelectedIndices()

                    listview.clearSelection()

                    for (var i = 0; i < indicies.length; i++) {
                        items.push(listview.model.get(indicies[i], listview.model.RoleModelData).item_id)
                    }

                    Scripts.archive_item(items, itemstype == "archive" ? 0 : 1, pageId)

                    listview.closeSelection()
                }
            },
            Action {
                iconName: "select"
                text: i18n.tr("Select All")
                onTriggered: {
                    if (listview.getSelectedIndices().length === listview.model.count) {
                        listview.clearSelection()
                    } else {
                        listview.selectAll()
                    }
                }
            }
        ]
    }
}
