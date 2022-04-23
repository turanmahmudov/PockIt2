import QtQuick 2.12
import Ubuntu.Components 1.3

Page {
    id: aboutPage

    header: PageHeader {
        title: i18n.tr("About")

        leadingActionBar {
            actions: [
                Action {
                    id: closePageAction
                    text: i18n.tr("Close")
                    iconName: "back"
                    onTriggered: {
                        isArticleOpen = false
                        pageLayout.removePages(aboutPage)
                    }
                }

            ]
        }
    }

    Flickable {
        id: flickable
        anchors {
            margins: units.gu(2)
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: aboutPage.header.bottom
            topMargin: units.gu(5)
        }
        contentHeight: columnSuperior.height

        Column {
           id: columnSuperior
           width: parent.width
           spacing: units.gu(4)

           UbuntuShape {
               anchors.horizontalCenter: parent.horizontalCenter
               width: units.gu(16)
               height: units.gu(16)
               radius: "medium"
               source: Image {
                   source: Qt.resolvedUrl("../../PockIt.png")
               }
           }

           Column {
               width: parent.width
               spacing: units.gu(0.5)

               Label {
                   width: parent.width
                   anchors.horizontalCenter: parent.horizontalCenter
                   text: "<b>PockIt</b> " + appVersion
                   fontSize: "large"
                   horizontalAlignment: Text.AlignHCenter
               }

               Label {
                   width: parent.width
                   text: i18n.tr("Unofficial Pocket Client")
                   horizontalAlignment: Text.AlignHCenter
                   wrapMode: Text.WordWrap
               }
           }

           Column {
               width: parent.width

               Label {
                   text: "(C) 2016 Turan Mahmudov"
                   width: parent.width
                   wrapMode: Text.WordWrap
                   horizontalAlignment: Text.AlignHCenter
                   fontSize: "small"
               }

               Label {
                   text: "<a href=\"mailto://turan.mahmudov@gmail.com\">turan.mahmudov@gmail.com</a>"
                   width: parent.width
                   wrapMode: Text.WordWrap
                   horizontalAlignment: Text.AlignHCenter
                   linkColor: UbuntuColors.blue
                   fontSize: "small"
                   onLinkActivated: Qt.openUrlExternally(link)
               }

               Label {
                   text: i18n.tr("Released under the terms of the GNU GPL v3")
                   width: parent.width
                   wrapMode: Text.WordWrap
                   horizontalAlignment: Text.AlignHCenter
                   fontSize: "small"
               }
           }

           Label {
               text: i18n.tr("Source code available on %1").arg("<a href=\"https://github.com/turanmahmudov/PockIt2\">Github</a>")
               width: parent.width
               wrapMode: Text.WordWrap
               horizontalAlignment: Text.AlignHCenter
               linkColor: UbuntuColors.blue
               fontSize: "small"
               onLinkActivated: Qt.openUrlExternally(link)
           }

           /*Column {
               width: parent.width
               spacing: units.gu(1)

               Item {
                   width: parent.width
                   height: units.gu(1)
               }

               Button {
                   anchors {
                       horizontalCenter: parent.horizontalCenter
                   }
                   text: i18n.tr("Donate")
                   color: UbuntuColors.green
                   onTriggered: {

                   }
               }
           }*/
        }
    }
}
