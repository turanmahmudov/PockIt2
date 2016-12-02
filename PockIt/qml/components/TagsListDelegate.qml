import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3
import QtQuick.Layouts 1.1
import Ubuntu.Components.Popups 1.3

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

ListItem {
    id: tagsListDelegate
    height: layout.height + divider.height

    property var pageId

    property var removalAnimation

    leadingActions: ListItemActions {
        actions: [
            Action {
                enabled: item_id != "0"
                iconName: "delete"
                text: i18n.tr("Remove")
                onTriggered: {
                    removalAnimation.start()
                    Scripts.delete_tag(tag)
                }
            }
        ]
    }
    trailingActions: ListItemActions {
        delegate: Item {
            width: units.gu(6)
            Icon {
                name: action.iconName
                width: units.gu(2)
                height: width
                color: action.iconColor ? action.iconColor : darkTheme ? UbuntuColors.lightGrey : UbuntuColors.darkGrey
                anchors.centerIn: parent
            }
        }
        actions: [
            Action {
                enabled: item_id != "0"
                iconName: "compose"
                text: i18n.tr("Edit")
                onTriggered: {
                    PopupUtils.open(tagRenamePopupComponent, mainView, {"tagName": tag})
                }
            }
        ]
    }

    removalAnimation: SequentialAnimation {
        alwaysRunToEnd: true

        PropertyAction {
            target: tagsListDelegate
            property: "ListView.delayRemove"
            value: true
        }

        UbuntuNumberAnimation {
            target: tagsListDelegate
            property: "height"
            to: 0
        }

        PropertyAction {
            target: tagsListDelegate
            property: "ListView.delayRemove"
            value: false
        }
    }

    SlotsLayout {
        id: layout
        mainSlot: Column {
            id: mainSlot
            spacing: units.gu(1)

            Label {
                id: title
                text: item_id == "0" ? i18n.tr("All Untagged Items") : tag
                fontSize: "medium"
                maximumLineCount: 3
                wrapMode: Text.WordWrap
                width: parent.width
            }
        }
    }

    onClicked: {
        isTagOpen = true
        isArticleOpen = false
        tagEntriesPage.tag = tag
        tagEntriesPage.home()
        pageLayout.addPageToNextColumn(pageId, tagEntriesPage)
    }
}
