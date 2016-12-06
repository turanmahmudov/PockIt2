import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3
import Ubuntu.Connectivity 1.0
import Ubuntu.Web 0.2
import com.canonical.Oxide 1.0 as Oxide

import "../components"

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

Page {
    id: articleViewPage

    // Params come from List
    property string resolved_url
    property string item_id

    // Other params
    property bool articleWebView: false
    property string articleEntryId: ''
    property string articleEntryUrl: ''
    property string articleEntryTitle: ''
    property bool articleEntryFavorited: false
    property bool articleEntryArchived: false

    // Actions
    property list<Action> articleHeaderActions: [
        Action {
            id: switchToWebViewAction
            text: articleWebView ? i18n.tr("Article View") : i18n.tr("Web View")
            keywords: articleWebView ? i18n.tr("Switch to Article View") : i18n.tr("Switch to Web View")
            iconName: articleWebView ? "stock_note" : "stock_website"
            onTriggered: {
                if (articleWebView) {
                    articleWebView = false
                    parse_article(true)
                } else {
                    articleBody.url = articleEntryUrl
                    articleWebView = true
                }
            }
        },
        Action {
            id: goExternalAction
            text: i18n.tr("External")
            keywords: i18n.tr("Go to external link")
            iconName: "external-link"
            onTriggered: {
                Qt.openUrlExternally(articleEntryUrl)
            }
        },
        Action {
            id: refreshAction
            text: i18n.tr("Refresh")
            keywords: i18n.tr("Re-get article")
            iconName: "reload"
            onTriggered: {
                var mustGetArticlesList = []
                mustGetArticlesList.push({'item_id': item_id, 'resolved_url': resolved_url})
                Scripts.get_article(mustGetArticlesList, 0, true)
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
            id: favoriteAction
            text: i18n.tr("Favorite")
            keywords: i18n.tr("Favorite")
            iconName: "starred"
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

    function clear_old_article() {
        articleBody.loadHtml('')
    }

    function parse_article(articleViewSwitch) {
        clear_old_article()

        var db = LocalDB.init();
        db.transaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM Articles WHERE item_id = ?", item_id);
            var rs_e = tx.executeSql("SELECT word_count, item_id, favorite, status FROM Entries WHERE item_id = ?", item_id);

            if (rs.rows.length === 0) {
                var mustGetArticlesList = []
                mustGetArticlesList.push({'item_id': item_id, 'resolved_url': resolved_url})
                Scripts.get_article(mustGetArticlesList, 0, true)
            } else {
                var result = rs.rows.item(0);

                if (!articleViewSwitch && openBestView && rs_e.rows.item(0).word_count === '0') {
                    // Other params
                    articleWebView = true
                    articleEntryId = item_id
                    articleEntryUrl = resolved_url
                    articleEntryTitle = result.title !== '' ? result.title : ' '
                    articleEntryFavorited = rs_e.rows.item(0).favorite === "1" ? true : false
                    articleEntryArchived = rs_e.rows.item(0).status === "1" ? true : false

                    articleBody.url = resolved_url
                } else {
                    // Other params
                    articleWebView = false
                    articleEntryId = item_id
                    articleEntryUrl = resolved_url
                    articleEntryTitle = result.title !== '' ? result.title : ' '
                    articleEntryFavorited = rs_e.rows.item(0).favorite === "1" ? true : false
                    articleEntryArchived = rs_e.rows.item(0).status === "1" ? true : false

                    var newdate = result.datePublished ? result.datePublished.replace('00:00:00', '') : '';

                    // Style
                    var article_backgroundColor = theme.palette.normal.background
                    var article_fontColor = theme.palette.normal.backgroundText
                    var article_borderColor = theme.palette.normal.backgroundSecondaryText
                    var article_textAlign = justifiedText == true ? "justify" : "initial"

                    articleBody.loadHtml(
                        '<!DOCTYPE html>' +
                        '<html>' +
                        '<head>' +
                        '<meta charset="utf-8">' +
                        '<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />' +
                        '<style>' +
                        'body {' +
                        'background-color: ' + article_backgroundColor + ';' +
                        'color: ' + article_fontColor + ';' +
                        'padding: 0 ' + units.gu(1.5) + 'px;' +
                        'font-family: ' + article_fontFamily + ';' +
                        'font-weight: 300;' +
                        'font-size: ' + article_fontSize + 'px;' +
                        'text-align: ' + article_textAlign +
                        '}' +
                        'code, pre { white-space: pre-wrap; word-wrap: break-word; }' +
                        'img { display: block; margin: auto; max-width: 100%; }' +
                        'a { text-decoration: none; color: ' + UbuntuColors.blue + '; }' +
                        'span.upockit { font-size: ' + FontUtils.sizeToPixels('x-small') + 'px; color: ' + article_fontColor + '; }' +
                        'h2.upockit { font-size: ' + FontUtils.sizeToPixels('large') + 'px; font-weight: 600; padding-bottom: 12px; margin-bottom: 8px; border-bottom: 1px solid ' + article_borderColor + '; text-align: left; }' +
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
            }
        })
    }

    function home() {
        parse_article()
    }

    Component.onCompleted: {

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
