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
                        'body { background-color: ' + article_backgroundColor + '; color: ' + article_fontColor + '; padding: 0 ' + units.gu(1.5) + 'px; font-family: ' + article_fontFamily + '; font-weight: 400; font-size: ' + article_fontSize + 'px; text-align: ' + article_textAlign + '}' +
                        '.text_body { line-height: 1.5; }' +
                        'img { display: inline-block; vertical-align: middle; height: auto; }' +
                        'p { line-height: 1.5; margin: 0 0 1.5em; font-size: 1em; font-weight: 400; text-rendering: optimizeLegibility; }' +
                        'h1, h2 { line-height: 1.3; font-size: 1.4em; margin: 1.7em 0 .7em; font-weight: 700; }' +
                        'ul { margin: 1.5em 0 1.5em 2em; font-size: 1em; line-height: 1.5; list-style-position: outside; }' +
                        'li { margin: 0 0 .4em; }' +
                        'code { white-space: pre-wrap; word-wrap: break-word; color: #1f35be; font-weight: 700; font-size: 1em; }' +
                        'pre, blockquote { white-space: pre-wrap; word-wrap: break-word; display: block; margin: 1.5em 0; padding: .5em 1.5em; }' +
                        'figure { margin: 0; display: block; }' +
                        'blockquote { border-left: 2px solid #313131; }' +
                        'img { display: block; margin: auto; max-width: 100%; }' +
                        'a { text-decoration: none; color: #43aea8; }' +
                        '.RIL_IMG { display: none; margin: 0 auto; overflow: visible; position: relative;}' +
                        '.RIL_IMG { display: block; text-align: center; margin: 0 auto 18px; }' +
                        '.RIL_IMG img { border: 0 !important; text-decoration: none !important; max-width: 100%; }' +
                        '.RIL_IMG caption, .RIL_IMG .ril_caption, .RIL_IMG cite { clear: both; }' +
                        '.RIL_IMG caption, .RIL_IMG .ril_caption { display: block; padding: 10px 0 1px; color: #b1b2b2 !important; font-size: .8em; line-height: 1.2em; text-align: left !important; text-decoration: none !important; }' +
                        'span.upockit { font-size: ' + FontUtils.sizeToPixels('x-small') + 'px; color: ' + article_fontColor + '; }' +
                        'h2.upockit { font-size: ' + FontUtils.sizeToPixels('large') + 'px; font-weight: 600; padding-bottom: 12px; margin-bottom: 8px; border-bottom: 1px solid ' + article_borderColor + '; text-align: left; }' +
                        '</style>' +
                        '</head>' +
                        '<body>' +
                        '<h2 class="upockit">' + result.title + '</h2>' +
                        '<span class="upockit">' + result.host + '</span><br/>' +
                        '<span class="upockit">' + newdate + '</span><br/><br/>' +
                        '<div class="text_body">' + result.article + '</div>' +
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
