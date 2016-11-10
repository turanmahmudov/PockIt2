import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Web 0.2

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
    }
}
