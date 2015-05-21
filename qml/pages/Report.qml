import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: report
    property string dateFrom: new Date().toLocaleString(Qt.locale(), "yyyy.MM.dd")
    property string dateTo: new Date().toLocaleString(Qt.locale(), "yyyy.MM.dd")
    property string dateTimeNow: new Date().toLocaleString(Qt.locale(), "yyyyMMddhhmmss")
    property bool enableDate: false

    property ListModel exttype: ListModel {
        id: exttype
        ListElement { text: ".odt" }
        ListElement { text: ".csv" }
    }
    property ListModel layouts: ListModel {
        id: layouts
        ListElement { text: "VCS" }
        ListElement { text: "Table" }
        ListElement { text: "Graph" }
    }

    function clearValues(){
        path.text = ""
        file.text = ""
        weight.text = ""
        lenght.text = ""
        type.text = ""
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: col.height

        Component {
            id: datePickerComponent
            DatePickerDialog {}
        }

        Column {
            id: col
            width: parent.width

            PageHeader {
                title: "Report"
            }

            SectionHeader {
                text: "File properties"
            }

            ComboBox {
                id: type
                width: parent.width
                label: "Layout"
                currentIndex: 0

                menu: ContextMenu {
                    Repeater {
                        model: layouts
                        MenuItem { text: model.text }
                    }
                }
            }

            TextField {
                id: path
                width: parent.width
                placeholderText: "File path"
                label: "Path"
                focusOnClick: true
                text: ReportWriter.documentsLocation()
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                //EnterKey.onClicked: age.focus = true

                onTextChanged: {
                    runReport.enabled = true
                }
            }
            Row
            {
                id: filenameRow
                width: parent.width

                TextField {
                    id: file
                    width: 4*parent.width/5
                    placeholderText: "File name"
                    //inputMethodHints: Qt.ImhFormattedNumbersOnly
                    label: "File name"
                    focusOnClick: true
                    text: foodiary.users.get(foodiary.currentUser - 1).name + "_" + dateTimeNow

                    EnterKey.iconSource: "image://theme/icon-m-enter-next"
                    //EnterKey.onClicked: weight.focus = true

                    onTextChanged: {
                        runReport.enabled = true
                    }
                }

                ComboBox {
                    id: extension
                    width: parent.width/5
                    currentIndex: 0

                    menu: ContextMenu {
                        Repeater {
                            model: exttype
                            MenuItem { text: model.text }
                        }
                    }
                }
            }

            TextSwitch {
                text: "Use date range (all values if not specified)"
                enabled: true

                onCheckedChanged: {
                    if(enableDate == false)
                        enableDate = true
                    else
                        enableDate = false
                }
            }

            Row
            {
                id: r1
                width: parent.width

                Label {
                    id: from
                    width: parent.width/3
                    text: "From"
                    enabled: enableDate
                }

                Label {
                    id: fromdate
                    width: 2*parent.width/3
                    text: dateFrom
                    enabled: enableDate

                    MouseArea {
                        id: ma0
                        //anchors.left: parent.left
                        height: Theme.itemSizeSmall
                        width: parent.width

                        onClicked: {
                            var dialog = pageStack.push(datePickerComponent, {
                                                            date: new Date()
                                                        })
                            dialog.accepted.connect(function() {
                                dateFrom =  dialog.date.toLocaleString(Qt.locale(), "yyyy.MM.dd")
                                fromdate.text = dialog.date.toLocaleString(Qt.locale(), "yyyy.MM.dd")
                                saveChanges = true
                            })
                        }
                    }
                }
            }

            Row
            {
                id: r2
                width: parent.width

                Label {
                    id: to
                    width: parent.width/3
                    text: "To"
                    enabled: enableDate
                }

                Label {
                    id: todate
                    width: 2*parent.width/3
                    text: dateTo
                    enabled: enableDate

                    MouseArea {
                        id: ma1
                        //anchors.left: parent.left
                        height: Theme.itemSizeSmall
                        width: parent.width

                        onClicked: {
                            var dialog = pageStack.push(datePickerComponent, {
                                                            date: new Date()
                                                        })
                            dialog.accepted.connect(function() {
                                dateTo =  dialog.date.toLocaleString(Qt.locale(), "yyyy.MM.dd")
                                todate.text = dialog.date.toLocaleString(Qt.locale(), "yyyy.MM.dd")
                                saveChanges = true
                            })
                        }
                    }
                }
            }

            Button{
                id: runReport
                width: parent.width
                text: "Run"

                onClicked: {
                    if(enableDate == true)
                        foodiary.exportDiary(path.text + file.text + exttype.get(extension.currentIndex).text , foodiary.currentUser, layouts.get(type.currentIndex).text, dateFrom, dateTo)
                   else
                        foodiary.exportDiary(path.text + file.text + exttype.get(extension.currentIndex).text , foodiary.currentUser, layouts.get(type.currentIndex).text, "", "")
                    file.text = foodiary.users.get(foodiary.currentUser - 1) + "_" + new Date().toLocaleString(Qt.locale(), "yyyyMMddhhmmss")
                    pageStack.pop()
                }
            }
        }
    }
}





