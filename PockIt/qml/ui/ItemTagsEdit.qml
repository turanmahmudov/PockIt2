import QtQuick 2.4
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3

import "../components"

import "../js/localdb.js" as LocalDB
import "../js/user.js" as User
import "../js/apiKeys.js" as ApiKeys
import "../js/scripts.js" as Scripts

Page {
    id: itemTagsEditPage

    // Params come from List
    property var items_ids
    property bool articleView: false

    header: PageHeader {
        title: i18n.tr("Edit Tags")

        leadingActionBar {
            actions: [
                Action {
                    id: closePageAction
                    text: i18n.tr("Cancel")
                    iconName: "back"
                    onTriggered: {
                        if (!articleView) {
                            isArticleOpen = false
                        }
                        pageLayout.removePages(itemTagsEditPage)
                    }
                }

            ]
        }

        trailingActionBar {
            actions: [
                Action {
                    id: saveAction
                    text: i18n.tr("Save")
                    iconName: "tick"
                    onTriggered: {
                        save()
                    }
                }
            ]
        }
    }

    ListModel {
        id: allTagsModel
    }

    ListModel {
        id: itemTagsModel
    }

    function home() {
        allTagsModel.clear()
        itemTagsModel.clear()

        var allTags = []
        var itemsTags = []
        var commonTags = []

        var db = LocalDB.init();
        db.transaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM Tags GROUP BY tag ORDER BY tag");

            if (rs.rows.length !== 0) {
                for (var i = 0; i < rs.rows.length; i++) {
                    allTags.push(rs.rows.item(i).tag)
                }

                for (var j = 0; j < items_ids.length; j++) {
                    var rs_t = tx.executeSql("SELECT * FROM Tags WHERE entry_id = ? GROUP BY tag ORDER BY tag", items_ids[j]);

                    itemsTags[j] = []

                    for (var k = 0; k < rs_t.rows.length; k++) {
                        itemsTags[j].push(rs_t.rows.item(k).tag)
                    }
                }

                commonTags = Scripts.getCommonElements(itemsTags)

                for (var l = 0; l < commonTags.length; l++) {
                    itemTagsModel.append({"tag":commonTags[l]})

                    var index = allTags.indexOf(commonTags[l]);
                    allTags.splice(index, 1);
                }

                for (var m = 0; m < allTags.length; m++) {
                    allTagsModel.append({"tag":allTags[m]})
                }
            }
        })
    }

    function save() {
        Scripts.save_item_tags(items_ids, articleView)
    }

    Component.onCompleted: {
        //home()
    }

    Column {
       id: columnSuperior
       spacing: units.gu(1)
       anchors {
           left: parent.left
           right: parent.right
           top: itemTagsEditPage.header.bottom
           topMargin: units.gu(1)
       }

       Flow {
           id: selectedTagsFlow
           spacing: units.gu(0.5)
           anchors {
               left: parent.left
               leftMargin: units.gu(1)
               right: parent.right
               rightMargin: units.gu(1)
           }
           Repeater {
               model: itemTagsModel
               Rectangle {
                   height: tag_label.height + units.gu(1)
                   width: tag_label.width + units.gu(2.5)
                   color: theme.palette.normal.base
                   radius: units.gu(0.3)
                   Label {
                       anchors.centerIn: parent
                       id: tag_label
                       text: tag
                       color: "#ffffff"
                       fontSize: "x-small"
                       font.weight: Font.DemiBold
                   }
                   MouseArea {
                       anchors.fill: parent
                       onClicked: {
                           allTagsModel.append({"tag":tag})
                           itemTagsModel.remove(index)
                       }
                   }
               }
           }
       }

       TextField {
           id: searchTagField
           anchors {
               left: parent.left
               leftMargin: units.gu(1)
               right: parent.right
               rightMargin: units.gu(1)
           }
           placeholderText: i18n.tr("Select or enter a tag...")
           onAccepted: {
               for(var i = 0; i < allTagsModel.count; i++) {
                   if (text === allTagsModel.get(i).tag) {
                       allTagsModel.remove(i)
                   }
               }
               itemTagsModel.append({"tag":text})
               searchTagField.text = ""
           }
       }

       ListItem {
           height: tagsListHeader.height

           ListItemLayout {
               id: tagsListHeader

               title.text: i18n.tr("All Tags")
               title.font.weight: Text.Normal
           }
       }
    }

    ListView {
        id: tagsList
        anchors {
            left: parent.left
            right: parent.right
            top: columnSuperior.bottom
            bottom: parent.bottom
        }
        clip: true
        model: allTagsModel
        delegate: ListItem {
            id: tagsListDelegate
            height: layout.height + divider.height

            property var removalAnimation

            removalAnimation: SequentialAnimation {
                alwaysRunToEnd: true

                PropertyAction {
                    target: tagsListDelegate
                    property: "ListView.delayRemove"
                    value: true
                }

                UbuntuNumberAnimation {
                    target: tagsListDelegate
                    property: "height"
                    to: 0
                }

                PropertyAction {
                    target: tagsListDelegate
                    property: "ListView.delayRemove"
                    value: false
                }
            }

            SlotsLayout {
                id: layout
                mainSlot: Column {
                    id: mainSlot
                    spacing: units.gu(1)

                    Label {
                        id: title
                        text: tag
                        fontSize: "medium"
                        maximumLineCount: 3
                        wrapMode: Text.WordWrap
                        width: parent.width
                    }
                }
            }

            onClicked: {
                itemTagsModel.append({"tag":tag})
                allTagsModel.remove(index)
                removalAnimation.start()
            }
        }
    }
}
