import QtQuick 2.12
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog {
    id: dialog

    Connections {
        target: mainView
        onEntryworksfinished: {
            if (finished) {
                PopupUtils.close(dialog)
            }
        }
    }

    property string spinner_text: ""

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
                text: spinner_text
                anchors.verticalCenter: parent.verticalCenter
                fontSize: "large"
                color: "#999999"
            }
        }
    }
}
