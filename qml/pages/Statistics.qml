import QtQuick 2.0
import Sailfish.Silica 1.0


Page {
    id: stats
    property int currentId: 0
    property ListModel listModel: foodiary.entries

    function clearAll()
    {
        foodiary.clearEntries(foodiary.currentUser)
        listModel.clear()
    }

    RemorsePopup {
        id: clearRemorse
    }

    SilicaListView {
        id: diarylist
        anchors.fill: parent
        header: PageHeader { title: foodiary.users.get(foodiary.currentUser - 1).name }
        model: listModel

        ViewPlaceholder {
            enabled: diarylist.count == 0
            text: "No entries yet"
        }

        Component {
            id: report
            Report {}
        }

        PullDownMenu {
            id: pullDownMenu
            MenuItem {
                text: "Clear"
                visible: diarylist.count
                onClicked: clearRemorse.execute("Clearing", function() { clearAll() } )
            }
            MenuItem {
                text: "Make report"
                onClicked: {
                    var Component = pageStack.push(report)//foodiary.exportDiary(foodiary.currentUser, "","")
                }
            }
            MenuItem {
                text: "Jump to the end"
                onClicked: diarylist.scrollToBottom()
            }
        }

        PushUpMenu {
            id: pushUpMenu
            spacing: Theme.paddingLarge

            MenuItem {
                text: "Return to Top"
                onClicked: diarylist.scrollToTop()
            }
        }
        VerticalScrollDecorator {}


        delegate: ListItem {
            id: listItem
            width: ListView.view.width
            height: Theme.itemSizeSmall
            menu: entryMenu
            ListView.onRemove: animateRemoval()

            onClicked: {
                foodiary.currentEntry = index //listModel.get(index).id
                console.log("Current entry set to: " + foodiary.currentEntry + ", index: " + index + ", listmodel.get(index).id: " + listModel.get(index).id);
                diarypage.editMode = true
                diarypage.refreshAllValues()
                diarypage.saveChanges = false
                userChanged = false
                pageStack.pop()
            }

            function remove() {
                remorseAction("Deleting", function() {
                    foodiary.deleteEntry(listModel.get(index).id)
                    listModel.remove(listModel.index)
                    foodiary.getEntries(foodiary.currentUser)
                })
            }

            Label {
                x: Theme.paddingLarge
                text: {
                    console.log("BS: " + bs.toFixed(1))
                    if(bs.toFixed(1) != 0.0)
                        FileIO.convertDateTime(date) + " " + time + " " + bs.toFixed(1) + " mmol/l"
                    else
                        FileIO.convertDateTime(date) + " " + time
                }
                anchors.verticalCenter: parent.verticalCenter
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
            }

            Component {
                id: entryMenu
                ContextMenu {
                    MenuItem {
                        text: "Delete"
                        onClicked: remove()
                    }
                }
            }
        }
    }

    Component.onCompleted:{
            foodiary.getEntries(foodiary.currentUser)
    }
}
