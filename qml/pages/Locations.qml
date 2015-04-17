import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: addLoca
    property bool saveLocationChanges: false
    property bool addLocation: false

    function clearLocationValues(){
        newLocationName.text = ""
        description.text = ""
        coordinates.text = ""
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: colum.height

        PullDownMenu {
            MenuItem {
                text: "Delete"
                onClicked: {
                    foodiary.deleteLocation(locationName.currentIndex + 1)
                    foodiary.getLocations()
                    locationName.currentIndex = 0
                }
            }
            MenuItem {
                text: "New"
                onClicked: {
                    clearLocationValues()
                    addLocation = true
                    locationName.visible = false
                    newLocationName.visible = true
                    newLocationName.focus = true
                    description.text = ""
                }
            }
            MenuItem {
                text: "Save"
                onClicked: {
                    if(addLocation == true)
                    {
                        foodiary.saveLocation(newLocationName.text, description.text, coordinates.text)
                        foodiary.getLocations()

                        addLocation = false
                        locationName.visible = true
                        newLocationName.visible = false
                        locationName.currentIndex = 0
                    }
                    else
                    {
                        foodiary.updateLocation(foodiary.locations.get(locationName.currentIndex).id, foodiary.locations.get(locationName.currentIndex).name, description.text, coordinates.text)
                        foodiary.getLocations()
                        locationName.currentIndex = 0
                    }
                }
            }
        }
        Column {
            id: colum
            width: parent.width

            PageHeader {
                title: "Locations"
            }

            ComboBox {
                id: locationName
                width: parent.width
                label: "Location"
                currentIndex: 0

                menu: ContextMenu {
                    Repeater {
                        model: foodiary.locations
                        MenuItem { text: model.name }
                    }
                }
            }

            TextField {
                id: newLocationName
                width: parent.width
                placeholderText: "New location"
                label: "Location"
                focusOnClick: true
                visible: false

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: description.focus = true

                onTextChanged: {
                    saveLocationChanges = true
                }
            }

            TextField {
                id: description
                width: parent.width
                placeholderText: "Description"
                label: "Description"
                focusOnClick: true
                text: foodiary.locations.get(locationName.currentIndex).description

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: coordinates.focus = true

                onTextChanged: {
                    saveLocationChanges = true
                }
            }

            TextField {
                id: coordinates
                width: parent.width
                placeholderText: "Cords"
                label: "Cords"
                focusOnClick: true
                text: foodiary.locations.get(locationName.currentIndex).coordinates

                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: coordinates.focus = false

                onTextChanged: {
                    saveLocationChanges = true
                }
            }

//            Row{
//                id: locationbuttons
//                width: parent.width

//                Button{
//                    id: saveLocation
//                    width: parent.width/2
//                    text: "Save"
//                    enabled: false

//                    onClicked: {
//                        if(addLocation == true)
//                        {
//                            foodiary.saveLocation(newLocationName.text, description.text, coordinates.text)
//                            foodiary.getLocations()
//                            saveLocation.enabled = false
//                            addLocation = false
//                            locationName.visible = true
//                            newLocationName.visible = false
//                            locationName.currentIndex = 0
//                        }
//                        else
//                        {
//                            foodiary.updateLocation(foodiary.locations.get(locationName.currentIndex).id, foodiary.locations.get(locationName.currentIndex).name, description.text, coordinates.text)
//                            foodiary.getLocations()
//                            saveLocation.enabled = false
//                        }
//                    }
//                }
//                Button{
//                    id: addLocationName
//                    width: parent.width/2
//                    text: "New"
//                    enabled: true

//                    onClicked: {
//                        clearLocationValues()
//                        addLocation = true
//                        locationName.visible = false
//                        newLocationName.visible = true
//                        newLocationName.focus = true
//                    }
//                }
//            }

        }
    }
}
