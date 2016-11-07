import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: myListPage

    header: PageHeader {
        title: i18n.tr("PockIt")

        leadingActionBar {
            actions: navActions
        }
        trailingActionBar {
            numberOfSlots: 2
            actions: [searchAction, settingsAction]
        }
    }
}
