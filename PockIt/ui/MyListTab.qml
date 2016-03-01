import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Styles 1.3
import Ubuntu.Content 1.1
import Ubuntu.Components.Popups 1.3
import Ubuntu.Connectivity 1.0
import "../components"
import "../js/localdb.js" as LocalDb
import "../js/user.js" as User
import "../js/scripts.js" as Scripts

Page {
    id: pocketHome
    header: PageHeader {
        title: i18n.tr("PockIt")
        StyleHints {
            backgroundColor: currentTheme.backgroundColor
            foregroundColor: currentTheme.baseFontColor
        }
        leadingActionBar {
            actions: [
                Action {
                    text: i18n.tr("My List")
                    iconName: "view-list-symbolic"
                    onTriggered: {
                        tabs.selectedTabIndex = 0
                    }
                },
                Action {
                    text: i18n.tr("Favorites")
                    iconName: "starred"
                    onTriggered: {
                        tabs.selectedTabIndex = 1
                    }
                },
                Action {
                    text: i18n.tr("Archive")
                    iconName: "tick"
                    onTriggered: {
                        tabs.selectedTabIndex = 2
                    }
                }
            ]
        }
        trailingActionBar {
            numberOfSlots: 2
            actions: [searchAction, settingsAction, refreshAction, aboutAction]
        }
        extension: Sections {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
            }
            actions: [
                Action {
                    text: i18n.tr("My List")
                    onTriggered: {
                        Scripts.my_list(0, 0, 0)
                        viewLoader.sourceComponent = myListComponent
                    }
                },
                Action {
                    text: i18n.tr("Articles")
                    onTriggered: {
                        Scripts.my_list(1, 0, 0)
                        viewLoader.sourceComponent = myListComponent
                    }
                },
                Action {
                    text: i18n.tr("Videos")
                    onTriggered: {
                        Scripts.my_list(0, 0, 1)
                        viewLoader.sourceComponent = myListComponent
                    }
                },
                Action {
                    text: i18n.tr("Images")
                    onTriggered: {
                        Scripts.my_list(0, 1, 0)
                        viewLoader.sourceComponent = myListComponent
                    }
                }
            ]
        }
    }

    function get_list() {
        Scripts.get_list()
    }

    function home(dont_get_list) {
        // Offline articles
        Scripts.my_list(0, 0, 0)
        if (dont_get_list == true) {
            // Sync
            if (User.getKey('auto_download') == 'true') {
                Scripts.get_list()
            }
        }
    }

    Component.onCompleted: {
        home()
    }

    //property bool finished: true
    property bool empty: false

    BouncingProgressBar {
        id: bouncingProgress
        z: 9
        anchors.top: pocketHome.header.bottom
        visible: finished == false
    }

    EmptyBar {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: pocketHome.header.bottom
            topMargin: units.gu(5)
        }
        visible: empty == true

        title: i18n.tr("Your list is empty")
        description: ''
        help: ''
    }

    ListModel {
        id: homeModel
    }

    Loader {
        id: viewLoader
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: bouncingProgress.bottom
        }
        sourceComponent: myListComponent
    }

    Component {
        id: myListComponent

        ListView {
            id: myList
            anchors.fill: parent
            clip: true
            model: homeModel
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
                    delegate: Item {
                        width: units.gu(6)
                        Icon {
                            name: action.iconName
                            width: units.gu(2)
                            height: width
                            color: action.iconColor ? action.iconColor : UbuntuColors.lightGrey
                            anchors.centerIn: parent
                        }
                    }
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
                                archiveListPage.home()
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
                                } else {
                                    Scripts.fav_item(item_id, 1)
                                    iconColor = "orange"
                                }
                                favListPage.home()
                                myListPage.home(true)
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
                        Scripts.parseArticleView(resolved_url, item_id);
                        pageStack.push(articleView);
                    }
                }
            }
        }
    }
}
