import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem

Page {
    id: settingsPage

    header: PageHeader {
        title: i18n.tr("Settings")

        leadingActionBar {
            actions: [
                Action {
                    id: closePageAction
                    text: i18n.tr("Close")
                    iconName: "back"
                    onTriggered: {
                        isArticleOpen = false
                        pageLayout.removePages(settingsPage)
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
            top: settingsPage.header.bottom
            topMargin: units.gu(1)
        }
        contentHeight: columnSuperior.height

        Column {
           id: columnSuperior
           width: parent.width

           ListItem.Header {
               text: i18n.tr("Account")
           }

           ListItem.Base {
               width: parent.width
               height: logoutColumn.height + units.gu(3)
               showDivider: false
               onClicked: {

               }

               Column {
                   id: logoutColumn
                   width: parent.width
                   anchors {
                       verticalCenter: parent.verticalCenter
                   }

                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: i18n.tr("Logout")
                   }

                   Label {
                       width: parent.width
                       elide: Text.ElideRight
                       wrapMode: Text.WordWrap
                       text: "turanmahmudov"
                       fontSize: "small"
                   }
               }
           }

           ListItem.Header {
               text: i18n.tr("General")
           }

           ListItem.Base {
               width: parent.width
               height: themeRow.height + units.gu(3)
               showDivider: false
               onClicked: {

               }

               Row {
                   id: themeRow
                   width: parent.width
                   anchors {
                       verticalCenter: parent.verticalCenter
                   }
                   spacing: units.gu(1)

                   Column {
                       width: parent.width - themeSwitch.width - units.gu(1)
                       anchors {
                           verticalCenter: parent.verticalCenter
                       }

                       Label {
                           width: parent.width
                           wrapMode: Text.WordWrap
                           elide: Text.ElideRight
                           text: i18n.tr("Dark theme")
                       }

                       Label {
                           width: parent.width
                           elide: Text.ElideRight
                           wrapMode: Text.WordWrap
                           text: i18n.tr("You can also toggle this by tapping the Theme button in the Article View")
                           fontSize: "small"
                       }
                   }

                   Switch {
                       id: themeSwitch
                       anchors {
                           verticalCenter: parent.verticalCenter
                       }
                       checked: settings.darkTheme
                       onCheckedChanged: {
                            if (checked) {
                                settings.darkTheme = true
                                themeManager.currentThemeIndex = 1
                            } else {
                                settings.darkTheme = false
                                themeManager.currentThemeIndex = 0
                            }
                       }
                   }
               }
           }

           ListItem.Header {
               text: i18n.tr("Reading")
           }

           ListItem.Base {
               width: parent.width
               height: justifiedTextRow.height + units.gu(3)
               showDivider: true
               onClicked: {

               }

               Row {
                   id: justifiedTextRow
                   width: parent.width
                   anchors {
                       verticalCenter: parent.verticalCenter
                   }
                   spacing: units.gu(1)

                   Column {
                       width: parent.width - justifiedTextSwitch.width - units.gu(1)
                       anchors {
                           verticalCenter: parent.verticalCenter
                       }

                       Label {
                           width: parent.width
                           wrapMode: Text.WordWrap
                           elide: Text.ElideRight
                           text: i18n.tr("Justified Text")
                       }

                       Label {
                           width: parent.width
                           elide: Text.ElideRight
                           wrapMode: Text.WordWrap
                           text: i18n.tr("Display text in Article View with justification")
                           fontSize: "small"
                       }
                   }

                   Switch {
                       id: justifiedTextSwitch
                       anchors {
                           verticalCenter: parent.verticalCenter
                       }
                       checked: false
                       onCheckedChanged: {
                            if (checked) {

                            } else {

                            }
                       }
                   }
               }
           }

           ListItem.Base {
               width: parent.width
               height: openBestViewRow.height + units.gu(3)
               showDivider: false
               onClicked: {

               }

               Row {
                   id: openBestViewRow
                   width: parent.width
                   anchors {
                       verticalCenter: parent.verticalCenter
                   }
                   spacing: units.gu(1)

                   Column {
                       width: parent.width - openBestViewSwitch.width - units.gu(1)
                       anchors {
                           verticalCenter: parent.verticalCenter
                       }

                       Label {
                           width: parent.width
                           wrapMode: Text.WordWrap
                           elide: Text.ElideRight
                           text: i18n.tr("Open best view")
                       }

                       Label {
                           width: parent.width
                           elide: Text.ElideRight
                           wrapMode: Text.WordWrap
                           text: i18n.tr("PockIt will automatically decide the best view (Article or Web View) to show")
                           fontSize: "small"
                       }
                   }

                   Switch {
                       id: openBestViewSwitch
                       anchors {
                           verticalCenter: parent.verticalCenter
                       }
                       checked: false
                       onCheckedChanged: {
                            if (checked) {

                            } else {

                            }
                       }
                   }
               }
           }

           ListItem.Header {
               text: i18n.tr("Offline Reading & Syncing")
           }

           ListItem.Base {
               width: parent.width
               height: autoSyncRow.height + units.gu(3)
               showDivider: true
               onClicked: {

               }

               Row {
                   id: autoSyncRow
                   width: parent.width
                   anchors {
                       verticalCenter: parent.verticalCenter
                   }
                   spacing: units.gu(1)

                   Column {
                       width: parent.width - autoSyncSwitch.width - units.gu(1)
                       anchors {
                           verticalCenter: parent.verticalCenter
                       }

                       Label {
                           width: parent.width
                           wrapMode: Text.WordWrap
                           elide: Text.ElideRight
                           text: i18n.tr("Sync when app opens")
                       }

                       Label {
                           width: parent.width
                           elide: Text.ElideRight
                           wrapMode: Text.WordWrap
                           text: i18n.tr("")
                           fontSize: "small"
                       }
                   }

                   Switch {
                       id: autoSyncSwitch
                       anchors {
                           verticalCenter: parent.verticalCenter
                       }
                       checked: false
                       onCheckedChanged: {
                            if (checked) {

                            } else {

                            }
                       }
                   }
               }
           }

           ListItem.Base {
               width: parent.width
               height: downloadArticlesRow.height + units.gu(3)
               showDivider: true
               onClicked: {

               }

               Row {
                   id: downloadArticlesRow
                   width: parent.width
                   anchors {
                       verticalCenter: parent.verticalCenter
                   }
                   spacing: units.gu(1)

                   Column {
                       width: parent.width - downloadArticlesSync.width - units.gu(1)
                       anchors {
                           verticalCenter: parent.verticalCenter
                       }

                       Label {
                           width: parent.width
                           wrapMode: Text.WordWrap
                           elide: Text.ElideRight
                           text: i18n.tr("Auto download articles")
                       }

                       Label {
                           width: parent.width
                           elide: Text.ElideRight
                           wrapMode: Text.WordWrap
                           text: i18n.tr("")
                           fontSize: "small"
                       }
                   }

                   Switch {
                       id: downloadArticlesSync
                       anchors {
                           verticalCenter: parent.verticalCenter
                       }
                       checked: false
                       onCheckedChanged: {
                            if (checked) {

                            } else {

                            }
                       }
                   }
               }
           }

           ListItem.Base {
               width: parent.width
               height: clearFilesColumn.height + units.gu(3)
               showDivider: false
               onClicked: {

               }

               Column {
                   id: clearFilesColumn
                   width: parent.width
                   anchors {
                       verticalCenter: parent.verticalCenter
                   }

                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: i18n.tr("Clear downloaded files")
                   }
               }
           }

           ListItem.Header {
               text: i18n.tr("List")
           }

           ListItem.Base {
               width: parent.width
               height: sortColumn.height + units.gu(3)
               showDivider: false
               onClicked: {

               }

               Column {
                   id: sortColumn
                   width: parent.width
                   anchors {
                       verticalCenter: parent.verticalCenter
                   }

                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: i18n.tr("Sort")
                   }

                   Label {
                       width: parent.width
                       elide: Text.ElideRight
                       wrapMode: Text.WordWrap
                       text: i18n.tr("Newest First")
                       fontSize: "small"
                   }
               }
           }

           ListItem.Header {
               text: i18n.tr("About")
           }

           ListItem.Base {
               width: parent.width
               height: aboutColumn.height + units.gu(3)
               showDivider: true
               onClicked: {
                   isArticleOpen = true
                   pageLayout.addPageToNextColumn(settingsPage, Qt.resolvedUrl("About.qml"))
               }

               Column {
                   id: aboutColumn
                   width: parent.width
                   anchors {
                       verticalCenter: parent.verticalCenter
                   }

                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: i18n.tr("About")
                   }

                   Label {
                       width: parent.width
                       elide: Text.ElideRight
                       wrapMode: Text.WordWrap
                       text: i18n.tr("Version %1").arg(appVersion)
                       fontSize: "small"
                   }
               }
           }

           ListItem.Base {
               width: parent.width
               height: creditsColumn.height + units.gu(3)
               showDivider: false
               onClicked: {
                   isArticleOpen = true
                   pageLayout.addPageToNextColumn(settingsPage, Qt.resolvedUrl("Credits.qml"))
               }

               Column {
                   id: creditsColumn
                   width: parent.width
                   anchors {
                       verticalCenter: parent.verticalCenter
                   }

                   Label {
                       width: parent.width
                       wrapMode: Text.WordWrap
                       elide: Text.ElideRight
                       text: i18n.tr("Credits")
                   }
               }
           }
        }
    }
}
