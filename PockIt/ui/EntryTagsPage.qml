import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Styles 1.3
import Ubuntu.Content 1.1
import Ubuntu.Components.Popups 1.3
import Ubuntu.Connectivity 1.0
import Ubuntu.Components.ListItems 1.3 as ListItem
import "../components"
import "../js/localdb.js" as LocalDb
import "../js/user.js" as User
import "../js/scripts.js" as Scripts

Item {
    id: pocketEntryTags

    function home() {
        Scripts.entry_tags_list(entry_id)
    }

    function save() {
        Scripts.save_tags(entry_id)
    }

    Component.onCompleted: {
        home()
    }

    property string entry_id: ""

    ListModel {
        id: tagsModel
    }

    ListModel {
        id: entry_tagsModel
    }

    Flow {
        id: etags
        width: parent.width
        anchors {
            top: parent.top
            topMargin: units.gu(1)
            left: parent.left
            leftMargin: units.gu(2)
            right: parent.right
            rightMargin: units.gu(2)
        }
        spacing: units.gu(0.5)
        Repeater {
            model: entry_tagsModel
            Rectangle {
                height: tag_label.height + units.gu(1)
                width: tag_label.width + units.gu(2.5)
                color: "#c3c3c3"
                radius: units.gu(0.3)
                Label {
                    anchors.centerIn: parent
                    id: tag_label
                    text: tag
                    color: "#ffffff"
                    fontSize: "small"
                    font.weight: Font.DemiBold
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        tagsModel.append({"tag":tag})
                        entry_tagsModel.remove(index)
                    }
                }
            }
        }
    }

    TextField {
        id: searchTag
        width: parent.width
        anchors {
            top: etags.bottom
            topMargin: units.gu(1)
            left: parent.left
            leftMargin: units.gu(2)
            right: parent.right
            rightMargin: units.gu(2)
        }
        placeholderText: i18n.tr("Select or enter a tag...")
        onAccepted: {
            for(var i = 0; i < tagsModel.count; i++) {
                if (text == tagsModel.get(i).tag) {
                    tagsModel.remove(i)
                }
            }
            entry_tagsModel.append({"tag":text})
            searchTag.text = ''
        }
    }

    ListItem.Header {
        id: tagsListHeader
        anchors {
            top: searchTag.bottom
            topMargin: units.gu(1)
        }
        text: i18n.tr("Tags")
    }

    Loader {
        id: viewLoader
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: tagsListHeader.bottom
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
            delegate: ListItem.Empty {
                id: tagListDelegate
                divider.visible: true
                height: entry_row.height

                property var removalAnimation

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
                            text: tag
                            fontSize: "medium"
                            wrapMode: Text.WordWrap
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        entry_tagsModel.append({"tag":tag})
                        removalAnimation.start()
                        tagsModel.remove(index)
                    }
                }
            }
        }
    }
}
