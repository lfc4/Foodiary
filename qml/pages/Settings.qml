import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: settings

    ListModel {
        id: lm
        ListElement {
            title: "Users"
            page: "Users.qml"
        }
        ListElement {
            title: "Locations"
             page: "Locations.qml"
        }
        ListElement {
            title: "Predefined meals"
             page: "Meals.qml"
        }
        ListElement {
            title: "Extra"
             page: "ExtraTools.qml"
        }
    }
    SilicaListView {
        id: listView
        anchors.fill: parent
        model: lm
        header: PageHeader { title: "Settings" }

        delegate: BackgroundItem {
            width: listView.width
            Label {
                id: firstName
                text: model.title
                color: highlighted ? Theme.highlightColor : Theme.primaryColor
                anchors.verticalCenter: parent.verticalCenter
                x: Theme.paddingLarge
            }
            onClicked: pageStack.push(Qt.resolvedUrl(page))
        }
        VerticalScrollDecorator {}
    }
}

//    property bool saveUserChanges: false
//    property bool addUser: false
//    property bool addLocation: false

//    function clearUserValues(){
//        newName.text = ""
//        age.text = ""
//        weight.text = ""
//        lenght.text = ""
//        type.text = ""
//    }

//    function clearLocationValues(){
//        newLocationName.text = ""
//        description.text = ""
//        coordinates.text = ""
//    }

////    SilicaFlickable {
//        anchors.fill: parent
//        contentHeight: col.height

//        Column {
//            id: col
//            width: parent.width

//            PageHeader {
//                title: "Settings"
//            }

////            SectionHeader {
////                text: "Mange users"
////            }

////            ComboBox {
////                id: name
////                width: parent.width
////                label: "Name"
////                currentIndex: foodiary.currentUser - 1

////                menu: ContextMenu {
////                    Repeater {
////                        model: foodiary.users
////                        MenuItem { text: model.name }
////                    }
////                }
////            }

////            TextField {
////                id: newName
////                width: parent.width
////                placeholderText: "New name"
////                label: "Name"
////                focusOnClick: true
////                visible: false

////                EnterKey.iconSource: "image://theme/icon-m-enter-next"
////                EnterKey.onClicked: age.focus = true

////                onTextChanged: {
////                    save.enabled = true
////                }
////            }

////            TextField {
////                id: age
////                width: parent.width
////                placeholderText: "Age(year)"
////                inputMethodHints: Qt.ImhFormattedNumbersOnly
////                label: "Age(year)"
////                focusOnClick: true
////                text: foodiary.users.get(name.currentIndex).age

////                EnterKey.iconSource: "image://theme/icon-m-enter-next"
////                EnterKey.onClicked: weight.focus = true

////                onTextChanged: {
////                    save.enabled = true
////                }
////            }

////            TextField {
////                id: weight
////                width: parent.width
////                placeholderText: "Weight(kg)"
////                inputMethodHints: Qt.ImhFormattedNumbersOnly
////                label: "Weight(kg)"
////                focusOnClick: true
////                text: foodiary.users.get(name.currentIndex).weight

////                EnterKey.iconSource: "image://theme/icon-m-enter-next"
////                EnterKey.onClicked: lenght.focus = true

////                onTextChanged: {
////                    save.enabled = true
////                }
////            }

////            TextField {
////                id: lenght
////                width: parent.width
////                placeholderText: "Length(cm)"
////                inputMethodHints: Qt.ImhFormattedNumbersOnly
////                label: "Length(cm)"
////                focusOnClick: true
////                text: foodiary.users.get(name.currentIndex).length

////                EnterKey.iconSource: "image://theme/icon-m-enter-next"
////                EnterKey.onClicked: type.focus = true

////                onTextChanged: {
////                    save.enabled = true
////                }
////            }

////            TextField {
////                id: type
////                width: parent.width
////                placeholderText: "Type"
////                label: "Type"
////                focusOnClick: true
////                text: foodiary.users.get(name.currentIndex).type

////                EnterKey.iconSource: "image://theme/icon-m-enter-close"
////                EnterKey.onClicked: focus = false

////                onTextChanged: {
////                    save.enabled = true
////                }
////            }

////            Row{
////                id:userbuttons
////                width: parent.width

