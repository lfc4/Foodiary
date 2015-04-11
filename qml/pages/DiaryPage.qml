import QtQuick 2.0
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Page {
    id: diarypage

    function validateDate(){
        var res = ""
        try {
            res = foodiary.entries.get(foodiary.currentEntry).date
        }
        catch(err){
            console.log("Error dateNow: " + err)
            res = new Date().toLocaleString(Qt.locale(), "yyyy.MM.dd")
        }
        console.log("dateNow set to: '" + res + "'")
        return res
    }

    function validateTime(){
        var res = ""
        try {
            res = foodiary.entries.get(foodiary.currentEntry).time
        }
        catch(err){
            console.log("Error timeNow: " + err)
            res = new Date().toLocaleString(Qt.locale(), "hh:mm")
        }
        console.log("timeNow set to: '" + res + "'")
        return res
    }

    function validateBS(){
        var res = ""
        try {
            res = foodiary.entries.get(foodiary.currentEntry).bs
            res = res.toFixed(1)
        }
        catch(err){
            console.log("Error BS: " + err)
        }
        if(res === 0 || res === 0.0)
            res = ""
        console.log("BS set to: '" + res + "'")
        return res
    }

    function validatePicture(){
        var res = ""
        try {
            res = foodiary.entries.get(foodiary.currentEntry).picture
        }
        catch(err){
            console.log("Error Picture: " + err)
            res = "Foodiary.jpg"
        }
        console.log("Picture set to: '" + res + "'")
        return res
    }

    function validateDescription(){
        var res = ""
        try {
            res = foodiary.entries.get(foodiary.currentEntry).description
        }
        catch(err){
            console.log("Error Description: " + err)
        }
        console.log("Description set to: '" + res + "'")
        return res
    }

    function validateOther(){
        var res =  ""

        try {
            res = foodiary.entries.get(foodiary.currentEntry).other
        }
        catch(err){
            console.log("Error Other: " + err)
        }
        console.log("Other set to: '" + res + "'")
           return res
    }

    function validatePlace(){
        var res = 0
        try {
            res = foodiary.entries.get(foodiary.currentEntry).location - 1
        }
        catch(err){
            console.log("Error Other: " + err)
        }
        console.log("Location set to: '" + res + "'")
        return res
    }

    function validateMeal(){
        var res = 0
        try {
            res = foodiary.entries.get(foodiary.currentEntry).meal
        }
        catch(err){
            console.log("Error Other: " + err)
        }
        console.log("Meal set to: '" + res + "'")
        return res
    }

    function validateUser(){
        var res = ""
        try {
            res = foodiary.entries.get[foodiary.entries.get(foodiary.currentEntry).id].user
        }
        catch(err){
            console.log("Error User: " + err)
        }
        console.log("User set to: '" + res + "'")
        return res
    }

    property string url: ""
    property bool done: false
    property int currentIndex: 0
    property string dateNow: validateDate()
    property string timeNow: validateTime()
    property bool saveChanges: false
    property bool editMode: false
    property bool userChanged: false
    property string prevUser: foodiary.currentUser
    property var locale: Qt.locale()

    function refreshAllValues() {
        dateNow = validateDate()
        timeNow = validateTime()
        dateTime.text = FileIO.convertDateTime(dateNow) + " | " + timeNow
        before.source = validatePicture()
        place.currentIndex = validatePlace()
        mealz.currentIndex = validateMeal()
        bloodsugar.text = validateBS()
        description.text = validateDescription()
        other.text = validateOther()
    }

    function clearAllValues() {
        dateNow = new Date().toLocaleString(Qt.locale(), "yyyy.MM.dd")
        timeNow = new Date().toLocaleString(Qt.locale(), "hh:mm")
        dateTime.text = FileIO.convertDateTime(dateNow) + " | " + timeNow
        before.source = "Foodiary.jpg"
        place.currentIndex = 0
        mealz.currentIndex = 0
        bloodsugar.text = ""
        description.text = ""
        other.text = ""
        saveChanges = false
        editMode = false
        userChanged = false
    }

    function save() {
        if(editMode === true)
        {
            if(saveChanges === true && foodiary.currentEntry !== "")
            {
                foodiary.updateDiary(foodiary.entries.get(foodiary.currentEntry).id, foodiary.currentUser, dateNow, timeNow, before.source, parseFloat(bloodsugar.text), description.text, foodiary.currentLocation, other.text, foodiary.currentMeal)
                //foodiary.getEntries(foodiary.currentUser)
                foodiary.currentEntry = "" //= foodiary.newestEntry
                clearAllValues()
                editMode = false
                saveChanges = false
                userChanged = false
            }
            else{
                foodiary.currentEntry = "" //= foodiary.newestEntry
                clearAllValues()
                editMode = false
                saveChanges = fals
                userChanged = false
            }
        }
        else
        {
            if(saveChanges === true || userChanged === true)
            {
                if(bloodsugar.text === "")
                {
                    bloodsugar.text = "0.0"
                }
                foodiary.saveDiary(foodiary.currentUser, dateNow, timeNow, before.source, parseFloat(bloodsugar.text), description.text, foodiary.currentLocation, other.text, foodiary.currentMeal)
                //foodiary.getEntries(foodiary.currentUser)
                foodiary.currentEntry = "" // foodiary.newestEntry
                console.log("Save: " + foodiary.currentUser);
                clearAllValues()
                saveChanges = false
                userChanged = false
            }
            else{
                foodiary.currentEntry = "" //= foodiary.newestEntry
                clearAllValues()
                editMode = false
                saveChanges = false
                userChanged = false
            }
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Component {
            id: stat
            Statistics {}
        }

        Component {
            id: settings
            Settings {}
        }

        HorizontalScrollDecorator{}

        PushUpMenu {
            MenuItem {
                text: qsTr("Clear")
                onClicked: {
                    foodiary.currentEntry = ""
                    clearAllValues()
                }

            }
        }
        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: {
                    if(saveChanges === true) {
                        save()
                    }
                    var Component = pageStack.push(settings)
                }
            }

            MenuItem {
                text: qsTr("Statistics")
                onClicked: {
                    if(saveChanges === true) {
                        save()
                    }
                    var Component = pageStack.push(stat)
                }
            }
            MenuItem {
                text: qsTr("Save")
                onClicked: {
                    save()
                }
            }
        }

        Column {
            id: column
            width: parent.width

            PageHeader {
                id: ph
                title: foodiary.users.get(foodiary.currentUser - 1).name

                SwipeArea {
                    id: mouse
                    anchors.fill: parent
                        onMove: {
                            //content.x = (-root.width * currentIndex) + x
                        }
                        onSwipe: {
                            switch (direction) {
                            case "left":
                                console.log("Swipe left");
                                if (currentIndex === foodiary.users.count-1) {
                                    currentIndexChanged()
                                    console.log("currentindexchanged");
                                }
                                else {
                                    prevUser = foodiary.currentUser
                                    currentIndex++
                                    console.log("currentindex changed to: " + currentIndex)
                                }
                                break
                            case "right":
                                console.log("Swipe right");
                                if (currentIndex === 0) {
                                    currentIndexChanged()
                                    console.log("currentindexchanged");
                                }
                                else {
                                    prevUser = foodiary.currentUser
                                    currentIndex--
                                    console.log("currentindex changed to: " + currentIndex)
                                }
                                break
                            }
                            foodiary.currentUser = foodiary.users.get(currentIndex).id
                            //ph.title = foodiary.currentUser

                            if(foodiary.currentUser !== prevUser && editMode === true) {
                                if(foodiary.currentUser !== validateUser())
                                {
                                    userChanged = true
                                    editMode = false
                                }
                            }
                            else {
                                userChanged = false
                            }
                            console.log("userChanged: " + userChanged + ", Editmode: " + editMode + ", SaveChanges: " + saveChanges)
                        }
                        onCanceled: {
                            currentIndexChanged()
                            console.log("cancel currentindexchanged");
                        }
                }
            }

            Rectangle {
                id: rect
                color: Theme.secondaryHighlightColor
                height: Theme.itemSizeSmall
                width: parent.width

                Label {
                    id: dateTime
                    width: parent.width/2
                    text: FileIO.convertDateTime(dateNow) + " | " + timeNow
                    anchors.centerIn: parent

                    MouseArea {
                        id: m0
                        anchors.left: parent.left
                        height: Theme.itemSizeSmall
                        width: parent.width/2

                        onClicked: {
                            var dialog = pageStack.push(datePickerComponent, {
                                                            date: new Date()
                                                        })
                            dialog.accepted.connect(function() {
                                dateNow =  dialog.date.toLocaleString(Qt.locale(), "yyyy.MM.dd")
                                dateTime.text = FileIO.convertDateTime(dateNow) + " | " + timeNow
                                saveChanges = true
                            })
                        }
                    }

                    MouseArea {
                        id: m1
                        height: Theme.itemSizeSmall
                        anchors.left: m0.right
                        width: dateTime.width/2
                        onClicked: {
                            var dialog = pageStack.push(timePickerComponent, {
                                                            hour: new Date().toLocaleString(Qt.locale(), "hh"),
                                                            minute: new Date().toLocaleString(Qt.locale(), "mm")
                                                        })
                            dialog.accepted.connect(function() {
                                timeNow = dialog.time.toLocaleString(Qt.locale(), "hh:mm")
                                dateTime.text = FileIO.convertDateTime(dateNow) + " | " + dialog.time.toLocaleString(Qt.locale(), "hh:mm")
                                saveChanges = true
                            })
                        }
                    }

                    Component {
                        id: datePickerComponent
                        DatePickerDialog {}
                    }

                    Component {
                        id: timePickerComponent
                        TimePickerDialog {}
                    }
                }
            }

                Image {
                    id: before
                    source: validatePicture()
                    height: parent.width/3
                    width: parent.width
                    smooth: true
                    clip: true
                    fillMode: Image.PreserveAspectCrop

                    MouseArea {
                        id: ma
                        anchors.fill: parent
                        onClicked: {
                            var dialog
                            if(pictureSource.value == "Gallery" )
                            {
                                dialog = pageStack.push("PhotoPicker.qml", {"pathToFile": before.source})
                                dialog.accepted.connect(function() {
                                    before.source = dialog.pathToFile
                                    saveChanges = true
                                })
                            }
                            else
                            {
                                dialog = pageStack.push("Camera.qml", {"pathToFile": before.source})
                                dialog.accepted.connect(function() {
                                    before.source = dialog.pathToFile
                                    saveChanges = true
                                })
                            }
                        }
                    }
                }

                ComboBox {
                    id: pictureSource
                    width: parent.width
                    label: "Source"
                    currentIndex: 1
                    visible: true

                    menu: ContextMenu {
                        MenuItem { text: "Camera" }
                        MenuItem { text: "Gallery" }
                    }
                }

                ComboBox {
                    id: place
                    width: parent.width
                    label: "Place"
                    currentIndex: foodiary.currentLocation

                    menu: ContextMenu {
                        Repeater {
                            model: foodiary.locations
                            MenuItem { text: model.name }
                        }
                    }

                   onCurrentIndexChanged:{
                       foodiary.currentLocation = foodiary.locations.get(place.currentIndex).id
                       saveChanges = true
                   }
                }

                TextField {
                    id: bloodsugar
                    width: parent.width
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    placeholderText: "BS(mmol/l)"
                    label: "BS(mmol/l)"
                    focusOnClick: true
                    text: validateBS()//foodiary.entries.get(foodiary.currentEntry).bs

                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: focus = false

                    onTextChanged:{
                        saveChanges = true
                    }
                }

                ComboBox {
                    id: mealz
                    width: parent.width
                    label: "Meal"
                    currentIndex: 0

                    menu: ContextMenu {
                        Repeater {
                            model: foodiary.meals
                            MenuItem { text: model.name }
                        }
                    }

                    onCurrentIndexChanged:{
                        console.log("Current: " + foodiary.currentMeal)
                        console.log("Index: " + mealz.currentIndex)
                        console.log("Id: " + foodiary.meals.get(mealz.currentIndex).id)
                        console.log("Description: " + foodiary.meals.get(mealz.currentIndex).description)
                        foodiary.currentMeal = mealz.currentIndex
                        description.text = foodiary.meals.get(mealz.currentIndex).description
                        saveChanges = true
                    }
                }

                TextArea {
                    id: description
                    width: parent.width
                    height: Math.max(parent.width/6, implicitHeight)
                    placeholderText: "Description and amount"
                    label: "Description and amount"
                    focusOnClick: true
                    text: validateDescription() //foodiary.entries.get(foodiary.currentEntry).description

                    onTextChanged: {
                     saveChanges = true
                    }
                }

                TextField {
                    id: other
                    width: parent.width
                    placeholderText: "Other"
                    label: "Other"
                    focusOnClick: true
                    text: validateOther() //foodiary.entries.get(foodiary.currentEntry).other

                    EnterKey.iconSource: "image://theme/icon-m-enter-close"
                    EnterKey.onClicked: focus = false

                    onTextChanged: {
                     saveChanges = true
                    }
                }
            }
            VerticalScrollDecorator {flickable: slide }
        }

    Component.onCompleted: {
        foodiary.getUsers()
        foodiary.getLocations()
        foodiary.getMeals()
        foodiary.getEntries(foodiary.currentUser)
        foodiary.currentEntry = ""
        clearAllValues()
    }

    Component.onDestruction:{
            FileIO.saveSettings(foodiary.currentUser)
    }
}
