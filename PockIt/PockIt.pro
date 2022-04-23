TEMPLATE = app
TARGET = PockIt

load(ubuntu-click)

QT += qml quick

SOURCES += main.cpp

RESOURCES += PockIt.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  PockIt.apparmor \
               PockIt.png \
               content.json

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)

#show all the files in QtCreator
OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               PockIt.desktop

#specify where the config files are installed to
config_files.path = /PockIt
config_files.files += $${CONF_FILES}
INSTALLS+=config_files

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /PockIt
desktop_file.files = $$OUT_PWD/PockIt.desktop
desktop_file.CONFIG += no_check_exist
INSTALLS+=desktop_file

# Default rules for deployment.
#target.path = /opt/$${TARGET}/bin
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target

DISTFILES += \
    qml/ui/Favorites.qml \
    qml/ui/Archive.qml \
    qml/ui/Tags.qml \
    content.json
