import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3
import Ubuntu.Content 1.1
import Ubuntu.Components.Popups 1.3
import com.canonical.Oxide 1.0 as Oxide
import Ubuntu.Connectivity 1.0
import "../components"
import "../js/localdb.js" as LocalDb
import "../js/user.js" as User
import "../js/scripts.js" as Scripts

Page {
    id: searchPage
    header: PageHeader {
        title: i18n.tr("Search")
        StyleHints {
            backgroundColor: currentTheme.backgroundColor
            foregroundColor: currentTheme.baseFontColor
        }
        contents: Rectangle {
            color: currentTheme.backgroundColor
            anchors.fill: parent
            TextField {
                id: searchField
                anchors {
                    right: parent.right
                    rightMargin: units.gu(2)
                    centerIn: parent
                }
                hasClearButton: true
                inputMethodHints: Qt.ImhNoPredictiveText
                placeholderText: i18n.tr("Search by Title or URL")
                onVisibleChanged: {
                    if (visible) {
                        forceActiveFocus()
                    }
                }
                onTextChanged: {
                    Scripts.search_offline(searchField.text)
                }
            }
        }
    }

    property bool empty: false

    BouncingProgressBar {
        id: bouncingProgress
        z: 9
        anchors.top: searchPage.header.bottom
        visible: finished == false
    }

    EmptyBar {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: bouncingProgress.bottom
        }
        visible: empty == true

        title: i18n.tr("No Results Found")
        description: i18n.tr("There were no items that matched your search.")
        help: ""
    }

    ListModel {
        id: searchModel
    }

    Loader {
        id: viewLoader
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: bouncingProgress.bottom
        }
        sourceComponent: searchListComponent
    }

    Component {
        id: searchListComponent

        ListView {
            id: myList
            anchors.fill: parent
            clip: false
            model: searchModel
            delegate: ListItem {
                id: myListDelegate
                divider.visible: true
                height: entry_row.height

                property var removalAnimation

                leadingActions: ListItemActions {
                    actions: [
                        Action {
                            enabled: Connectivity.online
                            iconName: "delete"
                            text: i18n.tr("Remove")
                            onTriggered: {
                                removalAnimation.start()
                                Scripts.delete_item(item_id)
                            }
                        }
                    ]
                }
                trailingActions: ListItemActions {
                    actions: [
                        Action {
                            enabled: Connectivity.online
                            iconName: "share"
                            text: i18n.tr("Share")
                            onTriggered: {
                                PopupUtils.open(shareDialog, pageStack, {"contentType": ContentType.Links, "path": resolved_url});
                            }
                        },
                        Action {
                            enabled: Connectivity.online
                            iconName: "tick"
                            text: i18n.tr("Archive")
                            onTriggered: {
                                removalAnimation.start()
                                Scripts.archive_item(item_id, '1')
                                // archivepage refresh list
                            }
                        },
                        Action {
                            enabled: Connectivity.online
                            iconName: "tag"
                            text: i18n.tr("Tags")
                            onTriggered: {
                                entryTagsPage.entry_id = item_id
                                entryTagsPage.home()
                                pageStack.push(entryTags)
                            }
                        },
                        Action {
                            enabled: Connectivity.online
                            iconName: "starred"
                            text: i18n.tr("Favorite")
                            property var iconColor: favorite == 1 ? "orange" : UbuntuColors.lightGrey
                            property var is_fav: favorite == 1 ? 1 : 0
                            onTriggered: {
                                if (is_fav == 1) {
                                    Scripts.fav_item(item_id, 0)
                                    iconColor = UbuntuColors.lightGrey
                                    is_fav = 0
                                } else {
                                    Scripts.fav_item(item_id, 1)
                                    iconColor = "orange"
                                    is_fav = 1
                                }
                                // favoritespage refresh list
                            }
                        }
                    ]
                }

                removalAnimation: SequentialAnimation {
                    alwaysRunToEnd: true

                    PropertyAction {
                        target: myListDelegate
                        property: "ListView.delayRemove"
                        value: true
                    }

                    UbuntuNumberAnimation {
                        target: myListDelegate
                        property: "height"
                        to: 0
                    }

                    PropertyAction {
                        target: myListDelegate
                        property: "ListView.delayRemove"
                        value: false
                    }
                }

                Row {
                    id: entry_row
                    width: parent.width
                    height: entry_column.height + units.gu(3)
                    Column {
                        id: entry_column
                        spacing: units.gu(0.5)
                        anchors.verticalCenter: parent.verticalCenter
                        width: image == '' ? parent.width : parent.width - units.gu(10)

                        Label {
                            id: entry_title
                            x: units.gu(2)
                            width: parent.width - units.gu(4)
                            text: resolved_title
                            fontSize: "medium"
                            wrapMode: Text.WordWrap
                        }

                        Label {
                            id: entry_domain
                            x: units.gu(2)
                            width: parent.width - units.gu(4)
                            text: only_domain
                            fontSize: "x-small"
                            wrapMode: Text.WordWrap
                        }
                    }

                    Rectangle {
                        id: entry_image_box
                        width: image == '' ? 0 : units.gu(10)
                        height: entry_column.height + units.gu(3)
                        color: "#dfdfdf"
                        Image {
                            id: entry_image
                            width: parent.width
                            height: parent.height
                            source: image
                            clip: true
                            cache: true
                            fillMode: Image.PreserveAspectCrop
                            smooth: true
                        }
                        Image {
                            id: videoicon
                            width: parent.width/2
                            height: width
                            visible: has_video != '0' ? true : false
                            anchors.centerIn: parent
                            source: "../img/play.png"
                            clip: true
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        pageStack.push(articleView);
                        Scripts.parseArticleView(resolved_url, item_id);
                    }
                }
            }
        }
    }
}
