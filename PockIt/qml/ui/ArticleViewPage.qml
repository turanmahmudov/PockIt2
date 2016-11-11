import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: articleViewPage

    property string resolved_url
    property string item_id

    header: PageHeader {
        title: i18n.tr("Article")

        leadingActionBar {
            actions: [
                Action {
                    id: closePageAction
                    text: i18n.tr("Close")
                    iconName: "back"
                    onTriggered: {
                        isArticleOpen = false
                        pageLayout.removePages(pageLayout.primaryPage)
                    }
                }

            ]
        }
    }
}
