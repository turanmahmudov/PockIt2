import QtQuick 2.4
import Ubuntu.Components 1.3

PageHeader {
    leadingActionBar {
        actions: navActions
    }
    trailingActionBar {
        numberOfSlots: (isArticleOpen && wideScreen) || !wideScreen ? 2 : 5
        actions: (isArticleOpen && wideScreen) || !wideScreen ? [searchAction, refreshAction, settingsAction] : [settingsAction, refreshAction, searchAction]
    }
}
