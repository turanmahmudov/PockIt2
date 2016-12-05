import QtQuick 2.4
import Ubuntu.Components 1.3

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
                onTriggered: {

                }
            },
            Action {
                iconName: "tag"
                text: i18n.tr("Add tag")
                onTriggered: {

                }
            },
            Action {
                iconName: "starred"
                text: i18n.tr("Favorite")
                onTriggered: {

                }
            },
            Action {
                iconName: "tick"
                text: i18n.tr("Archive")
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
