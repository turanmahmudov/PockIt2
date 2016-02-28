import QtQuick 2.4
import Ubuntu.Components 1.3

Item {
    anchors.fill: parent

    property string title: ""
    property string description: ""
    property string help: ""

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
    }
}
