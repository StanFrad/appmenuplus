/*
    SPDX-FileCopyrightText: 2013 Heena Mahour <heena393@gmail.com>
    SPDX-FileCopyrightText: 2013 Sebastian Kügler <sebas@kde.org>
    SPDX-FileCopyrightText: 2016 Kai Uwe Broulik <kde@privat.broulik.de>

    SPDX-License-Identifier: GPL-2.0-or-later
*/
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
// Deliberately imported after QtQuick to avoid missing restoreMode property in Binding. Fix in Qt 6.
import QtQml 2.15

import org.kde.plasma.plasmoid 2.0
import org.kde.kquickcontrolsaddons 2.0 // For KCMShell
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support 2.0 as P5Support
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.private.appmenu 1.0 as AppMenuPrivate
import org.kde.kirigami 2.5 as Kirigami
import org.kde.taskmanager as TaskManager

PlasmoidItem {
    id: root

    readonly property bool vertical: Plasmoid.formFactor === PlasmaCore.Types.Vertical
    readonly property bool view: Plasmoid.configuration.compactView
    
    //readonly property bool existsWindowActive: (windowInfoLoader.item && windowInfoLoader.item.existsWindowActive)
    readonly property bool existsWindowShown: (windowInfoLoader.item && windowInfoLoader.item.existsWindowShown)
    //readonly property bool isLastActiveWindowPinned: lastActiveTaskItem && existsWindowShown && lastActiveTaskItem.isOnAllDesktops
    readonly property bool isLastActiveWindowMaximized: lastActiveTaskItem && existsWindowShown && lastActiveTaskItem.isMaximized
    //readonly property bool isLastActiveWindowKeepAbove: lastActiveTaskItem && existsWindowShown && lastActiveTaskItem.isKeepAbove
    //readonly property bool isLastActiveWindowClosable: lastActiveTaskItem && existsWindowShown && lastActiveTaskItem.isClosable
    //readonly property bool isLastActiveWindowMaximizable: lastActiveTaskItem && existsWindowShown && lastActiveTaskItem.isMaximizable
    //readonly property bool isLastActiveWindowMinimizable: lastActiveTaskItem && existsWindowShown && lastActiveTaskItem.isMinimizable
    //readonly property bool isLastActiveWindowVirtualDesktopsChangeable: lastActiveTaskItem && existsWindowShown && lastActiveTaskItem.isVirtualDesktopsChangeable

    readonly property Item lastActiveTaskItem: windowInfoLoader.item.lastActiveTaskItem
    
    readonly property bool isMenuAccepted: appMenuModel.visible && appMenuModel.menuAvailable  && !appMenuModel.ignoreWindow

    Loader {
        id: windowInfoLoader
        sourceComponent: plasmaTasksModel
        Component{
            id: plasmaTasksModel
            PlasmaTasksModel{}
        }
    }
    
    Layout.fillWidth: !view && Plasmoid.configuration.fillWidth ? true : root.vertical
    
    onViewChanged: {
        Plasmoid.view = view;
    }

    Plasmoid.constraintHints: Plasmoid.CanFillArea
    preferredRepresentation: Plasmoid.configuration.compactView ? compactRepresentation : fullRepresentation

    // Only exists because the default CompactRepresentation doesn't expose a
    // way to mark its icon as disabled.
    // TODO remove once it gains that feature.
    compactRepresentation: PlasmaComponents3.ToolButton {
        readonly property int fakeIndex: 0
        Layout.fillWidth: false
        Layout.fillHeight: false
        Layout.minimumWidth: implicitWidth
        Layout.maximumWidth: implicitWidth
        enabled: appMenuModel.menuAvailable
        checkable: appMenuModel.menuAvailable && Plasmoid.currentIndex === fakeIndex
        checked: checkable
        icon.name: "application-menu"

        display: PlasmaComponents3.AbstractButton.IconOnly
        text: Plasmoid.title
        Accessible.description: toolTipSubText

        onClicked: Plasmoid.trigger(this, 0);
    }

    fullRepresentation: GridLayout {
        id: buttonGrid

        Plasmoid.status: {
            if (appMenuModel.menuAvailable && Plasmoid.currentIndex > -1 && buttonRepeater.count > 0) {
                return PlasmaCore.Types.NeedsAttentionStatus;
            } else {
                return buttonRepeater.count > 0 || Plasmoid.configuration.fillWidth || Plasmoid.configuration.compactView ? PlasmaCore.Types.ActiveStatus :  PlasmaCore.Types.HiddenStatus;
            }
        }

        LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
        Layout.minimumWidth: implicitWidth
        Layout.minimumHeight: implicitHeight

        flow: root.vertical ? GridLayout.TopToBottom : GridLayout.LeftToRight
        rowSpacing: 0
        columnSpacing: Plasmoid.configuration.spacing

        Binding {
            target: plasmoid
            property: "buttonGrid"
            value: buttonGrid
            restoreMode: Binding.RestoreNone
        }

        Connections {
            target: Plasmoid
            function onRequestActivateIndex(index: int) {
                const button = buttonRepeater.itemAt(index);
                if (button) {
                    button.activated();
                }
            }
        }

        Connections {
            target: Plasmoid
            function onActivated() {
                const button = buttonRepeater.itemAt(0);
                if (button) {
                    button.activated();
                }
            }
        }

        // So we can show mnemonic underlines only while Alt is pressed
        P5Support.DataSource {
            id: keystateSource
            engine: "keystate"
            connectedSources: ["Alt"]
        }

        PlasmaComponents3.Label {
            id: noMenuPlaceholder
            visible: buttonRepeater.count === 0
            text: Plasmoid.title
            verticalAlignment: Text.AlignVCenter
            Layout.fillWidth: root.vertical
            Layout.fillHeight: !root.vertical

            //This Loader is to support maximize/restore active window for plasma panels.
            MouseArea {
                anchors.fill: parent

                onDoubleClicked: {
                    if(Plasmoid.configuration.toggleMaximizedOnDoubleClick){
                        plasmoidTasksModel.requestToggleMaximized(plasmoidTasksModel.activeTask)
                    }         
                }
                onWheel: {
                    if(Plasmoid.configuration.toggleMaximizedOnMouseWheel){
                        var isMaximized = plasmoidTasksModel.data(plasmoidTasksModel.activeTask, TaskManager.AbstractTasksModel.IsMaximized)
                        if (wheel.angleDelta.y > 0 && !isMaximized) {
                            plasmoidTasksModel.requestToggleMaximized(plasmoidTasksModel.activeTask)           
                        } else if(wheel.angleDelta.y < 0 && isMaximized){
                            plasmoidTasksModel.requestToggleMaximized(plasmoidTasksModel.activeTask)
                        }
                    }       
                }
                
            }
            //---This Loader is to support maximize/restore active window for plasma panels.

                
 
        }

        Repeater {
            id: buttonRepeater
            
            model: root.isMenuAccepted? appMenuModel : null

            MenuDelegate {
                readonly property int buttonIndex: index

                Layout.fillWidth: root.vertical
                Layout.fillHeight: !root.vertical
                text: activeMenu
                // TODO: Alt and other modifiers might be unavailable on Wayland
                Kirigami.MnemonicData.active: keystateSource.data.Alt !== undefined && keystateSource.data.Alt.Pressed

                down: pressed || Plasmoid.currentIndex === index
                visible: text !== "" && model.activeActions.visible

                menuIsOpen: Plasmoid.currentIndex !== -1
                onActivated: Plasmoid.trigger(this, index)
            }
        }
        Item {
            Layout.preferredWidth: 0
            Layout.preferredHeight: 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            //This Loader is to support maximize/restore active window for plasma panels.
            MouseArea {
                anchors.fill: parent
                TaskManager.TasksModel {
                        id: plasmoidTasksModel
                }
                onDoubleClicked: {
                    if(Plasmoid.configuration.toggleMaximizedOnDoubleClick){
                        plasmoidTasksModel.requestToggleMaximized(plasmoidTasksModel.activeTask)
                    }         
                }
                onWheel: {
                    if(Plasmoid.configuration.toggleMaximizedOnMouseWheel){
                        var isMaximized = plasmoidTasksModel.data(plasmoidTasksModel.activeTask, TaskManager.AbstractTasksModel.IsMaximized)
                        if (wheel.angleDelta.y > 0 && !isMaximized) {
                            plasmoidTasksModel.requestToggleMaximized(plasmoidTasksModel.activeTask)           
                        } else if(wheel.angleDelta.y < 0 && isMaximized){
                            plasmoidTasksModel.requestToggleMaximized(plasmoidTasksModel.activeTask)
                        }
                    }       
                }
                
            }
            //---This Loader is to support maximize/restore active window for plasma panels.
        }
    }

    AppMenuPrivate.AppMenuModel {
        id: appMenuModel
                
        containmentStatus: Plasmoid.containment.status
        screenGeometry: root.screenGeometry
        onRequestActivateIndex: Plasmoid.requestActivateIndex(index)
        Component.onCompleted: {
            Plasmoid.model = appMenuModel;
        }
        readonly property bool ignoreWindow: {
            var shownFilter = !existsWindowShown;
            //var activeFilter = Plasmoid.configuration.filterByActive ? !existsWindowActive : false;
            var maximizedFilter = Plasmoid.configuration.filterByMaximized ? !isLastActiveWindowMaximized : false;
            //return (shownFilter || activeFilter || maximizedFilter);
            return (shownFilter || maximizedFilter);
        }
    }
}
