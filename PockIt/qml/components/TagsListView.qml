import QtQuick 2.4
import Ubuntu.Components 1.3

ListView {
    property var page

    clip: true
    state: "normal"
    ViewItems.selectMode: false
    delegate: TagsListDelegate {
        pageId: page
    }
}
