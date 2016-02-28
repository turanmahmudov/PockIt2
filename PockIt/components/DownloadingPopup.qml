import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Dialog {
    id: downloadDialog

    title: i18n.tr("Syncing")

    Column {
        id: column
        spacing: units.gu(1)

        ProgressBar {
            anchors.horizontalCenter: parent.horizontalCenter
            width: units.gu(30)
            maximumValue: 100
            minimumValue: 0
            value: Math.round((downloaded*100)/totaldownloads)
            onValueChanged: {
                if (value == 100) {
                    PopupUtils.close(downloadDialog)
                }
            }
        }
    }
}
