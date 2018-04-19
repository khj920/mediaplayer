import QtQuick.Controls 2.2
import QtQuick 2.9
import ".."

Pane
{
    id: gridPage
    padding: 20

    //    readonly property int screenSize : bae.screenGeometry("width")*bae.screenGeometry("height");
    property int hintSize : Math.sqrt(root.width*root.height)*0.3

    property int albumCoverSize: isMobile ? iconSizes.huge : iconSizes.enormous
    readonly property int albumSpacing: albumCoverSize*0.5 + space.big

    property int albumCoverRadius : albumCoverSize*0.05
    property bool albumCardVisible : true
    property alias gridModel: gridModel
    property alias grid: grid

    signal albumCoverClicked(string album, string artist)
    signal albumCoverPressed(string album, string artist)
    signal bgClicked()


    onWidthChanged: grid.forceLayout()

    function clearGrid()
    {
        gridModel.clear()
    }

    MouseArea
    {
        anchors.fill: parent
        onClicked: bgClicked()
    }

    BabeHolder
    {
        visible: grid.count === 0
        message: "No albums..."
    }

    ListModel {id: gridModel}

    GridView
    {
        id: grid
        clip: true
        MouseArea
        {
            anchors.fill: parent
            onClicked: bgClicked()
            z: -999
        }

        width: parent.width
        height: parent.height

        cellWidth: albumCoverSize + albumSpacing
        cellHeight:  albumCoverSize + albumSpacing

        focus: true
        boundsBehavior: Flickable.StopAtBounds

        flickableDirection: Flickable.AutoFlickDirection

        snapMode: GridView.SnapToRow
        //        flow: GridView.FlowTopToBottom
        //        maximumFlickVelocity: albumSize*8

        model: gridModel
        delegate: BabeAlbum
        {
            id: albumDelegate

            albumSize : albumCoverSize
            albumRadius: albumCoverRadius
            albumCard: albumCardVisible

            height: grid.cellHeight
            width: grid.cellWidth

            Connections
            {
                target: albumDelegate
                onAlbumClicked:
                {
                    var album = grid.model.get(index).album
                    var artist = grid.model.get(index).artist
                    albumCoverClicked(album, artist)
                    grid.currentIndex = index
                }

                onAlbumPressed:
                {
                    var album = grid.model.get(index).album
                    var artist = grid.model.get(index).artist
                    albumCoverPressed(album, artist)
                }
            }
        }

        ScrollBar.vertical:BabeScrollBar { visible: true }

        onWidthChanged:
        {
            var amount = parseInt(width/(albumCoverSize + albumSpacing),10)
            var leftSpace = parseInt(width-(amount*(albumCoverSize + albumSpacing)), 10)
            var size = parseInt((albumCoverSize + albumSpacing)+(parseInt(leftSpace/amount, 10)), 10)

            size = size > albumCoverSize + albumSpacing? size : albumCoverSize + albumSpacing

            cellWidth = size
            //            grid.cellHeight = size
        }
    }

}
