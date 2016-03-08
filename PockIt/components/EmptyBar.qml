import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.LocalStorage 2.0
import "../js/localdb.js" as LocalDb
import "../js/user.js" as User
import "../js/scripts.js" as Scripts

Item {
    anchors.fill: parent

    property string title: ""
    property string description: ""
    property string help: ""
    property var buttons: []

    Column {
        spacing: units.gu(2)
        anchors {
            left: parent.left;
            right: parent.right;
            top: parent.top
            margins: units.gu(5)
            topMargin: units.gu(9)
        }

        Label {
            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            text: '<b>' + title + '</b>'
            fontSize: "large"
            horizontalAlignment: Text.AlignHCenter
        }

        Label {
            width: parent.width
            text: description
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Label {
            width: parent.width
            text: help
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
        }

        Column {
            width: parent.width - units.gu(4)
            x: units.gu(2)
            spacing: units.gu(1)
            Repeater {
                model: buttons
                Rectangle {
                    height: tag_label.height + units.gu(2)
                    width: parent.width
                    color: "#c3c3c3"
                    radius: units.gu(0.3)
                    Label {
                        anchors.centerIn: parent
                        id: tag_label
                        text: buttons[index]['name']
                        color: "#ffffff"
                        fontSize: "small"
                        font.weight: Font.DemiBold
                    }
                    Icon {
                        z: 100000000000
                        height: tag_label.height + units.gu(1)
                        width: height
                        anchors.right: parent.right
                        anchors.rightMargin: units.gu(1)
                        anchors.verticalCenter: parent.verticalCenter
                        name: "info"
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                PopupUtils.open(infoDialog, mainView, {"name":buttons[index]['name'], "description":buttons[index]['description']})
                            }
                        }
                    }

                    MouseArea {
                        width: parent.width
                        height: parent.height
                        onClicked: {
                            if (buttons[index]['kid'] == "sync_all") {
                                User.setKey('auto_download_articles', 'true');
                                myListPage.home(false, false, true)
                            } else if (buttons[index]['kid'] == "sync_without_articles") {
                                User.setKey('auto_download_articles', 'false');
                                myListPage.home(false, false, true)
                            }
                        }
                    }
                }
            }
        }
    }
}
