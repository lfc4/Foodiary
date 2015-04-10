import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: imagePage
    property alias currentIndex: listView.currentIndex
    property alias model: listView.model

    // List view with Sailfish Silica specific behaviour
    SilicaListView {
        id: listView
        clip: true
        snapMode: ListView.SnapOneItem
        orientation: ListView.HorizontalFlick
        highlightRangeMode: ListView.StrictlyEnforceRange
        cacheBuffer: width

        anchors.fill: parent

        delegate: Item {
            width: listView.width
            height: listView.height
            clip: true

            Image {
                source: url
                fillMode: Image.PreserveAspectFit
                sourceSize.height: window.height * 2
                asynchronous: true
                anchors.fill: parent
            }
        }
    }
}


