TEMPLATE = aux
TARGET = PockIt

RESOURCES += PockIt.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  PockIt.apparmor \
               content.json \
               PockIt.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)

IMG_FILES += $$files(*.png,true)

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               PockIt.desktop

#specify where the qml/js files are installed to
qml_files.path = /PockIt
qml_files.files += $${QML_FILES}

js_files.path = /PockIt/js
js_files.files += $${QML_FILES}

ui_files.path = /PockIt/ui
ui_files.files += $${QML_FILES}

components_files.path = /PockIt/components
components_files.files += $${QML_FILES}

img_files.path = /PockIt/img
img_files.files += $${IMG_FILES}

themes_files.path = /PockIt/themes
themes_files.files +=$${QML_FILES}

#specify where the config files are installed to
config_files.path = /PockIt
config_files.files += $${CONF_FILES}

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /PockIt
desktop_file.files = $$OUT_PWD/PockIt.desktop
desktop_file.CONFIG += no_check_exist

INSTALLS+=config_files qml_files js_files ui_files components_files img_files themes_files desktop_file

DISTFILES += \
    ui/About.qml \
    ui/Settings.qml \
    ui/Search.qml \
    scripts/scripts.js \
    ui/Login.qml \
    scripts/localdb.js \
    js/user.js \
    components/ContentShareDialog.qml \
    img/play.png \
    ui/MyListTab.qml \
    ui/FavListTab.qml \
    ui/ArchiveListTab.qml \
    components/StatusBar.qml \
    components/EmptyBar.qml \
    components/DownloadingPopup.qml \
    themes/ThemeManager.qml \
    themes/Dark.qml \
    themes/Light.qml \
    ui/Help.qml \
    components/ArticleStyles.qml \
    ui/TagsListTab.qml \
    ui/TagEntriesPage.qml \
    ui/EntryTagsPage.qml \
    components/TagEditDialog.qml \
    components/InfoDialog.qml \
    components/TabsList.qml

