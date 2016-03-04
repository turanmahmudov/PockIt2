import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.LocalStorage 2.0
import "../js/localdb.js" as LocalDb
import "../js/user.js" as User
import "../js/scripts.js" as Scripts

Dialog {
    id: stylesDialog
    property real labelwidth: units.gu(10)

    // Theme
    OptionSelector {
        id: colorSelector
        onSelectedIndexChanged: {
            if (selectedIndex == 0) {
                User.setKey('dark_theme', 'false')
                themeManager.currentThemeIndex = 0
            } else {
                User.setKey('dark_theme', 'true')
                themeManager.currentThemeIndex = 1
            }
            Scripts.get_article(articleView.entry_id, articleView.entry_url, false, 0, false, false, false, true, true);
        }
        selectedIndex: User.getKey('dark_theme') == 'true' ? 1 : 0
        model: colorModel
        showDivider: false
        delegate: OptionSelectorDelegate {
            showDivider: false
            text: i18n.tr(name)
        }
    }
    ListModel {
        id: colorModel
        ListElement {
            name: "Light"
        }
        ListElement {
            name: "Dark"
        }
    }

    // Font selector
    OptionSelector {
        id: fontSelector
        onSelectedIndexChanged: {
            if (selectedIndex == 0) {
                User.setKey('font', 'Ubuntu')
            } else {
                User.setKey('font', 'Arial')
            }
            Scripts.get_article(articleView.entry_id, articleView.entry_url, false, 0, false, false, false, true, true);
        }
        selectedIndex: User.getKey("font") == 'Ubuntu' ? 0 : 1
        model: fontModel
        showDivider: false
        delegate: OptionSelectorDelegate {
            showDivider: false
            text: i18n.tr(name)
        }
    }
    ListModel {
        id: fontModel
        ListElement {
            name: "Ubuntu"
        }
        ListElement {
            name: "Arial"
        }
    }

    // Font size
    Row {
        Label {
            text: i18n.tr("Font Size")
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.Wrap
            width: labelwidth
            height: fontScaleSlider.height
            color: Qt.darker(UbuntuColors.darkGrey, 1.2)
        }

        Slider {
            id: fontScaleSlider
            width: parent.width - labelwidth
            minimumValue: 1
            maximumValue: 6
            value: reFormatValue(User.getKey("fontSize") ? User.getKey("fontSize") : "small")
            function reFormatValue(v) {
                var data = {"":0, "xx-small":1, "x-small":2, "small":3, "medium":4, "large":5, "x-large":6};
                return data[v];
            }
            function formatValue(v) {
                return ["", "xx-small", "x-small", "small", "medium", "large", "x-large"][Math.round(v)]
            }
            onValueChanged: {
                User.setKey('fontSize', formatValue(value))
                Scripts.get_article(articleView.entry_id, articleView.entry_url, false, 0, false, false, false, true, true);
            }
        }
    }

    Button {
        text: i18n.tr("Close")
        onClicked: PopupUtils.close(stylesDialog)
    }
}
