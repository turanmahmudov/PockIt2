import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

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
        }
        contentHeight: columnSuperior.height

        Column {
           id: columnSuperior
           width: parent.width

           ListItem {
               height: yourAccountHeader.height

               ListItemLayout {
                   id: yourAccountHeader

                   title.text: i18n.tr("Account")
                   title.font.weight: Font.Normal
               }
           }

           ListItem {
               height: logOutLayout.height
               divider.visible: false
               ListItemLayout {
                   id: logOutLayout

                   title.text: i18n.tr("Log out")
                   subtitle.text: User.getKey('username') ? User.getKey('username') : ''
                   subtitle.visible: User.getKey('username') ? true : false
               }

               onClicked: {
                   Scripts.logOut()
               }
           }

           ListItem {
               height: generalHeader.height

               ListItemLayout {
                   id: generalHeader

                   title.text: i18n.tr("General")
                   title.font.weight: Font.Normal
               }
           }

           ListItem {
               height: themeLayout.height
               divider.visible: false
               ListItemLayout {
                   id: themeLayout

                   title.text: i18n.tr("Dark theme")
                   subtitle.text: i18n.tr("You can also toggle this by tapping the Theme button in the Article View")
                   subtitle.maximumLineCount: 2
                   subtitle.wrapMode: Text.WordWrap

                   Switch {
                       id: themeSwitch
                       SlotsLayout.position: SlotsLayout.Trailing
                       checked: darkTheme
                       onCheckedChanged: {
                            if (checked) {
                                darkTheme = true
                                themeManager.currentThemeIndex = 1
                            } else {
                                darkTheme = false
                                themeManager.currentThemeIndex = 0
                            }
                       }
                   }
               }
           }

           ListItem {
               height: readingHeader.height

               ListItemLayout {
                   id: readingHeader

                   title.text: i18n.tr("Reading")
                   title.font.weight: Font.Normal
               }
           }

           ListItem {
               height: openBestViewLayout.height
               ListItemLayout {
                   id: openBestViewLayout

                   title.text: i18n.tr("Open best view")
                   subtitle.text: i18n.tr("PockIt will automatically decide the best view (Article or Web View) to show")
                   subtitle.maximumLineCount: 2
                   subtitle.wrapMode: Text.WordWrap

                   Switch {
                       id: openBestViewSwitch
                       SlotsLayout.position: SlotsLayout.Trailing
                       checked: openBestView
                       onCheckedChanged: {
                            if (checked) {
                                openBestView = true
                            } else {
                                openBestView = false
                            }
                       }
                   }
               }
           }

           ListItem {
               height: justifiedTextLayout.height
               divider.visible: false
               ListItemLayout {
                   id: justifiedTextLayout

                   title.text: i18n.tr("Justified Text")
                   subtitle.text: i18n.tr("Displays text in Article View with justification")
                   subtitle.maximumLineCount: 2
                   subtitle.wrapMode: Text.WordWrap

                   Switch {
                       id: justifiedTextSwitch
                       SlotsLayout.position: SlotsLayout.Trailing
                       checked: justifiedText
                       onCheckedChanged: {
                            if (checked) {
                                justifiedText = true
                            } else {
                                justifiedText = false
                            }
                       }
                   }
               }
           }

           ListItem {
               height: offlineDownloadingHeader.height

               ListItemLayout {
                   id: offlineDownloadingHeader

                   title.text: i18n.tr("Offline Downloading")
                   title.font.weight: Font.Normal
               }
           }

           ListItem {
               height: downloadArticlesLayout.height
               ListItemLayout {
                   id: downloadArticlesLayout

                   title.text: i18n.tr("Download Articles")

                   Switch {
                       id: downloadArticlesSyncSwitch
                       SlotsLayout.position: SlotsLayout.Trailing
                       checked: downloadArticlesSync
                       onCheckedChanged: {
                            if (checked) {
                                downloadArticlesSync = true
                            } else {
                                downloadArticlesSync = false
                            }
                       }
                   }
               }
           }

           ListItem {
               height: mobileUserAgentLayout.height
               ListItemLayout {
                   id: mobileUserAgentLayout

                   title.text: i18n.tr("Use Mobile User Agent")

                   Switch {
                       id: mobileUserAgentSwitch
                       SlotsLayout.position: SlotsLayout.Trailing
                       checked: mobileUserAgent
                       onCheckedChanged: {
                            if (checked) {
                                mobileUserAgent = true
                            } else {
                                mobileUserAgent = false
                            }
                       }
                   }
               }
           }

           ListItem {
               height: clearFilesLayout.height
               divider.visible: false
               ListItemLayout {
                   id: clearFilesLayout

                   title.text: i18n.tr("Clear downloaded files")
               }

               onClicked: {
                    Scripts.clear_list()
               }
           }

           ListItem {
               height: listHeader.height

               ListItemLayout {
                   id: listHeader

                   title.text: i18n.tr("List")
                   title.font.weight: Font.Normal
               }
           }

           ListItem {
               height: autoSyncLayout.height
               ListItemLayout {
                   id: autoSyncLayout

                   title.text: i18n.tr("Sync when app opens")

                   Switch {
                       id: autoSyncSwitch
                       SlotsLayout.position: SlotsLayout.Trailing
                       checked: autoSync
                       onCheckedChanged: {
                            if (checked) {
                                autoSync = true
                            } else {
                                autoSync = false
                            }
                       }
                   }
               }
           }

           ListItem {
               height: sortLayout.height
               divider.visible: false
               ListItemLayout {
                   id: sortLayout

                   title.text: i18n.tr("Sort")

                   Label {
                       id: sortSubtitle
                       SlotsLayout.position: SlotsLayout.Trailing
                       fontSize: "small"
                       color: theme.palette.normal.backgroundSecondaryText
                       text: listSort === 'DESC' ? i18n.tr("Newest First") : i18n.tr("Oldest First")
                   }
               }

               onClicked: {
                   isArticleOpen = true
                   pageLayout.addPageToNextColumn(settingsPage, Qt.resolvedUrl("settings/ListSort.qml"))
               }
           }

           ListItem {
               height: aboutHeader.height

               ListItemLayout {
                   id: aboutHeader

                   title.text: i18n.tr("About")
                   title.font.weight: Font.Normal
               }
           }

           ListItem {
               height: aboutLayout.height
               ListItemLayout {
                   id: aboutLayout

                   title.text: i18n.tr("About")
                   subtitle.text: i18n.tr("Version %1").arg(appVersion)
                   subtitle.maximumLineCount: 2
                   subtitle.wrapMode: Text.WordWrap
               }

               onClicked: {
                   isArticleOpen = true
                   pageLayout.addPageToNextColumn(settingsPage, Qt.resolvedUrl("About.qml"))
               }
           }

           ListItem {
               height: creditsLayout.height
               divider.visible: false
               ListItemLayout {
                   id: creditsLayout

                   title.text: i18n.tr("Credits")
               }

               onClicked: {
                   isArticleOpen = true
                   pageLayout.addPageToNextColumn(settingsPage, Qt.resolvedUrl("Credits.qml"))
               }
           }
        }
    }
}
