import QtQuick 2.4
import Ubuntu.Components 1.3
import QtSystemInfo 5.0
import Ubuntu.Connectivity 1.0
import Ubuntu.Content 1.1

MainView {
    id: mainView
    objectName: "mainView"

    applicationName: "pockit.turan-mahmudov-l"

    automaticOrientation: true
    anchorToKeyboard: true

    width: units.gu(50)
    height: units.gu(75)

    ScreenSaver {
        id: screenSaver
        screenSaverEnabled: true
    }

    Connections {
        target: Connectivity
    }

    Connections {
        target: ContentHub
        onShareRequested: {

        }
    }
}
