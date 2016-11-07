import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: tagsPage

    header: PageHeader {
        title: i18n.tr("Tags")

        leadingActionBar {
            actions: navActions
        }
    }
}
