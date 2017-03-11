import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3
import Ubuntu.Content 1.1
import Ubuntu.Components.Popups 1.3

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

ListItem {
    id: itemListDelegate
    height: layout.height + divider.height

    property var pageId
    property string pageIdString

    property var removalAnimation

    leadingActions: ListItemActions {
        actions: [
            Action {
                iconName: "delete"
                text: i18n.tr("Remove")
                onTriggered: {
                    removalAnimation.start()
                    Scripts.delete_item([item_id], pageId)
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
                iconName: "share"
                text: i18n.tr("Share")
                onTriggered: {
                    PopupUtils.open(shareDialog, mainView, {"contentType": ContentType.Links, "path": resolved_url});
                }
            },
            Action {
                iconName: status == 1 ? "add" : "tick"
                text: status == 1 ? i18n.tr("Re-add") : i18n.tr("Archive")
                onTriggered: {
                    removalAnimation.start()
                    Scripts.archive_item([item_id], status == 1 ? 0 : 1, pageIdString)
                }
            },
            Action {
                iconName: "starred"
                text: favorite == 1 ? i18n.tr("Unfavorite") : i18n.tr("Favorite")
                property var iconColor: favorite == 1 ? UbuntuColors.blue : darkTheme ? UbuntuColors.lightGrey : UbuntuColors.darkGrey
                property var is_fav: favorite == 1 ? 1 : 0
                onTriggered: {
                    if (pageIdString == "favoritesPage") {
                        removalAnimation.start()
                    }
                    if (is_fav === 1) {
                        iconColor = darkTheme ? UbuntuColors.lightGrey : UbuntuColors.darkGrey
                        Scripts.fav_item([item_id], 0, pageIdString)
                        is_fav = 0
                        favRect.is_fav = 0
                    } else {
                        iconColor = UbuntuColors.blue
                        Scripts.fav_item([item_id], 1, pageIdString)
                        is_fav = 1
                        favRect.is_fav = 1
                    }
                }
            },
            Action {
                iconName: "tag"
                text: i18n.tr("Tags")
                onTriggered: {
                    isArticleOpen = true
                    pageLayout.addPageToNextColumn(pageId, itemTagsPage, {"items_ids":[item_id]})
                    itemTagsPage.home()
                }
            }
        ]
    }

    removalAnimation: SequentialAnimation {
        alwaysRunToEnd: true

        PropertyAction {
            target: itemListDelegate
            property: "ListView.delayRemove"
            value: true
        }

        UbuntuNumberAnimation {
            target: itemListDelegate
            property: "height"
            to: 0
        }

        PropertyAction {
            target: itemListDelegate
            property: "ListView.delayRemove"
            value: false
        }
    }

    Item {
        id: favRect
        property var is_fav: favorite == 1 ? 1 : 0
        width: is_fav === 1 ? units.gu(5) : 0
        height: width
        visible: is_fav === 1

        Rectangle {
            id: categoryColorRec
            width: units.gu(6)
            height: width
            transform: Rotation {
                origin.x: categoryColorRec.width
                origin.y: categoryColorRec.height
                angle: 45
            }
            anchors{
                verticalCenter: parent.top
                right: parent.left
            }
            color: UbuntuColors.blue
        }

        Icon {
            width: units.gu(1.2)
            height: width
            anchors {
                left: parent.left
                leftMargin: units.gu(0.3)
                top: parent.top
                topMargin: units.gu(0.3)
            }
            name: "starred"
            color: "#ffffff"
        }
    }

    SlotsLayout {
        id: layout
        mainSlot: Column {
            id: mainSlot
            spacing: units.gu(1)

            Label {
                id: title
                text: resolved_title
                font.weight: Font.Normal
                maximumLineCount: 3
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Label {
                id: subtitle
                text: only_domain
                fontSize: "small"
                color: theme.palette.normal.backgroundSecondaryText
                maximumLineCount: 2
                wrapMode: Text.WordWrap
                width: parent.width
            }

            RowLayout {
                width: parent.width
                Flow {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: units.gu(0.5)
                    Repeater {
                        model: tags
                        Rectangle {
                            height: tag_label.height + units.gu(0.5)
                            width: tag_label.width + units.gu(1.5)
                            color: theme.palette.normal.base
                            radius: units.gu(0.3)
                            Label {
                                anchors.centerIn: parent
                                id: tag_label
                                text: tag
                                color: "#ffffff"
                                fontSize: "x-small"
                                font.weight: Font.DemiBold
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            SlotsLayout.position: SlotsLayout.Trailing
            SlotsLayout.overrideVerticalPositioning: true
            SlotsLayout.padding.trailing: units.gu(-1)

            width: image ? units.gu(10) : 0
            height: parent.height
            color: "#dfdfdf"
            Image {
                width: parent.width
                height: parent.height
                source: image ? image : ""
                clip: true
                asynchronous: true
                cache: true // maybe false
                sourceSize: Qt.size(width, height)
                fillMode: Image.PreserveAspectCrop
            }
            Image {
                anchors {
                    centerIn: parent
                }
                visible: has_video == true ? true : false
                width: parent.width/2
                height: width
                source: "../images/play.png"

            }
        }
    }

    onClicked: {
        if (selectMode) {
            selected = !selected;
        } else {
            isArticleOpen = true
            articleViewPage.item_id = item_id
            articleViewPage.resolved_url = resolved_url
            articleViewPage.home()
            pageLayout.addPageToNextColumn(pageId, articleViewPage)
        }
    }
    onPressAndHold: {
        ListView.view.ViewItems.selectMode = !ListView.view.ViewItems.selectMode
    }
}
