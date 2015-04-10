import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("Foodiary")
    }

    CoverPlaceholder {
        icon.source: "Foodiary.png"
    }

    CoverActionList {
        id: coverAction
        // icons found in /usr/share/themes/jolla-ambient/meegotouch/icons/
//        CoverAction {
//            iconSource: "image://theme/icon-cover-location"
//            onTriggered: {
//                //PageStack.push("Statistics.qml")
//            }
//        }

//        CoverAction {
//            iconSource: "image://theme/icon-cover-new"
//            onTriggered: {

//            }

//        }
    }
}


