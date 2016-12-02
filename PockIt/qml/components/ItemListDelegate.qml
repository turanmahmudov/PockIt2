import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Ubuntu.Connectivity 1.0

ListItem {
    id: itemListDelegate
    height: layout.height + divider.height

    property var pageId

    property var removalAnimation

    leadingActions: ListItemActions {
        actions: [
            Action {
                iconName: "delete"
                text: i18n.tr("Remove")
                onTriggered: {
                    removalAnimation.start()
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

                }
            },
            Action {
                iconName: "tick"
                text: i18n.tr("Archive")
                onTriggered: {

                }
            },
            Action {
                iconName: "tag"
                text: i18n.tr("Tags")
                onTriggered: {

                }
            },
            Action {
                iconName: "starred"
                text: i18n.tr("Favorite")
                property var iconColor: favorite == 1 ? UbuntuColors.blue : darkTheme ? UbuntuColors.lightGrey : UbuntuColors.darkGrey
                property var is_fav: favorite == 1 ? 1 : 0
                onTriggered: {
                    if (is_fav === 1) {
                        iconColor = darkTheme ? UbuntuColors.lightGrey : UbuntuColors.darkGrey
                    } else {
                        iconColor = UbuntuColors.blue
                    }
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

    SlotsLayout {
        id: layout
        mainSlot: Column {
            id: mainSlot
            spacing: units.gu(1)

            Label {
                id: title
                text: resolved_title
                fontSize: "medium"
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
            visible: Connectivity.online
            SlotsLayout.position: SlotsLayout.Trailing
            SlotsLayout.overrideVerticalPositioning: true
            SlotsLayout.padding.trailing: units.gu(-1)

            width: Connectivity.online ? (image ? units.gu(10) : 0) : 0
            height: parent.height
            color: "#dfdfdf"
            Image {
                width: parent.width
                height: parent.height
                source: Connectivity.online ? (image ? image : "") : ""
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
