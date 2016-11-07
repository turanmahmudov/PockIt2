import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: myListPage

    header: PageHeader {
        title: i18n.tr("PockIt")

        leadingActionBar {
            actions: navActions
        }
    }

    Column {
        anchors.top: myListPage.header.bottom

        Button {
            text: 'aaaa'

            onClicked: {
                pageLayout.addPageToNextColumn(pageLayout.primaryPage, articleViewComponent)
            }
        }
    }
}
