import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3

import "../components"

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

Page {
    id: articleViewPage

    property string resolved_url
    property string item_id

    // Actions
    property list<Action> articleHeaderActions: [
        Action {
            id: switchToWebViewAction
            text: i18n.tr("Web View")
            keywords: i18n.tr("Switch to Web View")
            iconName: "stock_website"
            onTriggered: {

            }
        },
        Action {
            id: goExternalAction
            text: i18n.tr("External")
            keywords: i18n.tr("Go to external link")
            iconName: "external-link"
            onTriggered: {

            }
        },
        Action {
            id: refreshAction
            text: i18n.tr("Refresh")
            keywords: i18n.tr("Re-get article")
            iconName: "reload"
            onTriggered: {

            }
        },
        Action {
            id: shareAction
            text: i18n.tr("Share")
            keywords: i18n.tr("Share")
            iconName: "share"
            onTriggered: {

            }
        },
        Action {
            id: archiveAction
            text: i18n.tr("Archive")
            keywords: i18n.tr("Archive")
            iconName: "tick"
            onTriggered: {

            }
        },
        Action {
            id: tagsAction
            text: i18n.tr("Tags")
            keywords: i18n.tr("Tags")
            iconName: "tag"
            onTriggered: {

            }
        },
        Action {
            id: favoriteAction
            text: i18n.tr("Favorite")
            keywords: i18n.tr("Favorite")
            iconName: "starred"
            onTriggered: {

            }
        },
        Action {
            id: removeAction
            text: i18n.tr("Remove")
            keywords: i18n.tr("Remove")
            iconName: "delete"
            onTriggered: {

            }
        },
        Action {
            id: displaySettingsAction
            text: i18n.tr("Display Settings")
            keywords: i18n.tr("Display Settings")
            iconName: "settings"
            onTriggered: {
            }
        }
    ]

    header: PageHeader {
        leadingActionBar {
            actions: [
                Action {
                    id: closePageAction
                    text: i18n.tr("Close")
                    iconName: "back"
                    onTriggered: {
                        isArticleOpen = false
                        pageLayout.removePages(articleViewPage)
                    }
                }

            ]
        }
        trailingActionBar {
            numberOfSlots: !wideScreen ? 3 : 9
            actions: !wideScreen ? [goExternalAction, switchToWebViewAction, refreshAction, shareAction, archiveAction, tagsAction, favoriteAction, removeAction, displaySettingsAction] : [displaySettingsAction, removeAction, favoriteAction, tagsAction, archiveAction, shareAction, refreshAction, goExternalAction, switchToWebViewAction]
        }
    }

    Component.onCompleted: {

    }
}
