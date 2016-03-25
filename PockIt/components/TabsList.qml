import QtQuick 2.4
import Ubuntu.Components 1.3

ActionList {
    id: tabsList

    children: [
        Action {
            text: i18n.tr("My List")
            iconName: "view-list-symbolic"
            onTriggered: {
                tabs.selectedTabIndex = 0
            }
        },
        Action {
            text: i18n.tr("Favorites")
            iconName: "starred"
            onTriggered: {
                tabs.selectedTabIndex = 1
            }
        },
        Action {
            text: i18n.tr("Archive")
            iconName: "tick"
            onTriggered: {
                tabs.selectedTabIndex = 2
            }
        },
        Action {
            text: i18n.tr("Tags")
            iconName: "tag"
            onTriggered: {
                tabs.selectedTabIndex = 3
            }
        }
    ]
}

