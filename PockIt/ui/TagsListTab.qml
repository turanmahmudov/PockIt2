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
    id: pocketTags
    header: PageHeader {
        title: i18n.tr("Tags")
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
                },
                Action {
                    text: i18n.tr("Tags")
                    iconName: "tag"
                    onTriggered: {
                        tabs.selectedTabIndex = 3
                    }
                }
            ]
        }
        trailingActionBar {
            numberOfSlots: 2
            actions: [searchAction, settingsAction, refreshAction, aboutAction]
        }
    }

    function home() {
        Scripts.tags_list()
    }

    Component.onCompleted: {
        home()
    }

    //property bool finished: true
    property bool empty: false

    BouncingProgressBar {
        id: bouncingProgress
        z: 9
        anchors.top: pocketTags.header.bottom
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

        title: i18n.tr("Tags Empty")
        description: ""
        help: ""
    }

    ListModel {
        id: tagsModel
    }

    Loader {
        id: viewLoader
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: bouncingProgress.bottom
        }
        sourceComponent: tagsListComponent
    }

    Component {
        id: tagsListComponent

        ListView {
            id: tagsList
            anchors.fill: parent
            clip: true
            model: tagsModel
            delegate: ListItem {
                id: tagListDelegate
                divider.visible: true
                height: entry_row.height

                property var removalAnimation

                leadingActions: ListItemActions {
                    actions: [
                        Action {
                            enabled: Connectivity.online && item_id != "0"
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
                    actions: [
                        Action {
                            enabled: Connectivity.online && item_id != "0"
                            iconName: "compose"
                            text: i18n.tr("Edit")
                            onTriggered: {
                                PopupUtils.open(tagEditDialog, mainView, {"oldTag":tag})
                            }
                        }
                    ]
                }

                removalAnimation: SequentialAnimation {
                    alwaysRunToEnd: true

                    PropertyAction {
                        target: tagListDelegate
                        property: "ListView.delayRemove"
                        value: true
                    }

                    UbuntuNumberAnimation {
                        target: tagListDelegate
                        property: "height"
                        to: 0
                    }

                    PropertyAction {
                        target: tagListDelegate
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
                        width: parent.width

                        Label {
                            id: entry_title
                            x: units.gu(2)
                            width: parent.width
                            text: item_id == "0" ? i18n.tr("All Untagged Items") : tag
                            fontSize: "medium"
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        tagEntriesPage.reqtag = tag
                        if (tag == "0") {
                            tagEntries.header.title = i18n.tr("All Untagged Items")
                        } else {
                            tagEntries.header.title = tag
                        }
                        pageStack.push(tagEntries)
                        tagEntriesPage.home()
                    }
                }
            }
        }
    }
}
