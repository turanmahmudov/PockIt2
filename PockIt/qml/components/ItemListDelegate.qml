import QtQuick 2.4
import Ubuntu.Components 1.3

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
                color: action.iconColor ? action.iconColor : settings.darkTheme ? UbuntuColors.lightGrey : UbuntuColors.darkGrey
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
                property var iconColor: favorite == 1 ? UbuntuColors.blue : settings.darkTheme ? UbuntuColors.lightGrey : UbuntuColors.darkGrey
                property var is_fav: favorite == 1 ? 1 : 0
                onTriggered: {
                    if (is_fav === 1) {
                        iconColor = settings.darkTheme ? UbuntuColors.lightGrey : UbuntuColors.darkGrey
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

    ListItemLayout {
        id: layout

        title.text: resolved_title
        title.maximumLineCount: 3
        title.wrapMode: Text.WordWrap

        subtitle.text: only_domain
        subtitle.maximumLineCount: 2
        subtitle.wrapMode: Text.WordWrap

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
                source: image
                clip: true
                cache: true
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
            pageLayout.addPageToNextColumn(pageId, Qt.resolvedUrl("../ui/ArticleViewPage.qml"), {"resolved_url":resolved_url, "item_id":item_id})
        }
    }
    onPressAndHold: {
        ListView.view.ViewItems.selectMode = !ListView.view.ViewItems.selectMode
    }
}
