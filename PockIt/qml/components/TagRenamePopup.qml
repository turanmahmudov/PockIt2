import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

Dialog {
    id: dialog

    property string tagName: ""

    title: i18n.tr("Rename Tag")

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: units.gu(1)

        Label {
            width: parent.width
            text: i18n.tr("Enter a new name for this tag")
        }

        TextField {
            id: tagNewName
            text: tagName
            hasClearButton: true
            inputMethodHints: Qt.ImhNoPredictiveText
            width: parent.width
        }

        Row {
            width: parent.width
            spacing: units.gu(1)
            anchors.horizontalCenter: parent.horizontalCenter

            Button {
                width: (parent.width-units.gu(1))/2
                text: i18n.tr("Cancel")
                onClicked: PopupUtils.close(dialog)
            }

            Button {
                width: (parent.width-units.gu(1))/2
                text: i18n.tr("Save")
                color: UbuntuColors.blue
                onClicked: {
                    Scripts.rename_tag(tagName, tagNewName.text)
                    PopupUtils.close(dialog)
                }
            }
        }
    }
}
