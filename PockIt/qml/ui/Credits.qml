import QtQuick 2.4
import Ubuntu.Components 1.3

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
        }
        contentHeight: columnSuperior.height

        Column {
           id: columnSuperior
           width: parent.width

           ListItem {
               height: head1.height

               ListItemLayout {
                   id: head1

                   title.text: i18n.tr("Creator")
                   title.font.weight: Text.Normal
               }
           }

           ListItem {
               height: dev1.height
               divider.visible: false
               ListItemLayout {
                   id: dev1

                   title.text: "Turan Mahmudov"
                   subtitle.text: "turan.mahmudov@gmail.com"
                   subtitle.maximumLineCount: 2
                   subtitle.wrapMode: Text.WordWrap
               }

               onClicked: {
                   Qt.openUrlExternally("mailto:turan.mahmudov@gmail.com")
               }
           }

           ListItem {
               height: head2.height

               ListItemLayout {
                   id: head2

                   title.text: i18n.tr("Developers")
                   title.font.weight: Text.Normal
               }
           }

           ListItem {
               height: dev2.height
               divider.visible: false
               ListItemLayout {
                   id: dev2

                   title.text: "Turan Mahmudov"
                   subtitle.text: "turan.mahmudov@gmail.com"
                   subtitle.maximumLineCount: 2
                   subtitle.wrapMode: Text.WordWrap
               }

               onClicked: {
                   Qt.openUrlExternally("mailto:turan.mahmudov@gmail.com")
               }
           }

           ListItem {
               height: head3.height

               ListItemLayout {
                   id: head3

                   title.text: i18n.tr("Icons")
                   title.font.weight: Text.Normal
               }
           }

           ListItem {
               height: dev3.height
               divider.visible: false
               ListItemLayout {
                   id: dev3

                   title.text: "Sam Hewitt"
                   subtitle.text: "snwh@ubuntu.com"
                   subtitle.maximumLineCount: 2
                   subtitle.wrapMode: Text.WordWrap
               }

               onClicked: {
                   Qt.openUrlExternally("mailto:snwh@ubuntu.com")
               }
           }

           ListItem {
               height: head4.height

               ListItemLayout {
                   id: head4

                   title.text: i18n.tr("Translators")
                   title.font.weight: Text.Normal
               }
           }

           ListItem {
               height: dev4.height
               divider.visible: false
               ListItemLayout {
                   id: dev4

                   title.text: "Emanuele Antonio Faraone"
                   subtitle.text: "https://github.com/FaraoneLele"
                   subtitle.maximumLineCount: 2
                   subtitle.wrapMode: Text.WordWrap
               }

               onClicked: {
                   Qt.openUrlExternally("https://github.com/FaraoneLele")
               }
           }
        }
    }
}
