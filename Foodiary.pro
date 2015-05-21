# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = Foodiary

CONFIG += sailfishapp

SOURCES += \
    Foodiary.cpp \
    reportwriter.cpp

OTHER_FILES += qml/Foodiary.qml \
    qml/cover/CoverPage.qml \
    rpm/Foodiary.changes.in \
    rpm/Foodiary.spec \
    rpm/Foodiary.yaml \
    translations/*.ts \
    Foodiary.desktop \
    qml/pages/Settings.qml \
    qml/pages/DiaryPage.qml \
    qml/pages/Statistics.qml \
    qml/pages/PhotoPicker.qml \
    qml/pages/ImagePage.qml \
    qml/pages/Camera.qml \
    qml/cover/Foodiary.jpg \
    qml/cover/Foodiary.png \
    Foodiary.png \
    qml/pages/FirstTime.qml \
    qml/pages/SwipeArea.qml \
    Foodiary.jpg \
    qml/pages/Report.qml \
    TODO.txt \
    qml/pages/Users.qml \
    qml/pages/Locations.qml \
    qml/pages/Meals.qml \
    qml/pages/ExtraTools.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/Foodiary-de.ts

HEADERS += \
    reportwriter.h

