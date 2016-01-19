QT += widgets multimedia sql

TEMPLATE = app

include(qtsingleapplication/qtsingleapplication.pri)

SOURCES += debug/logbrowser.cpp \
    debug/logbrowserdialog.cpp \
    dialogs/colordialog.cpp \
    dialogs/customizeoptionsdialog.cpp \
    dialogs/customizethemedialog.cpp \
    dialogs/customizethemetaglineedit.cpp \
    dialogs/dragdropdialog.cpp \
    dialogs/equalizerdalog.cpp \
    dialogs/playlistdialog.cpp \
    dialogs/reflector.cpp \
    dialogs/searchdialog.cpp \
    dialogs/starswidget.cpp \
    filesystem/addressbar.cpp \
    filesystem/addressbarbutton.cpp \
    filesystem/addressbardirectorylist.cpp \
    filesystem/addressbarlineedit.cpp \
    filesystem/addressbarmenu.cpp \
    filesystem/filesystemtreeview.cpp \
    styling/miamstyle.cpp \
    tageditor/albumcover.cpp \
    tageditor/tagconverter.cpp \
    tageditor/tageditor.cpp \
    tageditor/tageditortablewidget.cpp \
    columnutils.cpp \
    main.cpp \
    mainwindow.cpp \
    pluginmanager.cpp \
    quickstart.cpp \
    tagbutton.cpp \
    taglineedit.cpp \
    tracksnotfoundmessagebox.cpp

HEADERS += debug/logbrowser.h \
    debug/logbrowserdialog.h \
    dialogs/colordialog.h \
    dialogs/customizeoptionsdialog.h \
    dialogs/customizethemedialog.h \
    dialogs/customizethemetaglineedit.h \
    dialogs/dragdropdialog.h \
    dialogs/equalizerdalog.h \
    dialogs/paintablewidget.h \
    dialogs/playlistdialog.h \
    dialogs/reflector.h \
    dialogs/searchdialog.h \
    dialogs/starswidget.h \
    filesystem/addressbar.h \
    filesystem/addressbarbutton.h \
    filesystem/addressbardirectorylist.h \
    filesystem/addressbarlineedit.h \
    filesystem/addressbarmenu.h \
    filesystem/filesystemtreeview.h \
    styling/miamstyle.h \
    tageditor/albumcover.h \
    tageditor/tagconverter.h \
    tageditor/tageditor.h \
    tageditor/tageditortablewidget.h \
    columnutils.h \
    mainwindow.h \
    nofocusitemdelegate.h \
    pluginmanager.h \
    quickstart.h \
    tagbutton.h \
    taglineedit.h \
    tracksnotfoundmessagebox.h

FORMS += customizeoptionsdialog.ui \
    customizetheme.ui \
    dragdroppopup.ui \
    equalizerdialog.ui \
    mainwindow.ui \
    playlistdialog.ui \
    quickstart.ui \
    searchdialog.ui \
    tagconverter.ui \
    tageditor.ui

RESOURCES += mp.qrc
CONFIG += c++11
win32 {
    OTHER_FILES += config/mp.rc
    RC_FILE += config/mp.rc
    TARGET = MiamPlayer
}
unix {
    #QMAKE_CXXFLAGS += -std=c++11
}
unix:!macx {
    TARGET = miam-player
}
macx {
    TARGET = MiamPlayer
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.9
}

TRANSLATIONS = translations/m4p_ar.ts \
    translations/m4p_cs.ts \
    translations/m4p_de.ts \
    translations/m4p_en.ts \
    translations/m4p_es.ts \
    translations/m4p_fr.ts \
    translations/m4p_in.ts \
    translations/m4p_it.ts \
    translations/m4p_ja.ts \
    translations/m4p_kr.ts \
    translations/m4p_pt.ts \
    translations/m4p_ru.ts \
    translations/m4p_th.ts \
    translations/m4p_vn.ts \
    translations/m4p_zh.ts

CONFIG(debug, debug|release) {
    win32 {
	!contains(QMAKE_TARGET.arch, x86_64) {
	    LIBS += -L$$PWD/../../lib/debug/win-x86/ -ltag
	    LIBS += -L$$OUT_PWD/../MiamCore/debug/ -lMiamCore
	    LIBS += -L$$OUT_PWD/../MiamLibrary/debug/ -lMiamLibrary
	    LIBS += -L$$OUT_PWD/../MiamTabPlaylists/debug/ -lMiamTabPlaylists
	    LIBS += -L$$OUT_PWD/../MiamUniqueLibrary/debug/ -lMiamUniqueLibrary
	    QMAKE_POST_LINK += $${QMAKE_COPY} $$shell_path($$PWD/mp.ico) $$shell_path($$OUT_PWD/debug/)
	} else {
	    LIBS += -L$$PWD/../../lib/debug/win-x64/ -ltag
	    LIBS += -L$$OUT_PWD/../MiamCore/debug/ -lMiamCore
	    LIBS += -L$$OUT_PWD/../MiamLibrary/debug/ -lMiamLibrary
	    LIBS += -L$$OUT_PWD/../MiamTabPlaylists/debug/ -lMiamTabPlaylists
	    LIBS += -L$$OUT_PWD/../MiamUniqueLibrary/debug/ -lMiamUniqueLibrary
	    QMAKE_POST_LINK += $${QMAKE_COPY} $$shell_path($$PWD/mp.ico) $$shell_path($$OUT_PWD/debug/)
	}
    }
    OBJECTS_DIR = debug/.obj
    MOC_DIR = debug/.moc
    RCC_DIR = debug/.rcc
    UI_DIR = $$PWD
}

