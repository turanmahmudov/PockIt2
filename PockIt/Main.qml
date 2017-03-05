import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import QtSystemInfo 5.0
import Qt.labs.settings 1.0
import Ubuntu.Components 1.3
import Ubuntu.Connectivity 1.0
import Ubuntu.Content 1.1
import Ubuntu.Components.Popups 1.3

import "qml/components"
import "qml/ui" as Ui
import "qml/themes" as Themes

import "qml/js/localdb.js" as LocalDB
import "qml/js/user.js" as User
import "qml/js/apiKeys.js" as ApiKeys
import "qml/js/scripts.js" as Scripts

MainView {
    id: mainView
    objectName: "mainView"
    applicationName: "pockit.turan-mahmudov-l"

    automaticOrientation: true
    anchorToKeyboard: true

    width: units.gu(50)
    height: units.gu(80)

    // Startup settings
    Settings {
        id: settings

        property bool firstRun: true

        property bool firstSync: true

        property bool darkTheme: false
        property bool justifiedText: false
        property bool openBestView: true
        property bool autoSync: true
        property bool downloadArticlesSync: true
        property bool mobileUserAgent: true
        property string listSort: 'DESC'

        property int article_fontSize: 0
        property string article_fontFamily: "Ubuntu"
    }

    // Keep screen on
    ScreenSaver {
        id: screenSaver
        screenSaverEnabled: true
    }

    // Connectivity
    Connections {
        target: Connectivity
    }

    // Themes
    Themes.ThemeManager {
        id: themeManager
        themes: [
            {name: i18n.tr('Light'), source: Qt.resolvedUrl('qml/themes/Light.qml')},
            {name: i18n.tr('Dark'), source: Qt.resolvedUrl('qml/themes/Dark.qml')}
        ]
        source: settings.darkTheme == true ? "Dark.qml" : "Light.qml"
    }
    property alias currentTheme: themeManager.theme
    property var themeManager: themeManager
    theme.name: currentTheme.baseThemeName

    // Variables
    property string appVersion: '0.2'

    property alias firstRun: settings.firstRun

    property alias firstSync: settings.firstSync

    property alias darkTheme: settings.darkTheme
    property alias justifiedText: settings.justifiedText
    property alias openBestView: settings.openBestView
    property alias autoSync: settings.autoSync
    property alias downloadArticlesSync: settings.downloadArticlesSync
    property alias mobileUserAgent: settings.mobileUserAgent
    property alias listSort: settings.listSort

    property alias article_fontSize: settings.article_fontSize
    property alias article_fontFamily: settings.article_fontFamily

    property bool wideScreen: width > units.gu(100)
    property bool loadedUI: false
    property bool isArticleOpen: false
    property bool isTagOpen: false
    property bool syncing: false
    property bool syncing_stopped: false

    // Reinit on visible
    property bool reinit_mylist_onvisible: false
    property bool reinit_articles_onvisible: false
    property bool reinit_images_onvisible: false
    property bool reinit_videos_onvisible: false
    property bool reinit_favorites_onvisible: false
    property bool reinit_archive_onvisible: false

    signal entryworksfinished(bool finished)
    signal networkerroroccured()
    signal itemaddingfinished()

    // Entry works finished
    Connections {
        target: mainView
        onEntryworksfinished: {
            if (!finished) {
                PopupUtils.open(syncingPopupComponent)
            }
        }
    }

    // Network error occured
    Connections {
        target: mainView
        onNetworkerroroccured: {
            PopupUtils.open(networkErrorPopupComponent)
        }
    }

    // Share to PockIt
    Connections {
        target: ContentHub
        onShareRequested: {
            var title = transfer.items[0]['title'];
            var url = transfer.items[0]['url'];

            PopupUtils.open(itemAddingPopupComponent)

            console.log(url)

            Scripts.add_item(url, title)
        }
    }
    Component {
        id: shareComponent
        ContentItem { }
    }

    // Share dialog for sharing url to other apps
    Component {
        id: shareDialog
        ContentShareDialog { }
    }

    // Navigation Menu Actions
    property list<Action> navActions: [
        Action {
            objectName: "myListTabAction"
            text: i18n.tr("My List")
            iconName: "view-list-symbolic"
            onTriggered: {
                pageLayout.replacePage(myListPage)
                if (reinit_mylist_onvisible) {
                    myListPage.home()
                }
            }
        },
        Action {
            objectName: "articlesTabAction"
            text: i18n.tr("Articles")
            iconSource: Qt.resolvedUrl("qml/images/blank.png")
            onTriggered: {
                pageLayout.replacePage(articlesPage)
                if (reinit_articles_onvisible) {
                    articlesPage.home()
                }
            }
        },
        Action {
            objectName: "videosTabAction"
            text: i18n.tr("Videos")
            iconSource: Qt.resolvedUrl("qml/images/blank.png")
            onTriggered: {
                pageLayout.replacePage(videosPage)
                if (reinit_videos_onvisible) {
                    videosPage.home()
                }
            }
        },
        Action {
            objectName: "imagesTabAction"
            text: i18n.tr("Images")
            iconSource: Qt.resolvedUrl("qml/images/blank.png")
            onTriggered: {
                pageLayout.replacePage(imagesPage)
                if (reinit_images_onvisible) {
                    imagesPage.home()
                }
            }
        },
        Action {
            objectName: "favoritesTabAction"
            text: i18n.tr("Favorites")
            iconName: "starred"
            onTriggered: {
                pageLayout.replacePage(favoritesPage)
                if (reinit_favorites_onvisible) {
                    favoritesPage.home()
                }
            }
        },
        Action {
            objectName: "archiveTabAction"
            text: i18n.tr("Archive")
            iconName: "tick"
            onTriggered: {
                pageLayout.replacePage(archivePage)
                if (reinit_archive_onvisible) {
                    archivePage.home()
                }
            }
        },
        Action {
            objectName: "tagsTabAction"
            text: i18n.tr("Tags")
            iconName: "tag"
            onTriggered: {
                pageLayout.replacePage(tagsPage)
            }
        }
    ]

    // Actions
    actions: [
        Action {
            id: searchAction
            text: i18n.tr("Search")
            keywords: i18n.tr("Search")
            iconName: "search"
            onTriggered: {
                isArticleOpen = false
                isTagOpen = false
                pageLayout.addPageToCurrentColumn(pageLayout.primaryPage, Qt.resolvedUrl("qml/ui/Search.qml"))
            }
        },
        Action {
            id: settingsAction
            text: i18n.tr("Settings")
            keywords: i18n.tr("Settings")
            iconName: "settings"
            onTriggered: {
                isArticleOpen = false
                isTagOpen = false
                pageLayout.addPageToCurrentColumn(pageLayout.primaryPage, Qt.resolvedUrl("qml/ui/Settings.qml"))
            }
        },
        Action {
            id: refreshAction
            text: syncing ? i18n.tr("Stop Refresh") : i18n.tr("Refresh")
            keywords: syncing ? i18n.tr("Stop Refresh") : i18n.tr("Refresh")
            iconName: "sync"
            onTriggered: {
                if (syncing) {
                    syncing_stopped = true
                } else {
                    Scripts.get_list()
                }
            }
        },
        Action {
            id: helpAction
            text: i18n.tr("Help")
            keywords: i18n.tr("Help")
            iconName: "help"
            onTriggered: {
                isArticleOpen = false
                isTagOpen = false
                pageLayout.addPageToCurrentColumn(pageLayout.primaryPage, Qt.resolvedUrl("qml/ui/Help.qml"))
            }
        }
    ]

    Component.onCompleted: {
        loadedUI = true

        //settings.firstRun = true

        init()
    }

    // Functions
    function init() {

        // If first run
        if (firstRun) {
            // Replace primary page with Walkthrough
            pageLayout.replacePageSource(Qt.resolvedUrl("qml/components/Walkthrough/FirstRunWalkthrough.qml"))
        } else {
            // Replace primary page with MyList
            pageLayout.replacePage(myListPage)

            // Login required
            if (!User.getKey('access_token')) {
                Scripts.get_request_token()
            } else {
                /**
                  * Sync queued items (tags, favs, archives, deletes, adds)
                  */

                if (autoSync) {
                    Scripts.get_list()
                }
            }
        }
    }

    // Re-initialize pages
    function reinit_pages(except) {
        myListPage.home()
        articlesPage.home()
        imagesPage.home()
        videosPage.home()
        favoritesPage.home()
        archivePage.home()
        if (!except || (except && except != 'tags')) {
            tagsPage.home()
        }
        tagEntriesPage.home()
    }

    // Workers
    // Sync Worker
    WorkerScript {
        id: sync_worker
        source: "qml/js/sync_worker.js"
        onMessage: {
            if (messageObject.action === "ENTRIES_WORKS") {
                Scripts.complete_entries_works(messageObject.entries_works, messageObject.api_entries)
            } else if (messageObject.action === "DELETE_WORKS") {
                Scripts.delete_works(messageObject.entries, messageObject.articles, messageObject.tags)
            }
        }
    }
    // Articles Sync Worker
    WorkerScript {
        id: articles_sync_worker
        source: "qml/js/articles_sync_worker.js"
        onMessage: {
            if (messageObject.action === "ARTICLES_WORKS") {
                Scripts.complete_articles_works(messageObject.article_result, messageObject.item_id, messageObject.finish, messageObject.parseArticle)
            } else if (messageObject.action === "LOOP_WORKS") {
                Scripts.get_article(messageObject.mustGetArticlesList, messageObject.index)
            }
        }
    }
    // Entries Worker
    WorkerScript {
        id: entries_worker
        source: "qml/js/entries_worker.js"
        onMessage: {

        }
    }
    // Tags Worker
    WorkerScript {
        id: tags_worker
        source: "qml/js/tags_worker.js"
        onMessage: {

        }
    }

    Timer {
        id: afterAddingTimer
        interval: 1000
        running: false
        repeat: false
        onTriggered: {
            Scripts.get_list()
        }
    }

    // Models
    // MyList
    ListModel {
        id: myListModel
    }
    // Articles
    ListModel {
        id: articlesListModel
    }
    ListModel {
        id: articlesArchiveListModel
    }
    // Images
    ListModel {
        id: imagesListModel
    }
    ListModel {
        id: imagesArchiveListModel
    }
    // Videos
    ListModel {
        id: videosListModel
    }
    ListModel {
        id: videosArchiveListModel
    }
    // Favorites
    ListModel {
        id: favoritesListModel
    }
    // Archive
    ListModel {
        id: archiveListModel
    }
    // Tags
    ListModel {
        id: tagsModel
    }
    // Tag Entries
    ListModel {
        id: tagEntriesModel
    }
    // Search
    ListModel {
        id: searchEntriesModel
    }

    AdaptivePageLayout {
        id: pageLayout
        anchors.fill: parent
        layouts: [
            PageColumnsLayout {
                when: wideScreen && ((isArticleOpen && !isTagOpen) || (!isArticleOpen && isTagOpen))
                PageColumn {
                    minimumWidth: units.gu(50)
                    maximumWidth: units.gu(70)
                    preferredWidth: units.gu(60)
                }
                PageColumn {
                    fillWidth: true
                }
            },
            PageColumnsLayout {
                when: wideScreen && isTagOpen && isArticleOpen
                PageColumn {
                    minimumWidth: units.gu(50)
                    maximumWidth: units.gu(70)
                    preferredWidth: units.gu(60)
                }
                PageColumn {
                    minimumWidth: units.gu(50)
                    maximumWidth: units.gu(70)
                    preferredWidth: units.gu(60)
                }
                PageColumn {
                    fillWidth: true
                }
            }
        ]

        // Pages
        Ui.MyList {
            id: myListPage
        }
        Ui.Articles {
            id: articlesPage
        }
        Ui.Images {
            id: imagesPage
        }
        Ui.Videos {
            id: videosPage
        }
        Ui.Favorites {
            id: favoritesPage
        }
        Ui.Archive {
            id: archivePage
        }
        Ui.Tags {
            id: tagsPage
        }

        Ui.ArticleViewPage {
            id: articleViewPage
            visible: false
        }

        Ui.TagEntriesList {
            id: tagEntriesPage
            visible: false
        }

        Ui.ItemTagsEdit {
            id: itemTagsPage
            visible: false
        }

        // Functions
        function replacePageSource(pageSource) {
            pageLayout.removePages(pageLayout.primaryPage)
            isArticleOpen = false
            isTagOpen = false
            pageLayout.primaryPageSource = pageSource
        }

        function replacePage(pageId) {
            pageLayout.removePages(pageLayout.primaryPage)
            isArticleOpen = false
            isTagOpen = false
            pageLayout.primaryPage = pageId
        }
    }

    onWidthChanged: {
        if (pageLayout.columns > 2 && isArticleOpen && isTagOpen) {
            isArticleOpen = false
            pageLayout.addPageToNextColumn(tagsPage, tagEntriesPage)
        }
    }

    LoadingSpinnerComponent {
        id: loading
    }

    // Syncing popup component
    Component {
        id: syncingPopupComponent
        LoadingSpinnerPopup {
            spinner_text: i18n.tr("Retrieving your list...")
        }
    }

    // Network error popup component
    Component {
        id: networkErrorPopupComponent
        ErrorPopup {
            error_text: i18n.tr("Sync error")
            error_subtitle_text: i18n.tr("Please check your network settings.")
        }
    }

    // Tag rename popup component
    Component {
        id: tagRenamePopupComponent
        TagRenamePopup { }
    }

    // Item add popup component
    Component {
        id: itemAddingPopupComponent
        ItemAddingPopup {
            adding_text: i18n.tr("Adding...")
        }
    }
}
