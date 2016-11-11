import QtQuick 2.4
import Ubuntu.Components 1.3

PageHeader {
    property list<Action> sections

    leadingActionBar {
        actions: navActions
    }
    trailingActionBar {
        numberOfSlots: (isArticleOpen && wideScreen) || !wideScreen ? 2 : 5
        actions: (isArticleOpen && wideScreen) || !wideScreen ? [searchAction, refreshAction, settingsAction, helpAction] : [helpAction, settingsAction, refreshAction, searchAction]
    }
    extension: Sections {
        anchors {
            bottom: parent.bottom
        }
        actions: sections
    }
}