////                Button{
////                    id: save
////                    width: parent.width/2
////                    text: "Save"
////                    enabled: false

////                    onClicked: {
////                        if(addUser == true)
////                        {
////                            foodiary.saveUser(newName.text, age.text, "", parseFloat(weight.text) , parseFloat(lenght.text), type.text)
////                            foodiary.getUsers()
////                            save.enabled = false
////                            addUser = false
////                            name.visible = true
////                            newName.visible = false
////                            name.currentIndex = foodiary.users.count - 1
////                        }
////                        else
////                        {
////                            foodiary.updateUser(foodiary.users.get(name.currentIndex).id, foodiary.users.get(name.currentIndex).name, age.text, "", parseFloat(weight.text) , parseFloat(lenght.text), type.text)
////                            foodiary.getUsers()
////                            name.currentIndex = foodiary.currentUser - 1
////                            save.enabled = false
////                        }
////                    }
////                }
////                Button{
////                    id: add
////                    width: parent.width/2
////                    text: "New"
////                    enabled: true

////                    onClicked: {
////                        clearUserValues()
////                        addUser = true
////                        name.visible = false
////                        newName.visible = true
////                        newName.focus = true
////                    }
////                }
////            }

////            SectionHeader {
////                text: "Mange locations"
////            }

////            ComboBox {
////                id: locationName
////                width: parent.width
////                label: "Location"
////                currentIndex: 0

////                menu: ContextMenu {
////                    Repeater {
////                        model: foodiary.locations
////                        MenuItem { text: model.name }
////                    }
////                }
////            }

////            TextField {
////                id: newLocationName
////                width: parent.width
////                placeholderText: "New location"
////                label: "Location"
////                focusOnClick: true
////                visible: false

////                EnterKey.iconSource: "image://theme/icon-m-enter-next"
////                EnterKey.onClicked: description.focus = true

////                onTextChanged: {
////                    saveLocation.enabled = true
////                }
////            }

////            TextField {
////                id: description
////                width: parent.width
////                placeholderText: "Description"
////                label: "Description"
////                focusOnClick: true
////                text: foodiary.locations.get(locationName.currentIndex).description

////                EnterKey.iconSource: "image://theme/icon-m-enter-next"
////                EnterKey.onClicked: coordinates.focus = true

////                onTextChanged: {
////                    saveLocation.enabled = true
////                }
////            }

////            TextField {
////                id: coordinates
////                width: parent.width
////                placeholderText: "Cords"
////                label: "Cords"
////                focusOnClick: true
////                text: foodiary.locations.get(locationName.currentIndex).coordinates

////                EnterKey.iconSource: "image://theme/icon-m-enter-close"
////                EnterKey.onClicked: coordinates.focus = false

////                onTextChanged: {
////                    saveLocation.enabled = true
////                }
////            }

////            Row{
////                id: locationbuttons
////                width: parent.width

////                Button{
////                    id: saveLocation
////                    width: parent.width/2
////                    text: "Save"
////                    enabled: false

////                    onClicked: {
////                        if(addLocation == true)
////                        {
////                            foodiary.saveLocation(newLocationName.text, description.text, coordinates.text)
////                            foodiary.getLocations()
////                            saveLocation.enabled = false
////                            addLocation = false
////                            locationName.visible = true
////                            newLocationName.visible = false
////                            locationName.currentIndex = 0
////                        }
////                        else
////                        {
////                            foodiary.updateLocation(foodiary.locations.get(locationName.currentIndex).id, foodiary.locations.get(locationName.currentIndex).name, description.text, coordinates.text)
////                            foodiary.getLocations()
////                            saveLocation.enabled = false
////                        }
////                    }
////                }
////                Button{
////                    id: addLocationName
////                    width: parent.width/2
////                    text: "New"
////                    enabled: true

////                    onClicked: {
////                        clearLocationValues()
////                        addLocation = true
////                        locationName.visible = false
////                        newLocationName.visible = true
////                        newLocationName.focus = true
////                    }
////                }
////            }

//            SectionHeader {
//                text: "Mange meals"
//            }

//            Button {
//                width: parent.width
//                text: "Manage meals"
//            }

//            SectionHeader {
//                text: "Debug tools"
//            }


//        }
//    }
//}





