import QtQuick 2.2
import Sailfish.Silica 1.0

Page {
    id: addUsr
    property bool saveUserChanges: false
    property bool addNewUser: false

    function clearUserValues(){
        newName.text = ""
        age.text = ""
        weight.text = ""
        lenght.text = ""
        type.text = ""
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: cm.height

        PullDownMenu {
            MenuItem {
                text: "New"
                onClicked: {
                    clearUserValues()
                    addNewUser = true
                    name.visible = false
                    newName.visible = true
                    newName.focus = true
                }
            }
            MenuItem {
                text: "Save"
                onClicked: {
                    if(addNewUser == true)
                    {
                        foodiary.saveUser(newName.text, age.text, "", parseFloat(weight.text) , parseFloat(lenght.text), type.text)
                        foodiary.getUsers()
                        addNewUser = false
                        name.visible = true
                        newName.visible = false
                        name.currentIndex = foodiary.users.count - 1
                    }
                    else
                    {
                        foodiary.updateUser(foodiary.users.get(name.currentIndex).id, foodiary.users.get(name.currentIndex).name, age.text, "", parseFloat(weight.text) , parseFloat(lenght.text), type.text)
                        foodiary.getUsers()
                        name.currentIndex = foodiary.currentUser - 1
                    }
                }
            }
            MenuItem {
                text: "Delete"
                onClicked: {
                    foodiary.deleteUser(foodiary.users.get(name.currentIndex).id)
                }
            }
        }

        Column {
            id: cm
            width: parent.width

            PageHeader {
                title: "Users"
            }

            ComboBox {
                id: name
                width: parent.width
                label: "Name"
                currentIndex: foodiary.currentUser - 1

                menu: ContextMenu {
                    Repeater {
                        model: foodiary.users
                        MenuItem { text: model.name }
                    }
                }
            }

            TextField {
                id: newName
                width: parent.width
                placeholderText: "New name"
                label: "Name"
                focusOnClick: true
                visible: false

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: age.focus = true

                onTextChanged: {
                    saveUserChanges = true
                }
            }

            TextField {
                id: age
                width: parent.width
                placeholderText: "Age(year)"
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                label: "Age(year)"
                focusOnClick: true
                text: foodiary.users.get(name.currentIndex).age

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: weight.focus = true

                onTextChanged: {
                    saveUserChanges = true
                }
            }

            TextField {
                id: weight
                width: parent.width
                placeholderText: "Weight(kg)"
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                label: "Weight(kg)"
                focusOnClick: true
                text: foodiary.users.get(name.currentIndex).weight

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: lenght.focus = true

                onTextChanged: {
                    saveUserChanges = true
                }
            }

            TextField {
                id: lenght
                width: parent.width
                placeholderText: "Length(cm)"
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                label: "Length(cm)"
                focusOnClick: true
                text: foodiary.users.get(name.currentIndex).length

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: type.focus = true

                onTextChanged: {
                    saveUserChanges = true
                }
            }

            TextField {
                id: type
                width: parent.width
                placeholderText: "Type"
                label: "Type"
                focusOnClick: true
                text: foodiary.users.get(name.currentIndex).type

                EnterKey.iconSource: "image://theme/icon-m-enter-close"
                EnterKey.onClicked: focus = false

                onTextChanged: {
                    saveUserChanges = true
                }
            }
        }
    }
}
