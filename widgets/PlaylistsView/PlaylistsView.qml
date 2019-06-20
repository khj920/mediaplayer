import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import org.kde.kirigami 2.6 as Kirigami
import org.kde.mauikit 1.0 as Maui


import "../../view_models/BabeTable"
import "../../view_models"
import "../../db/Queries.js" as Q
import "../../utils/Help.js" as H


Kirigami.PageRow
{
    id: playlistViewRoot

    property string playlistQuery
    property alias playlistModel : playlistViewModel.model
    property alias playlistList : playlistViewModel.list
    property alias playlistViewList : playlistViewModel

    signal rowClicked(var track)
    signal quickPlayTrack(var track)
    signal playAll()
    signal playSync(var playlist)
    signal appendAll()

    clip: true
    separatorVisible: wideMode
    initialPage: [playlistLayout, filterList]
    defaultColumnWidth: Kirigami.Units.gridUnit * 15

    ColumnLayout
    {
        id: playlistLayout
        clip: true
        spacing: 0
        Layout.margins: 0

        SwipeView
        {
            id: playlistSwipe

            Layout.fillHeight: true
            Layout.fillWidth: true

            interactive: false
            clip: true

            PlaylistsViewModel
            {
                id: playlistViewModel
                onPlaySync: syncAndPlay(index)
            }

            BabeList
            {
                id: playlistViewModelFilter

                headBarExitIcon: "go-previous"

                model : ListModel {}
                delegate: Maui.LabelDelegate
                {
                    id: delegate
                    label : tag
                    Connections
                    {
                        target: delegate

                        onClicked: {}
                    }
                }

                onExit: playlistSwipe.currentIndex = 0
            }

        }

        ColorTagsBar
        {
            Layout.fillWidth: true
            height: rowHeightAlt
            recSize: isMobile ? iconSize : 16

            onColorClicked:
            {
                populate(Q.GET.colorTracks_.arg(color))
                if(!playlistViewRoot.wideMode)
                    playlistViewRoot.currentIndex = 1
            }
        }
    }

    BabeTable
    {
        id: filterList
        clip: true
        quickPlayVisible: true
        coverArtVisible: true
        trackRating: true
        trackDuration: false
        headBar.visible: !holder.visible
        headBarExitIcon: "go-previous"
        headBarExit: !playlistViewRoot.wideMode
        headBarTitle: playlistViewModel.list.get(playlistViewModel.currentIndex).playlist
        onExit: if(!playlistViewRoot.wideMode)
                    playlistViewRoot.currentIndex = 0

        holder.emoji: "qrc:/assets/Electricity.png"
        holder.isMask: false
        holder.title : playlistViewModel.model.get(playlistViewModel.currentIndex).playlist
        holder.body: "Your playlist is empty,<br>start adding new music to it"
        holder.emojiSize: iconSizes.huge

        contextMenuItems:
            Maui.MenuItem
            {
                text: qsTr("Remove from playlist")
            }


        //        headerMenu.menuItem:  [
        //            Maui.MenuItem
        //            {
        //                enabled: !playlistViewModel.model.get(playlistViewModel.currentIndex).playlistIcon
        //                text: "Sync tags"
        //                onTriggered: {}
        //            },
        //            Maui.MenuItem
        //            {
        //                enabled: !playlistViewModel.model.get(playlistViewModel.currentIndex).playlistIcon
        //                text: "Play-n-Sync"
        //                onTriggered:
        //                {
        //                    filterList.headerMenu.close()
        //                    syncAndPlay(playlistViewModel.currentIndex)
        //                }
        //            },
        //            Maui.MenuItem
        //            {
        //                enabled: !playlistViewModel.model.get(playlistViewModel.currentIndex).playlistIcon
        //                text: "Remove playlist"
        //                onTriggered: removePlaylist()
        //            }
        //        ]


        //            contextMenu.menuItem: [

        //                MenuItem
        //                {
        //                    text: qsTr("Remove from playlist")
        //                    onTriggered:
        //                    {
        //                        bae.removePlaylistTrack(filterList.model.get(filterList.currentIndex).url, playlistViewModel.model.get(playlistViewModel.currentIndex).playlist)
        //                        populate(playlistQuery)
        //                    }
        //                }
        //            ]


        section.criteria: ViewSection.FullString
        section.delegate: Maui.LabelDelegate
        {
            label: filterList.section.property === qsTr("stars") ? H.setStars(section) : section
            isSection: true
            boldLabel: true
            labelTxt.font.family: "Material Design Icons"

        }

        Connections
        {
            target: filterList
            onRowClicked: playlistViewRoot.rowClicked(filterList.model.get(index))
            onQuickPlayTrack:
            {
                playlistViewRoot.quickPlayTrack(filterList.model.get(filterList.currentIndex))
            }
            onPlayAll: playAll()
            onAppendAll: appendAll()
            onPulled: populate(playlistQuery)
        }

        Connections
        {
            target: filterList.contextMenu

            onRemoveClicked:
            {
                playlistList.removeTrack(playlistViewList.currentIndex, filterList.list.get(filterList.currentIndex).url)
                populate(playlistQuery)
            }
        }
    }


    function populateExtra(query, title)
    {
        //        playlistSwipe.currentIndex = 1

        //        var res = bae.get(query)
        //        playlistViewModelFilter.clearTable()
        //        playlistViewModelFilter.headBarTitle = title
        //        appendToExtraList(res)
    }

    function appendToExtraList(res)
    {
        if(res.length>0)
            for(var i in res)
                playlistViewModelFilter.model.append(res[i])
    }

    function populate(query)
    {
        if(!playlistViewRoot.wideMode)
            playlistViewRoot.currentIndex = 1

        playlistViewRoot.playlistQuery = query
        filterList.list.query = playlistViewRoot.playlistQuery
    }

    function refresh()
    {
    }

    function syncAndPlay(index)
    {
        if(!playlistList.get(index).playlistIcon)
            playlistViewRoot.playSync(playlistList.get(index).playlist)
    }

    function removePlaylist()
    {
        playlistList.removePlaylist(playlistViewList.currentIndex)
        filterList.clearTable()
    }
}
