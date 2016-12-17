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
            text: articleEntryArchived ? i18n.tr("Re-add") : i18n.tr("Archive")
            keywords: articleEntryArchived ? i18n.tr("Re-add") : i18n.tr("Archive")
            iconName: "tick"
            onTriggered: {

            }
        },
        Action {
            id: favoriteAction
            text: articleEntryFavorited ? i18n.tr("Unfavorite") : i18n.tr("Favorite")
            keywords: articleEntryFavorited ? i18n.tr("Unfavorite") : i18n.tr("Favorite")
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
                bottomEdge.commit()
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

    BottomEdge {
        id: bottomEdge
        height: units.gu(20)
        hint.visible: false
        contentComponent: Page {
            width: bottomEdge.width
            height: bottomEdge.height

            header: PageHeader {
                title: i18n.tr("Display Settings")
            }

            Column {
                width: parent.width
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.header.bottom
                    bottom: parent.bottom
                }

                Row {
                    width: parent.width - units.gu(4)
                    spacing: units.gu(0.45)
                    anchors.horizontalCenter: parent.horizontalCenter

                    Row {
                        height: units.gu(5)
                        width: (parent.width-units.gu(1))/2

                        Label {
                            anchors.verticalCenter: parent.verticalCenter
                            text: article_fontFamily
                            fontSize: "large"
                        }
                    }

                    Rectangle {
                        width: units.gu(0.1)
                        height: units.gu(5)
                        color: theme.palette.normal.backgroundTertiaryText
                        opacity: 0.4
                    }

                    Column {
                        height: units.gu(5)
                        width: (parent.width-units.gu(1))/2

                        Row {
                            height: units.gu(5)
                            spacing: units.gu(1)
                            anchors.horizontalCenter: parent.horizontalCenter

                            Rectangle {
                                width: units.gu(5)
                                height: width
                                anchors.verticalCenter: parent.verticalCenter

                                Label {
                                    anchors.centerIn: parent
                                    text: "-"
                                    fontSize: "x-large"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        article_fontSize = article_fontSize-1
                                        if (article_fontSize < 0) {
                                            article_fontSize = 0
                                        } else {
                                            parse_article()
                                        }
                                    }
                                }
                            }

                            Label {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "A"
                                fontSize: "x-large"
                                font.weight: Font.DemiBold
                            }

                            Rectangle {
                                width: units.gu(5)
                                height: width
                                anchors.verticalCenter: parent.verticalCenter

                                Label {
                                    anchors.centerIn: parent
                                    text: "+"
                                    fontSize: "x-large"
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        article_fontSize = article_fontSize+1
                                        if (article_fontSize > 9) {
                                            article_fontSize = 9
                                        } else {
                                            parse_article()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: units.gu(0.1)
                    color: theme.palette.normal.backgroundTertiaryText
                    opacity: 0.4
                }
            }
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
            var rs_e = tx.executeSql("SELECT word_count, item_id, favorite, status, authors FROM Entries WHERE item_id = ?", item_id);

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

                    // Authors
                    var authors = []
                    for (var i in JSON.parse(rs_e.rows.item(0).authors)) {
                        authors.push('<span class="author">'+JSON.parse(rs_e.rows.item(0).authors)[i].name+'</span>')
                    }

                    // Style
                    var article_backgroundColor = theme.palette.normal.background
                    var article_fontColor = theme.palette.normal.backgroundText
                    var article_borderColor = theme.palette.normal.backgroundSecondaryText
                    var article_textAlign = justifiedText == true ? "justify" : "initial"

                    // Font Family
                    var article_fontFamilyString = ''
                    switch (article_fontFamily) {
                        case 'Ubuntu':
                            article_fontFamilyString = "'Ubuntu', sans-serif"
                            break;
                        default:
                            article_fontFamilyString = "'Ubuntu', sans-serif"
                    }

                    var style = '<style>' +
                            'body { overflow-x: hidden; font-weight: 400; font-size: 13px; font-family: ' + article_fontFamilyString + '; line-height: 1; margin: 0; padding: 0 ' + units.gu(1.5) + 'px; background-color: ' + article_backgroundColor + '; color: ' + article_fontColor + '; text-align: ' + article_textAlign + '; }' +
                            'a { text-decoration: none }' +
                            'a:active,a:hover,a:focus { outline:0 }' +
                            'hr { box-sizing:content-box }' +
                            'code,kbd,pre,samp { font-family:monospace,serif; font-size:1em }' +
                            'pre { white-space:pre-wrap }' +
                            'q { quotes:"“" "”" "‘" "’" }' +
                            'sub,sup { font-size:75%; line-height:0; position:relative; vertical-align:baseline }' +
                            'sup { top:-.5em }' +
                            'sub { bottom:-.25em }' +
                            'img { border:0; height:auto; max-width:100% }' +
                            'a img { border:none }' +
                            'figure { margin:0 }' +
                            '* { box-sizing:border-box; }' +
                            '.text_body { clear: both; line-height: 1.5; }' +
                            '.text_body h1,.text_body h2,.text_body h3,.text_body h4,.text_body h5,.text_body h6,.text_body h7 { font-weight: 700; }' +
                            '.text_body h1,.text_body h2 { line-height:1.3; font-size:1.4em; margin:1.7em 0 .7em; }' +
                            '.text_body h3 { line-height:1.3; font-size:1.3em; margin:1.7em 0 .5em }' +
                            '.text_body h4 { line-height:1.3; font-size:1.2em; margin:1.7em 0 .5em }' +
                            '.text_body h5,.text_body h6,.text_body h7 { font-size:1.1; font-weight:700; margin:1.7em 0 .4em }' +
                            '.text_body hr { background:#ddd; border:0; height:1px; margin:1em 0 1.5em; padding:0 }' + // ?
                            '.text_body p { line-height:1.5; margin:0 0 1.5em }' +
                            '.text_body ol,.text_body ul { margin:1.5em 0 1.5em 2em; padding: 0 }' +
                            '.text_body li { margin:0 0 .4em }' +
                            '.text_body ol ol,.text_body ul ul { margin:.75em 0 1em 2em }' +
                            '.text_body blockquote,.text_body pre { display:block; margin:1.5em 0; padding:.5em 1.5em; white-space:pre-wrap; white-space:-pre-wrap; white-space:-o-pre-wrap; word-wrap:break-word }' +
                            '.text_body blockquote { border-left: 2px solid #313131; }' +
                            '.text_body pre { border: 1px solid #313131; background: ' + theme.palette.normal.foreground + '; overflow: auto; word-break: normal !important; word-wrap: normal !important; white-space: pre !important; }' +
                            '.text_body a { cursor:pointer; color:#43aea8 }' +
                            '.text_body table { border-collapse:collapse; width:100%; margin:20px 0 }' +
                            '.text_body table td { width:auto; text-align:left; padding:2px 5px; background:0 0; border:0 }' +
                            '.RIL_IMG { display:block; margin:0 auto; overflow:visible; position:relative; text-align: center; margin: 0 auto 18px; }' +
                            '.RIL_IMG:after { content:"."; display:block; height:0; clear:both; visibility:hidden }' +
                            '.RIL_IMG img { border:0 !important; text-decoration:none !important; max-width:100% }' +
                            '.RIL_IMG caption,.RIL_IMG cite, .RIL_IMG .ril_caption { clear:both; display:block }' +
                            '.RIL_IMG caption, a .RIL_IMG caption, .RIL_IMG .ril_caption { padding:10px 0 1px; color:#b1b2b2!important; font-size:.8em; line-height:1.2em; text-align:left; text-decoration:none !important }' +
                            '.fontsize-0 .text_body { font-size:12px }' +
                            '@media only screen and (min-width:34em) { .fontsize-0 .text_body { font-size:14px } }' +
                            '.fontsize-1 .text_body { font-size:14px }' +
                            '@media only screen and (min-width:34em) { .fontsize-1 .text_body { font-size:16px } }' +
                            '.fontsize-2 .text_body { font-size:16px }' +
                            '@media only screen and (min-width:34em) { .fontsize-2 .text_body { font-size:18px } }' +
                            '.fontsize-3 .text_body { font-size:18px }' +
                            '@media only screen and (min-width:34em) { .fontsize-3 .text_body { font-size:20px } }' +
                            '.fontsize-4 .text_body { font-size:20px }' +
                            '@media only screen and (min-width:34em) { .fontsize-4 .text_body { font-size:22px } }' +
                            '.fontsize-5 .text_body { font-size:21px }' +
                            '@media only screen and (min-width:34em) { .fontsize-5 .text_body { font-size:24px } }' +
                            '.fontsize-6 .text_body { font-size:22px }' +
                            '@media only screen and (min-width:34em) { .fontsize-6 .text_body { font-size:26px } }' +
                            '.fontsize-7 .text_body { font-size:23px }' +
                            '@media only screen and (min-width:34em) { .fontsize-7 .text_body { font-size:28px } }' +
                            '.fontsize-8 .text_body { font-size:24px }' +
                            '@media only screen and (min-width:34em) { .fontsize-8 .text_body { font-size:32px } }' +
                            '.fontsize-9 .text_body { font-size:25px }' +
                            '@media only screen and (min-width:34em) { .fontsize-9 .text_body { font-size:36px } }' +
                            '.reader_head { margin-bottom: 35px; font-size: 14px; padding-bottom: 0; }' +
                            '.reader_head h1 { font-size: 1.6em; font-weight: 500; line-height: 1.2; margin: 1em 0 0; padding-bottom: .1em; }' +
                            '.reader_head h1:after { content:""; display:block; height:1px; background: ' + article_borderColor + '; opacity: 0.4; margin-top: 0.4em; }' +
                            '@media only screen and (min-width:34em) { .reader_head h1 { font-size:2em } }' +
                            '.reader_head .sub { list-style: none; margin-bottom: 4em; margin-top:10px; color: ' + theme.palette.normal.backgroundSecondaryText + ' }' +
                            '.reader_head .sub,.reader_head .sub li { border-left:none; height:.9em; line-height:.9em; font-size:.9em; padding-left:0; padding-right:0 }' +
                            '.reader_head .sub a { bottom:0; text-decoration:none }' +
                            '.reader_head .sub .authorsdomain { height: auto; line-height: 1.2; max-width: 22em; }' +
                            '.reader_head .author { font-weight: 700; }' +
                            '.reader_head .domain { position: relative; }' +
                            '.reader_head .date { clear: left; margin-top: .5em; }' +
                            '</style>'

                    articleBody.loadHtml(
                        '<!DOCTYPE html>' +
                        '<html>' +
                        '<head>' +
                        '<meta charset="utf-8">' +
                        '<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />' +
                        style +
                        '</head>' +
                        '<body>' +
                        '<div class="reader_head">' +
                        '<h1>' + result.title + '</h1>' +
                        '<ul class="sub">' +
                        '<li class="authorsdomain">' +
                        (authors.length > 0 ? ('<span class="authors">By ' + authors.join(', ') + ', </span>') : '') +
                        '<span class="domain">' + result.host + '</span>' +
                        '</li>' +
                        '<li class="date">' + newdate + '</li>' +
                        '</ul>' +
                        '</div>' +
                        '<div class="fontsize-'+ article_fontSize.toString() +'"><div class="text_body">' + result.article + '</div></div>' +
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
