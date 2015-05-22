import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import QtMultimedia 5.0

Dialog {
    id: cameraDialog
    property string pathToFile: ""
    property string name: ""

    DiaryPage{
        id: dp
    }

    PageHeader {
        id: head
        title: "Take Picture"
    }

    Item {
        width: parent.width
        height: parent.height
        anchors.fill: parent

        Camera {
            id: camera
            exposure.exposureCompensation: -1.0
            exposure.exposureMode: Camera.ExposurePortrait

            imageCapture {
                onImageSaved: {
                    pathToFile = dp.path + name
                    cameraDialog.accept()
                }
            }
        }

        VideoOutput {
            source: camera
            anchors.fill: parent
            focus : visible

            MouseArea {
                anchors.fill: parent;
                onClicked:{
                    name = new Date().toLocaleString(Qt.locale(), "yyyyMMddhhmmss") + ".jpg"
                    camera.imageCapture.captureToLocation(dp.path + name)
                }
            }
        }
    }
}
