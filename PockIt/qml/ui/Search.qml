import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: settingsPage

    header: PageHeader {
        title: i18n.tr("Search")

        contents: TextField {
            id: searchField
            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
            }
            primaryItem: Icon {
                anchors.leftMargin: units.gu(0.2)
                height: parent.height*0.5
                width: height
                name: "find"
            }
            hasClearButton: true
            inputMethodHints: Qt.ImhNoPredictiveText
            placeholderText: i18n.tr("Search by Title or URL")
            onVisibleChanged: {
                if (visible) {
                    forceActiveFocus()
                }
            }
            onTextChanged: {

            }
        }
    }
}
