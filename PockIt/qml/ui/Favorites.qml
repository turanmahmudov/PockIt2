import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: favoritesPage

    header: PageHeader {
        title: i18n.tr("Favorites")

        leadingActionBar {
            actions: navActions
        }
        trailingActionBar {
            numberOfSlots: (isArticleOpen && wideScreen) || !wideScreen ? 2 : 5
            actions: (isArticleOpen && wideScreen) || !wideScreen ? [searchAction, refreshAction, settingsAction, helpAction] : [helpAction, settingsAction, refreshAction, searchAction]
        }
    }
}
