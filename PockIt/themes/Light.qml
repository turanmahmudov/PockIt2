import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Themes.Ambiance 0.1

QtObject {
    property string baseThemeName: "Ubuntu.Components.Themes.Ambiance"

    // MainView
    property color backgroundColor: '#ffffff'
    property color backgroundHeaderColor: backgroundColor
    property color backgroundFooterColor: backgroundColor
    property color panelColor: Qt.darker(Theme.palette.normal.background, 1.2)
    property color panelOverlay: '#ffffff'

    // Base Text
    property color baseFontColor: Qt.darker(UbuntuColors.darkGrey, 1.2)
    property color baseLinkColor: UbuntuColors.blue
}
