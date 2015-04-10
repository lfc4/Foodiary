import QtQuick 2.0
import Sailfish.Silica 1.0
import QtDocGallery 5.0
import org.nemomobile.thumbnailer 1.0

Dialog {
    id: photo
    property string pathToFile: ""

    DocumentGalleryModel {
        id: galleryModel
        rootType: DocumentGallery.Image
        properties: [ "url", "title", "dateTaken" ]
        autoUpdate: true
        sortProperties: ["-dateTaken"]
    }

    SilicaGridView {
        id: grid
        header: PageHeader { title: "Gallery" }
        cellWidth: width / 3
        cellHeight: width / 3
        anchors.fill: parent
        model: galleryModel

        // Sailfish Silica PulleyMenu on top of the grid
        PullDownMenu {
            MenuItem {
                text: "Latest first"
                onClicked: galleryModel.sortProperties = [ "-dateTaken" ]
            }
            MenuItem {
                text: "Oldest first"
                onClicked: galleryModel.sortProperties = [ "dateTaken" ]
            }
        }

        delegate: Image {
            asynchronous: true

            source: "image://nemoThumbnail/" + url

            sourceSize.width: grid.cellWidth
            sourceSize.height: grid.cellHeight

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    pathToFile = url
                    photo.accept()
                }
            }
        }
        ScrollDecorator {}
    }
}

