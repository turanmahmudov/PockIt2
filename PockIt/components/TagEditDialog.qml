import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.LocalStorage 2.0
import "../js/localdb.js" as LocalDb
import "../js/user.js" as User
import "../js/scripts.js" as Scripts

Dialog {
    id: tagEditDialog

    title: i18n.tr("Rename Tag")

    property string oldTag: ""

    Column {
        id: column
        spacing: units.gu(1)

        Label {
            width: parent.width
            text: i18n.tr("Enter a new name for this tag")
            anchors.horizontalCenter: parent.horizontalCenter
        }

        TextField {
            id: tagNewName
            text: oldTag
            hasClearButton: true
            inputMethodHints: Qt.ImhNoPredictiveText
            width: parent.width
        }

        Row {
            id: row
            width: parent.width
            spacing: units.gu(1)

            Button {
                width: (parent.width/2)-units.gu(1)
                text: i18n.tr("Cancel")
                color: UbuntuColors.coolGrey
                onClicked: PopupUtils.close(tagEditDialog)
            }

            Button {
                width: (parent.width/2)-units.gu(1)
                text: i18n.tr("Save")
                color: UbuntuColors.orange
                onClicked: {
                    Scripts.rename_tag(oldTag, tagNewName.text)
                    PopupUtils.close(tagEditDialog)
                }
            }
        }
    }
}
