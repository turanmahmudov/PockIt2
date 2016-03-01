import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.3 as ListItem
import Ubuntu.Components.Popups 1.3

Page {
    id: helpPage
    title: slug != '' ? help_content[slug]['title'] : i18n.tr("Help")

    property string slug: ''

    Component.onCompleted: {
    }

    property var help_content: {
        "how-to-save": {
            "title": i18n.tr("How To Save"),
            "content": i18n.tr("<h4>Welcome to PockIt</h4><br>"
                               +"<p>You can save to PockIt from apps on your Ubuntu device. Just look for the share button, ie, on your web browser. When you find share button, you will find an option \"PockIt\".</p>")
        },
        "pockit-basics": {
            "title": i18n.tr("PockIt Basics"),
            "content": i18n.tr("<h4>Welcome to PockIt</h4><br>"
                               +"<p>When you open PockIt, your saved items appear in your List with the newest item on top. Just tap an item to open it.<br>You can even open items while you're offline.</p><br>"
                               +"<h4>Working With Your List</h4><br>"
                               +"<p>Just swipe from left or right on any item in your Lis to show the item actions. They make it easy to Archive, Favorite, Delete and Share any item in your List.</p>"
                               +"<br><h4>The PockIt Menu</h4><br><p>PockIt's Menu button is located at the top left corner of the screen. It helps you reach all areas of the app.</p>")
        }
    }

    Column {
        spacing: units.gu(4)
        anchors {
            left: parent.left;
            right: parent.right;
            top: parent.top
            margins: units.gu(2)
            topMargin: units.gu(2)
        }

        Label {
            text: help_content[slug]['content']
            width: parent.width
            wrapMode: Text.WordWrap
            linkColor: UbuntuColors.orange
            fontSize: "small"
            onLinkActivated: Qt.openUrlExternally(link)
        }
    }
}
