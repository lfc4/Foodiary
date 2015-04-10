import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: extra

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu {
            MenuItem {
                text: "About"
                onClicked: {

                }
            }
        }

    Column {
        id: colud
        width: parent.width

        PageHeader {
            title: "Extra"
        }

        Button{
            id: clearDB
            width: parent.width
            text: "Clear DB"
            enabled: true

            onClicked: {
                foodiary.clearDB()
            }
        }
        Button{
            id: clearLocations
            width: parent.width
            text: "Clear Locations"
            enabled: true

            onClicked: {
                foodiary.clearLocations()
                clearLocationValues()
                saveLocation.enabled = false
            }
        }

        TextField {
            id: command
            width: parent.width
        }

        Button{
            id: runcmd
            width: parent.width
            text: "Run sql"

            onClicked: {
                foodiary.runCmd(command.text)
            }
        }
    }
}
}
