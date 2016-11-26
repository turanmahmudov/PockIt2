import QtQuick 2.4
import Ubuntu.Components 1.3

Page {
    id: listSortPage

    header: PageHeader {
        title: i18n.tr("List Sort")

        leadingActionBar {
            actions: [
                Action {
                    id: closePageAction
                    text: i18n.tr("Close")
                    iconName: "back"
                    onTriggered: {
                        isArticleOpen = false
                        pageLayout.removePages(listSortPage)
                    }
                }

            ]
        }
    }

    ListModel {
        id: sortModel
        Component.onCompleted: {
            sortModel.append({ name: i18n.tr("Newest First"), value: "DESC" })
            sortModel.append({ name: i18n.tr("Oldest First"), value: "ASC" })
        }
    }

    ListView {
        id: sort
        currentIndex: -1
        model: sortModel
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: listSortPage.header.bottom
        }

        delegate: ListItem {
            height: themeLayout.height + divider.height
            ListItemLayout {
                id: themeLayout

                title.text: model.name

                Icon {
                    width: units.gu(2)
                    height: width
                    name: "ok"
                    visible: listSort === model.value
                    SlotsLayout.position: SlotsLayout.Trailing
                }
            }

            onClicked: {
                listSort = model.value
                pageLayout.primaryPage.home()
            }
        }
    }
}
