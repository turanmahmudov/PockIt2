import QtQuick 2.4
import Ubuntu.Components 1.3

Column {
    width: parent.width

    Rectangle {
        width: parent.width
        height: units.gu(5)
        color: theme.palette.normal.foreground

        ActivityIndicator {
            id: syncingIndicator
            anchors.left: parent.left
            anchors.leftMargin: units.gu(1)
            anchors.verticalCenter: parent.verticalCenter
            running: true
        }

        Label {
            id: syncingLabel
            anchors.left: syncingIndicator.right
            anchors.leftMargin: units.gu(1)
            anchors.verticalCenter: parent.verticalCenter
            text: syncing && syncing_stopped ? i18n.tr("Stopping download...") : i18n.tr("Downloading Items... Tap to cancel download.")
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                syncing_stopped = true
            }
        }
    }
}
