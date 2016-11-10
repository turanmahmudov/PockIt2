import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem

Page {
    id: creditsPage

    header: PageHeader {
        title: i18n.tr("Credits")

        leadingActionBar {
            actions: [
                Action {
                    id: closePageAction
                    text: i18n.tr("Close")
                    iconName: "back"
                    onTriggered: {
                        isArticleOpen = false
                        pageLayout.removePages(creditsPage)
                    }
                }

            ]
        }
    }

    Flickable {
        id: flickable
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: creditsPage.header.bottom
            topMargin: units.gu(1)
        }
        contentHeight: columnSuperior.height

        Column {
           id: columnSuperior
           width: parent.width

           ListItem.Header {
               text: i18n.tr("Creator")
           }

           ListItem.Base {
               width: parent.width
               progression: true
               showDivider: false
               onClicked: {
                   Qt.openUrlExternally("mailto:turan.mahmudov@gmail.com")
               }
               Column {
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.right: parent.right
                   anchors.left: parent.left
                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       text: "Turan Mahmudov"
                   }

                   Label {
                       fontSize: "small"
                       width: parent.width
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: "turan.mahmudov@gmail.com"
                   }
               }
           }

           ListItem.Header {
               text: i18n.tr("Developers")
           }

           ListItem.Base {
               width: parent.width
               progression: true
               showDivider: false
               onClicked: {
                   Qt.openUrlExternally("mailto:turan.mahmudov@gmail.com")
               }
               Column {
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.right: parent.right
                   anchors.left: parent.left
                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       text: "Turan Mahmudov"
                   }

                   Label {
                       fontSize: "small"
                       width: parent.width
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: "turan.mahmudov@gmail.com"
                   }
               }
           }

           ListItem.Header {
               text: i18n.tr("Icons")
           }

           ListItem.Base {
               width: parent.width
               progression: true
               showDivider: false
               onClicked: {
                   Qt.openUrlExternally("mailto:snwh@ubuntu.com")
               }
               Column {
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.right: parent.right
                   anchors.left: parent.left
                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       text: "Sam Hewitt"
                   }

                   Label {
                       fontSize: "small"
                       width: parent.width
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: "snwh@ubuntu.com"
                   }
               }
           }

           ListItem.Header {
               text: i18n.tr("Translators")
           }

           ListItem.Base {
               width: parent.width
               progression: true
               showDivider: false
               onClicked: {
                   Qt.openUrlExternally("https://github.com/FaraoneLele")
               }
               Column {
                   anchors.verticalCenter: parent.verticalCenter
                   anchors.right: parent.right
                   anchors.left: parent.left
                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       text: "Emanuele Antonio Faraone"
                   }

                   Label {
                       fontSize: "small"
                       width: parent.width
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: "https://github.com/FaraoneLele"
                   }
               }
           }
        }
    }
}
