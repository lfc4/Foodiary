import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: addme
    property bool saveMealChanges: false
    property bool addMeal: false

    function clearMealValues(){
        newMealName.text = ""
        descr.text = ""
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: colu.height

        PullDownMenu {
            MenuItem {
                text: "New"
                onClicked: {
                    clearMealValues()
                    addMeal = true
                    mealName.visible = false
                    newMealName.visible = true
                    newMealName.focus = true
                }
            }
            MenuItem {
                text: "Save"
                onClicked: {
                    if(addMeal == true)
                    {
                        foodiary.saveMeal(newMealName.text, descr.text)
                        foodiary.getMeals()

                        addMeal = false
                        mealName.visible = true
                        newMealName.visible = false
                        mealName.currentIndex = 0
                    }
                    else
                    {
                        foodiary.updateMeal(foodiary.meals.get(mealName.currentIndex).id, foodiary.meals.get(mealName.currentIndex).name, descr.text)
                        foodiary.getMeals()
                    }
                }
            }
            MenuItem {
                text: "Delete"
                onClicked: {

                }
            }
        }
        Column {
            id: colu
            width: parent.width

            PageHeader {
                title: "Meals"
            }

            ComboBox {
                id: mealName
                width: parent.width
                label: "Meal"
                currentIndex: 0

                menu: ContextMenu {
                    Repeater {
                        model: foodiary.meals
                        MenuItem { text: model.name }
                    }
                }
            }

            TextField {
                id: newMealName
                width: parent.width
                placeholderText: "New meal"
                label: "Meal"
                focusOnClick: true
                visible: false

                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: descr.focus = true

                onTextChanged: {
                    saveMealChanges = true
                }
            }

            TextField {
                id: descr
                width: parent.width
                placeholderText: "Description"
                label: "Description"
                focusOnClick: true
                text: foodiary.meals.get(mealName.currentIndex).description

                EnterKey.iconSource: "image://theme/icon-m-enter-next"

                onTextChanged: {
                    saveMealChanges = true
                }
            }
        }
    }
}
