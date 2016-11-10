/*
 * Copyright (C) 2014-2015
 *      Andrew Hayzen <ahayzen@gmail.com>
 *      Nekhelesh Ramananthan <nik90@ubuntu.com>
 *      Victor Thompson <victor.thompson@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Upstream location:
 * https://github.com/krnekhelesh/flashback
 */

import QtQuick 2.4
import Ubuntu.Components 1.3

// Slide 4
Component {
    id: slide4

    Item {
        id: slide4Container

        UbuntuShape {
            anchors {
                top: parent.top
                topMargin: units.gu(6)
                horizontalCenter: parent.horizontalCenter
            }
            height: (parent.height - bodyText.contentHeight - introductionText.height - 4*units.gu(4))/2
            radius: "medium"
            source:  Image {
                id: centerImage
                source: Qt.resolvedUrl("../../../PockIt.png")
                asynchronous: true
            }

            width: height
        }

        Label {
            id: introductionText
            anchors {
                bottom: bodyText.top
                bottomMargin: units.gu(4)
            }
            elide: Text.ElideRight
            fontSize: "x-large"
            horizontalAlignment: Text.AlignHLeft
            maximumLineCount: 2
            text: i18n.tr("Save From Anywhere")
            width: units.gu(36)
            wrapMode: Text.WordWrap
        }

        Label {
            id: bodyText
            anchors {
                bottom: parent.bottom
                bottomMargin: units.gu(10)
            }
            fontSize: "large"
            height: contentHeight
            horizontalAlignment: Text.AlignHLeft
            text: i18n.tr("Save from Browser, or any of your favorite apps like Twitter and Facebook. It only takes a minute.")
            width: units.gu(36)
            wrapMode: Text.WordWrap
        }
    }
}
