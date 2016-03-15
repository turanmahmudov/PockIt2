import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.LocalStorage 2.0
import "../js/localdb.js" as LocalDb
import "../js/user.js" as User
import "../js/scripts.js" as Scripts

Dialog {
    id: infoDialog

    property string name: ""
    property string description: ""

    title: i18n.tr(name)

    Label {
        width: parent.width
        text: i18n.tr(description)
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button {
        text: i18n.tr("Close")
        color: UbuntuColors.coolGrey
        onClicked: PopupUtils.close(infoDialog)
    }
}
