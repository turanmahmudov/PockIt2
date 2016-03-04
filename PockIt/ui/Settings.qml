import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.ListItems 1.3 as ListItem
import "../js/localdb.js" as LocalDb
import "../js/user.js" as User
import "../js/scripts.js" as Scripts

Page {
    id: settingsPage
    title: i18n.tr("Settings")

    Component.onCompleted: {
        settingsModel.setProperty(0, "subtitle", User.getKey('username'))
    }

    ListModel {
        id: settingsModel
        ListElement { kid: "logout"; title: "Logout"; subtitle: ""; type: "action"; role: "Account" }
        ListElement { kid: "app_rotation"; title: "App rotation"; subtitle: "Automatic orientation"; type: "check"; cchecked: true; role: "General" }
        ListElement { kid: "dark_theme"; title: "Dark theme"; subtitle: "You can also toggle this by tapping the Theme button in the Article View"; type: "check"; cchecked: false; role: "General" }
        ListElement { kid: "justified_text"; title: "Justified Text"; subtitle: "Display text in Article View with justification"; type: "check"; cchecked: false; role: "Reading" }
        ListElement { kid: "open_best_view"; title: "Open best view"; subtitle: "PockIt will automatically decide the best view (Article or Web View) to show"; type: "check"; cchecked: true; role: "Reading" }
        ListElement { kid: "auto_download"; title: "Auto sync"; subtitle: ""; type: "check"; cchecked: false; role: "Offline Reading" }
        ListElement { kid: "auto_download_articles"; title: "Auto download articles"; subtitle: ""; type: "check"; cchecked: true; role: "Offline Reading" }
        ListElement { kid: "clear_files"; title: "Clear downloaded files"; subtitle: ""; type: "action"; role: "Offline Reading" }
    }

    ListView {
        id: settingsList
        clip: true
        anchors.fill: parent
        model: settingsModel
        section.property: "role"
        section.labelPositioning: ViewSection.InlineLabels

        section.delegate: ListItem.Empty {
            showDivider: true
            height: headerText.implicitHeight + units.gu(1)
            Label {
                id: headerText
                text: i18n.tr(section)
                fontSize: 'small'
                font.bold: true
                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter;
                            leftMargin: units.gu(2); rightMargin: units.gu(1); topMargin: units.gu(0.5);
                            bottomMargin: units.gu(0.5)
                }
            }
        }

        delegate: ListItem.Empty {
            showDivider: settingsModel.get(index+1) ? (settingsModel.get(index+1).role == settingsModel.get(index).role ? true : false) : false
            height: mainColumn1.height + units.gu(3)

            onClicked: {
                if (type == 'action') {
                    switch (kid) {
                        case 'clear_files':
                            Scripts.clear_list()
                            break;

                        case 'logout':
                            Scripts.logout()
                            break;
                    }
                }
            }

            Column {
                id: mainColumn1
                width: units.gu(35)
                anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter;
                            leftMargin: units.gu(2); rightMargin: units.gu(2);
                }

                Label {
                    text: i18n.tr(title)
                    width: parent.width
                    elide: Text.ElideRight
                }

                Label {
                    id: subt
                    text: i18n.tr(subtitle)
                    linkColor: UbuntuColors.orange
                    fontSize: "small"
                    width: parent.width - units.gu(4)
                    height: subtitle == '' ? 0 : implicitHeight
                    elide: Text.ElideRight
                    textFormat: Text.RichText
                    wrapMode: Text.WordWrap
                }
            }

            CheckBox {
                anchors { right: parent.right; verticalCenter: parent.verticalCenter;
                            rightMargin: units.gu(2);
                }
                visible: type == 'check' ? true : false
                checked: type == 'check' ? (User.getKey(kid) == 'false' ? false : true) : false
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (parent.checked) {
                            parent.checked = false
                            User.setKey(kid, 'false')
                            if (kid == 'dark_theme') {
                                themeManager.currentThemeIndex = 0
                            }
                        } else {
                            parent.checked = true
                            User.setKey(kid, 'true')
                            if (kid == 'dark_theme') {
                                themeManager.currentThemeIndex = 1
                            }
                        }
                    }
                }
            }
        }
    }
}
