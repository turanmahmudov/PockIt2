import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog {
    id: dialog

    Connections {
        target: mainView
        onItemaddingfinished: {
            PopupUtils.close(dialog)
        }
    }

    property string adding_text: ""

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: units.gu(2)

        Row {
            spacing: units.gu(1)
            anchors.horizontalCenter: parent.horizontalCenter

            ActivityIndicator {
                anchors.verticalCenter: parent.verticalCenter
                running: true
                z: 1
            }
            Label {
                text: adding_text
                anchors.verticalCenter: parent.verticalCenter
                fontSize: "large"
                color: "#999999"
            }
        }
    }
}
