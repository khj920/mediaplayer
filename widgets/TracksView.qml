import QtQuick 2.9
import org.kde.mauikit 1.0 as Maui
import "../view_models/BabeTable"
import "../view_models"
import "../db/Queries.js" as Q
import "../utils/Help.js" as H

BabeTable
{
    id: tracksViewTable
    trackNumberVisible: false
    trackDuration: true
    trackRating: true
    headBar.visible: !holder.visible
//    headBarTitle: count + " tracks"
    headBarExit: false
    coverArtVisible: false
    holder.emoji: "qrc:/assets/MusicCloud.png"
    holder.isMask: false
    holder.title : "No Tracks!"
    holder.body: "Add new music sources"
    holder.emojiSize: iconSizes.huge

    list.query: Q.GET.allTracks

}


