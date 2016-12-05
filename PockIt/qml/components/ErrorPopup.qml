import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog {
    id: dialog

    property string error_text: ""
    property string error_subtitle_text: ""

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: units.gu(2)

        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: units.gu(0.5)

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: error_text
                fontSize: "large"
                color: "#999999"
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: error_subtitle_text
                fontSize: "medium"
                color: "#999999"
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: i18n.tr("Close")
            onClicked: {
                PopupUtils.close(dialog)
            }
        }
    }
}
