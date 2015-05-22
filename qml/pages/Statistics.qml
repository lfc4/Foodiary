import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: root
    property int currentId: 0
    property ListModel listModel: foodiary.entries

    function clearAll()
    {
        foodiary.clearEntries(foodiary.currentUser)
        listModel.clear()
    }

    Component {
        id: report
        Report {}
    }

    RemorsePopup {
        id: clearRemorse
    }

    SilicaListView {

        id: listView
        anchors.fill: parent
        model: listModel
        header: PageHeader { title: foodiary.users.get(foodiary.currentUser - 1).name }

        section {
            property: "section"
            delegate: SectionHeader {
                id: sectionHeader
                text: section
            }
        }

        ViewPlaceholder {
            enabled: listView.count == 0
            text: "No content"
            hintText: "Add some entries for " + foodiary.users.get(foodiary.currentUser - 1).name
        }

        PullDownMenu {
            id: pullDownMenu
            MenuItem {
                text: "Clear"
                visible: listView.count
                onClicked: clearRemorse.execute("Clearing", function() { clearAll() } )
            }
            MenuItem {
                text: "Make report"
                onClicked: {
                    var Component = pageStack.push(report)
                }
            }
            MenuItem {
                text: "Jump to the end"
                onClicked: listView.scrollToBottom()
            }
        }

        PushUpMenu {
            id: pushUpMenu
            spacing: Theme.paddingLarge

            MenuItem {
                text: "Return to Top"
                onClicked: listView.scrollToTop()
            }
        }

        VerticalScrollDecorator {}

        delegate: ListItem {
            id: listItem
            menu: contextMenuComponent

            function remove() {
                remorseAction("Deleting", function() {
                    foodiary.deleteEntry(listModel.get(index).id)
                    listModel.remove(listModel.index)
                    foodiary.getEntries(foodiary.currentUser)
                })
            }

            ListView.onRemove: animateRemoval()

            onClicked: {
                foodiary.currentEntry = index
                console.log("Current entry set to: " + foodiary.currentEntry + ", index: " + index + ", listmodel.get(index).id: " + listModel.get(index).id);
                diarypage.editMode = true
                diarypage.refreshAllValues()
                diarypage.saveChanges = false
                userChanged = false
                pageStack.pop()
            }

            Label {
                id: labelEntry
                x: Theme.paddingLarge
                text: {
                    console.log("BS: " + bs.toFixed(1))
                    if(bs.toFixed(1) != 0.0)
                        foodiary.locations.get(location - 1).name + " " + time + " " + bs.toFixed(1) + " mmol/l"
                    else
                        foodiary.locations.get(location - 1).name + " " + time
                }
                anchors.verticalCenter: parent.verticalCenter
                color: listItem.highlighted ? Theme.highlightColor : Theme.primaryColor
            }

            Component {
                id: contextMenuComponent
                ContextMenu {
                    MenuItem {
                        text: "Delete"
                        onClicked: remove()
                    }
                    MenuItem {
                        text: "Copy as new"
                        onClicked: {
                            foodiary.currentEntry = index
                            console.log("Current entry set to: " + foodiary.currentEntry + ", index: " + index + ", listmodel.get(index).id: " + listModel.get(index).id);
                            diarypage.editMode = false
                            diarypage.refreshAllValues()
                            diarypage.saveChanges = true
                            userChanged = false
                            pageStack.pop()
                        }
                    }
                }
            }
        }
    }
    Component.onCompleted:{
        foodiary.getEntries(foodiary.currentUser)
    }
}
