import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: firstTime
    SilicaFlickable {
        anchors.fill: parent

        Column {
            width: parent.width

            PageHeader {
                title: "Welcome"
            }

            Label{
                text: "Please give a name to start using this app"
            }

            TextField {
                id: other
                width: parent.width
                placeholderText: "Sam Burger"
                label: "Name"
                focusOnClick: true

                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: start()
            }

            Button {
                id: btnStart
                width: parent.width
                text: "Start"
                onClicked: start()
            }

            function start() {
                pageStack.pop("DiaryPage.qml")
            }
        }
    }
}





