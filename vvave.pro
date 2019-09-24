QT       += quick
QT       += multimedia
QT       += sql
QT       += websockets
QT       += network
QT       += xml
QT       += qml
QT       += widgets
QT       += quickcontrols2
QT       += concurrent

TARGET = vvave
TEMPLATE = app

CONFIG += ordered
CONFIG += c++11
QMAKE_LINK += -nostdlib++

linux:unix:!android {
    message(Building for Linux KDE)
    include($$PWD/kde/kde.pri)
    LIBS += -lMauiKit

} else:android {
    message(Building helpers for Android)
    QT += androidextras webview
    include($$PWD/3rdparty/taglib.pri)
    include($$PWD/3rdparty/kirigami/kirigami.pri)
    include($$PWD/3rdparty/mauikit/mauikit.pri)

    DEFINES += STATIC_KIRIGAMI

} else {
    message("Unknown configuration")
}

include(pulpo/pulpo.pri)

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += main.cpp \
    db/collectionDB.cpp \
    services/local/taginfo.cpp \
    services/local/player.cpp \
#    utils/brain.cpp \
    services/local/socket.cpp \
    services/web/youtube.cpp \
    vvave.cpp \
    services/local/youtubedl.cpp \
    services/local/linking.cpp \
    services/web/Spotify/spotify.cpp \
    models/tracks/tracksmodel.cpp \
    models/basemodel.cpp \
    models/baselist.cpp \
    models/playlists/playlistsmodel.cpp \
    models/albums/albumsmodel.cpp \
    models/cloud/cloud.cpp


RESOURCES += qml.qrc \

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =


HEADERS += \
    db/collectionDB.h \
    utils/bae.h \
    settings/fileloader.h \
    services/local/taginfo.h \
    services/local/player.h \
    utils/brain.h \
    services/local/socket.h \
    services/web/youtube.h \
    vvave.h \
    services/local/youtubedl.h \
    services/local/linking.h \
    services/web/Spotify/spotify.h \
    models/tracks/tracksmodel.h \
    models/basemodel.h \
    models/baselist.h \
    models/playlists/playlistsmodel.h \
    models/albums/albumsmodel.h \
    models/cloud/cloud.h

include(install.pri)

#TAGLIB


#INCLUDEPATH += /usr/include/python3.6m

#LIBS += -lpython3.6m
#defineReplace(copyToDir) {
#    files = $$1
#    DIR = $$2
#    LINK =

#    for(FILE, files) {
#        LINK += $$QMAKE_COPY $$shell_path($$FILE) $$shell_path($$DIR) $$escape_expand(\\n\\t)
#    }
#    return($$LINK)
#}

#defineReplace(copyToBuilddir) {
#    return($$copyToDir($$1, $$OUT_PWD))
#}

## Copy the binary files dependent on the system architecture
#unix:!macx {
#    message("Linux")
#    QMAKE_POST_LINK += $$copyToBuilddir($$PWD/library/cat)
#}

DISTFILES += \
    3rdparty/mauikit/src/android/AndroidManifest.xml \
    3rdparty/mauikit/src/android/build.gradle \
    3rdparty/mauikit/src/android/build.gradle \
    3rdparty/mauikit/src/android/gradle/wrapper/gradle-wrapper.jar \
    3rdparty/mauikit/src/android/gradle/wrapper/gradle-wrapper.jar \
    3rdparty/mauikit/src/android/gradle/wrapper/gradle-wrapper.properties \
    3rdparty/mauikit/src/android/gradle/wrapper/gradle-wrapper.properties \
    3rdparty/mauikit/src/android/gradlew \
    3rdparty/mauikit/src/android/gradlew \
    3rdparty/mauikit/src/android/gradlew.bat \
    3rdparty/mauikit/src/android/gradlew.bat \
    3rdparty/mauikit/src/android/res/values/libs.xml \
    3rdparty/mauikit/src/android/res/values/libs.xml

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_PACKAGE_SOURCE_DIR = \
        $$PWD/3rdparty/mauikit/src/android
}


