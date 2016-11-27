import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3
import Ubuntu.Web 0.2
import com.canonical.Oxide 1.0 as Oxide

import "../components"

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

Page {
    id: articleViewPage

    property string resolved_url
    property string item_id

    // Actions
    property list<Action> articleHeaderActions: [
        Action {
            id: switchToWebViewAction
            text: i18n.tr("Web View")
            keywords: i18n.tr("Switch to Web View")
            iconName: "stock_website"
            onTriggered: {

            }
        },
        Action {
            id: goExternalAction
            text: i18n.tr("External")
            keywords: i18n.tr("Go to external link")
            iconName: "external-link"
            onTriggered: {

            }
        },
        Action {
            id: refreshAction
            text: i18n.tr("Refresh")
            keywords: i18n.tr("Re-get article")
            iconName: "reload"
            onTriggered: {

            }
        },
        Action {
            id: shareAction
            text: i18n.tr("Share")
            keywords: i18n.tr("Share")
            iconName: "share"
            onTriggered: {

            }
        },
        Action {
            id: archiveAction
            text: i18n.tr("Archive")
            keywords: i18n.tr("Archive")
            iconName: "tick"
            onTriggered: {

            }
        },
        Action {
            id: tagsAction
            text: i18n.tr("Tags")
            keywords: i18n.tr("Tags")
            iconName: "tag"
            onTriggered: {

            }
        },
        Action {
            id: favoriteAction
            text: i18n.tr("Favorite")
            keywords: i18n.tr("Favorite")
            iconName: "starred"
            onTriggered: {

            }
        },
        Action {
            id: removeAction
            text: i18n.tr("Remove")
            keywords: i18n.tr("Remove")
            iconName: "delete"
            onTriggered: {

            }
        },
        Action {
            id: displaySettingsAction
            text: i18n.tr("Display Settings")
            keywords: i18n.tr("Display Settings")
            iconName: "settings"
            onTriggered: {
            }
        }
    ]

    header: PageHeader {
        leadingActionBar {
            actions: [
                Action {
                    id: closePageAction
                    text: i18n.tr("Close")
                    iconName: "back"
                    onTriggered: {
                        isArticleOpen = false
                        pageLayout.removePages(articleViewPage)
                    }
                }

            ]
        }
        trailingActionBar {
            numberOfSlots: !wideScreen ? 3 : 9
            actions: !wideScreen ? [goExternalAction, switchToWebViewAction, refreshAction, shareAction, archiveAction, favoriteAction, tagsAction, removeAction, displaySettingsAction] : [displaySettingsAction, removeAction, tagsAction, favoriteAction, archiveAction, shareAction, refreshAction, goExternalAction, switchToWebViewAction]
        }
    }

    function parse_article() {

        // Style
        var fSize = User.getKey("fontSize") ? FontUtils.sizeToPixels(User.getKey("fontSize")) : FontUtils.sizeToPixels('small');
        var bColor = currentTheme.backgroundColor
        var fColor = currentTheme.baseFontColor
        var font = User.getKey("font") ? User.getKey("font") : "Ubuntu";
        var text_align = User.getKey("justified_text") == 'true' ? "justify" : "initial";

        var db = LocalDB.init();
        db.transaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM Articles WHERE item_id = ?", item_id)

            if (rs.rows.length === 0) {

            } else {
                var result = rs.rows.item(0);

                var newdate = result.datePublished ? result.datePublished.replace('00:00:00', '') : '';

                articleBody.loadHtml(
                    '<!DOCTYPE html>' +
                    '<html>' +
                    '<head>' +
                    '<meta charset="utf-8">' +
                    '<meta name="viewport" content="width=' + articleBody.width + '">' +
                    '<style>' +
                    'body {' +
                    'background-color: ' + bColor + ';' +
                    'color: ' + fColor + ';' +
                    'padding: 0px ' + units.gu(1.5) + 'px;' +
                    'font-family: ' + font + ';' +
                    'font-weight: 300;' +
                    'font-size: ' + fSize + 'px;' +
                    'text-align: ' + text_align +
                    '}' +
                    'code, pre { white-space: pre-wrap; word-wrap: break-word; }' +
                    'img { display: block; margin: auto; max-width: 100%; }' +
                    'a { text-decoration: none; color: #00C0C0; }' +
                    'span.upockit { font-size: ' + FontUtils.sizeToPixels('x-small') + 'px; color: ' + fColor + '; }' +
                    'h2.upockit { font-size: ' + FontUtils.sizeToPixels('large') + 'px; font-weight: 600; padding-bottom: 12px; margin-bottom: 8px; border-bottom: 1px solid ' + fColor + '; text-align: left; }' +
                    '</style>' +
                    '</head>' +
                    '<body>' +
                    '<h2 class="upockit">' + result.title + '</h2>' +
                    '<span class="upockit">' + result.host + '</span><br/>' +
                    '<span class="upockit">' + newdate + '</span><br/><br/>' +
                    result.article +
                    '</body>' +
                    '</html>'
                );
            }
        })
    }

    function home() {
        parse_article()
    }

    Component.onCompleted: {
        parse_article()
    }

    WebContext {
        id: webcontext
        userAgent: "Mozilla/5.0 (Linux; U; Android 4.0.3; ko-kr; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30"
    }

    Oxide.WebView {
        id: articleBody
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: articleViewPage.header.bottom
        }
        context: webcontext
        onNavigationRequested: {
            request.action = Oxide.NavigationRequest.ActionReject;
            Qt.openUrlExternally(request.url);
        }
    }
}
