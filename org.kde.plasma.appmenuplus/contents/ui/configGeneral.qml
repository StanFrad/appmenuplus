/*
    SPDX-FileCopyrightText: 2016 Chinmoy Ranjan Pradhan <chinmoyrp65@gmail.com>

    SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
*/

import QtQuick 2.0
import QtQuick.Controls 2.5

import org.kde.kirigami 2.5 as Kirigami
import org.kde.plasma.plasmoid 2.0
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property alias cfg_compactView: compactViewRadioButton.checked
    //property alias cfg_fillWidth: fillWidthChk.checked
    property alias cfg_filterByActive: activeChk.checked
    property alias cfg_filterByMaximized: maximizedChk.checked
    property alias cfg_filterChildrenWindows: childrenChk.checked
    //property alias cfg_filterByScreen: screenAwareChk.checked
    //property alias cfg_toggleMaximizedOnDoubleClick: toggleMaximizedChk.checked
    //property alias cfg_toggleMaximizedOnMouseWheel: toggleMouseWheelMaximizedChk.checked

    Kirigami.FormLayout {
        RadioButton {
            id: compactViewRadioButton
            text: i18n("Use single button for application menu")
        }

        RadioButton {
            id: fullViewRadioButton
            checked: !compactViewRadioButton.checked
            text: i18n("Show full application menu")
        }
        /*Label{
            text: i18n("Behavior")
        }
        CheckBox {
            id: fillWidthChk
            text: i18n("Always use maximum available width")
        }

        CheckBox {
            id: toggleMaximizedChk
            text: i18n("Maximize/restore active window on double click")
            enabled: fillWidthChk.checked
        }


        CheckBox {
            id: toggleMouseWheelMaximizedChk
            text: i18n("Maximize/restore active window on mouse wheel up/down")
            enabled: fillWidthChk.checked
        }
        */
        Label{
            text: i18n("Filters:")
        }    
        //CheckBox {
        //    id: screenAwareChk
        //    text: i18n("Show only menus from current screen")
        //}


        CheckBox {
            id: activeChk
            text: i18n("Show only menus from active applications")
        }


        CheckBox {
            id: childrenChk
            text: i18n("Show only menus from main window")
        }


        CheckBox {
            id: maximizedChk
            text: i18n("Show only menus from maximized windows")
        }
    }
}
