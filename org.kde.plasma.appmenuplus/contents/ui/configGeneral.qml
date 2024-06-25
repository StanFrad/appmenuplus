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
    //property alias cfg_compactViewDefault: compactViewRadioButton.checked
    property alias cfg_compactView: compactViewRadioButton.checked
    //property alias cfg_filterByActive: activeChk.checked
    //property alias cfg_filterByMaximizedDefault: maximizedChk.checked
    property alias cfg_filterByMaximized: maximizedChk.checked
    //property alias cfg_filterChildrenWindows: childrenChk.checked
    property alias cfg_fillWidth: fillWidthChk.checked
    property alias cfg_toggleMaximizedOnDoubleClick: toggleMaximizedChk.checked
    property alias cfg_toggleMaximizedOnMouseWheel: toggleMouseWheelMaximizedChk.checked
    
    property alias cfg_spacing: spacingSlider.value
    
    property var cfg_compactViewDefault
    property var cfg_filterByMaximizedDefault
    property var cfg_fillWidthDefault
    property var cfg_toggleMaximizedOnDoubleClickDefault
    property var cfg_toggleMaximizedOnMouseWheelDefault
    
    property var cfg_spacingDefault

    
    
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
        
        CheckBox {
                enabled: !compactViewRadioButton.checked
                id: fillWidthChk
                text: i18n("Always use maximum available width")
        }
        
        CheckBox {
                id: toggleMaximizedChk
                text: i18n("Maximize/restore active window on double click")
                enabled: fillWidthChk.checked && !compactViewRadioButton.checked
        }
            
        CheckBox {
                id: toggleMouseWheelMaximizedChk
                text: i18n("Maximize/restore active window on mouse wheel up/down")
                enabled: fillWidthChk.checked && !compactViewRadioButton.checked
        }
        

        

        Label{
            enabled: !compactViewRadioButton.checked
            text: i18n("Spacing:")
        }
        Slider {
            enabled: !compactViewRadioButton.checked
            id: spacingSlider
            from: 0
            to: 36
            stepSize: 1
        }
        Label {
            enabled: !compactViewRadioButton.checked
            text: spacingSlider.value + " " + i18n("px.")
        }


        
        Label{
            text: i18n("Filters:")
        }
        
        //CheckBox {
        //    id: activeChk
        //    text: i18n("Show only menus from active applications")
        //}
        
        //CheckBox {
        //    id: childrenChk
        //    text: i18n("Show only menus from main window")
        //}
        
        CheckBox {
            id: maximizedChk
            text: i18n("Show only menus from maximized windows")
        }
        
        
    }
}
