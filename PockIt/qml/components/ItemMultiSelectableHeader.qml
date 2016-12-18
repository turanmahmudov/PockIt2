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
                        listview.model.remove(indicies[i]-i, 1)
                    }

                    Scripts.delete_item(items)
                }
            },
            Action {
                iconName: "tag"
                text: i18n.tr("Add tag")
                visible: listview !== null ? listview.getSelectedIndices().length > 0 : false
                onTriggered: {

                }
            },
            Action {
                iconName: "starred"
                text: i18n.tr("Favorite")
                visible: listview !== null ? listview.getSelectedIndices().length > 0 : false
                onTriggered: {
                    var items = []
                    var indicies = listview.getSelectedIndices()

                    for (var i = 0; i < indicies.length; i++) {
                        items.push(listview.model.get(indicies[i], listview.model.RoleModelData).item_id)
                    }
                }
            },
            Action {
                iconName: "tick"
                text: i18n.tr("Archive")
                visible: listview !== null ? listview.getSelectedIndices().length > 0 : false
                onTriggered: {

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
