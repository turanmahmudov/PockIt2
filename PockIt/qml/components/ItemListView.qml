import QtQuick 2.4
import Ubuntu.Components 1.3

ListView {
    property var page
    property string pageString

    clip: true
    state: ViewItems.selectMode ? "multiselectable" : "normal"
    onStateChanged: {
        if (state === "multiselectable") {
            page.state = "selection"
        } else {
            page.state = "default"
        }
    }
    ViewItems.selectMode: false
    delegate: ItemListDelegate {
        pageId: page
        pageIdString: pageString
    }

    function getSelectedIndices() {
        var indicies = ViewItems.selectedIndices.slice();

        indicies.sort();

        return indicies;
    }

    signal selectAll()
    signal clearSelection()
    signal closeSelection()

    onSelectAll: {
        var tmp = []

        for (var i=0; i < model.count; i++) {
            tmp.push(i)
        }

        ViewItems.selectedIndices = tmp
    }
    onClearSelection: ViewItems.selectedIndices = []
    onCloseSelection: {
        clearSelection()
        ViewItems.selectMode = false
    }
}
