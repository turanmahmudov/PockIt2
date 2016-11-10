import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3
import Ubuntu.Connectivity 1.0
import Ubuntu.Web 0.2

import "../components"
import "../themes" as Themes

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

Page {
    id: loginPage

    header: PageHeader {
        title: i18n.tr("Login")
    }

    WebContext {
        id: webcontext
        userAgent: "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:45.0) Gecko/20100101 Firefox/45.0"
    }

    WebView {
        id: webView
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: loginPage.header.bottom
        }

        context: webcontext
        incognito: true
        preferences.localStorageEnabled: true
        preferences.allowFileAccessFromFileUrls: true
        preferences.allowUniversalAccessFromFileUrls: true
        preferences.appCacheEnabled: true
        preferences.javascriptCanAccessClipboard: true

        // the redirect_uri can be any site
        property string redirect_uri : "https://api.github.com/zen"
        property var request_token : User.getKey('request_token')

        url: "https://getpocket.com/auth/authorize?request_token="+request_token+"&redirect_uri="+encodeURIComponent(redirect_uri)

        onUrlChanged: {
            if (url == redirect_uri) {
                Scripts.get_access_token()
            } else if (url.toString().substring(0, 24) == "https://getpocket.com/a/") {
                webView.url = "https://getpocket.com/auth/authorize?request_token="+request_token+"&redirect_uri="+encodeURIComponent(redirect_uri)
            }
        }

        onLoadingChanged: {
            if (webView.lastLoadFailed) {

            }
        }
    }

    UbuntuShape {
        anchors.centerIn: parent
        width: column.width + units.gu(4)
        height: column.height + units.gu(4)
        backgroundColor: Qt.rgba(0.2, 0.2, 0.2, 0.8)
        opacity: webView.loading ? 1 : 0

        Behavior on opacity {
            UbuntuNumberAnimation {
                duration: UbuntuAnimation.SlowDuration
            }
        }

        Column {
            id: column
            anchors.centerIn: parent
            spacing: units.gu(1)

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#fff"
                fontSize: "large"
                text: webView.loading ? i18n.tr("Loading...") : i18n.tr("Success!")
            }

            ProgressBar {
                anchors.horizontalCenter: parent.horizontalCenter
                width: units.gu(30)
                maximumValue: 100
                minimumValue: 0
                value: webView.loadProgress
            }
        }
    }
}