CONFIG(release, debug|release) {
    win32 {
	!contains(QMAKE_TARGET.arch, x86_64) {
	    LIBS += -L$$PWD/../../lib/release/win-x86/ -ltag
	    LIBS += -L$$OUT_PWD/../MiamCore/release/ -lMiamCore
	    LIBS += -L$$OUT_PWD/../MiamLibrary/release/ -lMiamLibrary
	    LIBS += -L$$OUT_PWD/../MiamTabPlaylists/release/ -lMiamTabPlaylists
	    LIBS += -L$$OUT_PWD/../MiamUniqueLibrary/release/ -lMiamUniqueLibrary
	    QMAKE_POST_LINK += $${QMAKE_COPY} $$shell_path($$PWD/mp.ico) $$shell_path($$OUT_PWD/release/)
	} else {
	    LIBS += -L$$PWD/../../lib/release/win-x64/ -ltag
	    LIBS += -L$$OUT_PWD/../MiamCore/release/ -lMiamCore
	    LIBS += -L$$OUT_PWD/../MiamLibrary/release/ -lMiamLibrary
	    LIBS += -L$$OUT_PWD/../MiamTabPlaylists/release/ -lMiamTabPlaylists
	    LIBS += -L$$OUT_PWD/../MiamUniqueLibrary/release/ -lMiamUniqueLibrary
	    QMAKE_POST_LINK += $${QMAKE_COPY} $$shell_path($$PWD/mp.ico) $$shell_path($$OUT_PWD/release/)
	}
    }
    OBJECTS_DIR = release/.obj
    MOC_DIR = release/.moc
    RCC_DIR = release/.rcc
    UI_DIR = $$PWD
}
unix {
    LIBS += -ltag -L$$OUT_PWD/../MiamCore/ -lmiam-core
    LIBS += -L$$OUT_PWD/../MiamLibrary/ -lmiam-library
    LIBS += -L$$OUT_PWD/../MiamTabPlaylists/ -lmiam-tabplaylists
    LIBS += -L$$OUT_PWD/../MiamUniqueLibrary/ -lmiam-uniquelibrary
}
unix:!macx {
    target.path = /usr/bin
    desktop.path = /usr/share/applications
    desktop.files = $$PWD/../../debian/usr/share/applications/miam-player.desktop
    icon64.path = /usr/share/icons/hicolor/64x64/apps
    icon64.files = $$PWD/../../debian/usr/share/icons/hicolor/64x64/apps/application-x-miamplayer.png

    INSTALLS += desktop \
	target \
	icon64
}
macx {
    ICON = $$PWD/../../osx/MiamPlayer.icns
    QMAKE_SONAME_PREFIX = @executable_path/../Frameworks
    #1 create Framework and PlugIns directories
    #2 copy third party library: TagLib, QtAV
    #3 copy own libs
    QMAKE_POST_LINK += $${QMAKE_MKDIR} $$shell_path($$OUT_PWD/MiamPlayer.app/Contents/Frameworks/) && \
     $${QMAKE_MKDIR} $$shell_path($$OUT_PWD/MiamPlayer.app/Contents/PlugIns/) && \
     $${QMAKE_COPY} $$shell_path($$PWD/../../lib/osx/libtag.dylib) $$shell_path($$OUT_PWD/MiamPlayer.app/Contents/Frameworks/) && \
     $${QMAKE_COPY} $$shell_path($$OUT_PWD/../MiamCore/libmiam-core.*.dylib) $$shell_path($$OUT_PWD/MiamPlayer.app/Contents/Frameworks/) && \
     $${QMAKE_COPY} $$shell_path($$OUT_PWD/../MiamLibrary/libmiam-library.*.dylib) $$shell_path($$OUT_PWD/MiamPlayer.app/Contents/Frameworks/) && \
     $${QMAKE_COPY} $$shell_path($$OUT_PWD/../MiamTabPlaylists/libmiam-tabplaylists.*.dylib) $$shell_path($$OUT_PWD/MiamPlayer.app/Contents/Frameworks/) && \
     $${QMAKE_COPY} $$shell_path($$OUT_PWD/../MiamUniqueLibrary/libmiam-uniquelibrary.*.dylib) $$shell_path($$OUT_PWD/MiamPlayer.app/Contents/Frameworks/)
}

3rdpartyDir  = $$PWD/../MiamCore/3rdparty
INCLUDEPATH += $$3rdpartyDir
DEPENDPATH += $$3rdpartyDir

INCLUDEPATH += $$PWD/dialogs $$PWD/filesystem $$PWD/playlists $$PWD/tageditor
INCLUDEPATH += $$PWD/../MiamCore
INCLUDEPATH += $$PWD/../MiamLibrary
INCLUDEPATH += $$PWD/../MiamTabPlaylists
INCLUDEPATH += $$PWD/../MiamUniqueLibrary

DEPENDPATH += $$PWD/dialogs $$PWD/filesystem $$PWD/playlists $$PWD/tageditor
DEPENDPATH += $$PWD/../MiamCore
DEPENDPATH += $$PWD/../MiamLibrary
DEPENDPATH += $$PWD/../MiamTabPlaylists
DEPENDPATH += $$PWD/../MiamUniqueLibrary
