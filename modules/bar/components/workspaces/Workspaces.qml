pragma ComponentBehavior: Bound

import qs.services
import qs.config
import qs.components
import qs.utils
import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

StyledClippingRect {
    id: root

    required property ShellScreen screen

    readonly property bool perMonitor: Config.bar.workspaces.perMonitorWorkspaces
    readonly property HyprlandMonitor monitor: Hypr.monitorFor(screen)
    readonly property bool onSpecial: (perMonitor ? monitor : Hypr.focusedMonitor)?.lastIpcObject?.specialWorkspace?.name !== ""
    readonly property int activeWsId: perMonitor ? (monitor?.activeWorkspace?.id ?? 1) : Hypr.activeWsId

    readonly property var occupied: Hypr.workspaces.values.reduce((acc, curr) => {
        if (!root.perMonitor || curr.monitor === root.monitor)
            acc[curr.id] = curr.lastIpcObject.windows > 0;
        return acc;
    }, {})
    readonly property int groupOffset: Math.floor((activeWsId - 1) / Config.bar.workspaces.shown) * Config.bar.workspaces.shown

    readonly property var workspaceIds: {
        if (Config.bar.workspaces.dynamic) {
            return Hypr.workspaces.values.filter(w => !w.name.startsWith("special:") && (!root.perMonitor || !root.monitor || w.monitor === root.monitor)).sort((a, b) => a.id - b.id).map(w => w.id);
        } else {
            const ids = [];
            for (let i = 0; i < Config.bar.workspaces.shown; i++)
                ids.push(groupOffset + i + 1);
            return ids;
        }
    }

    property real blur: onSpecial ? 1 : 0

    implicitWidth: Config.bar.sizes.innerWidth
    implicitHeight: layout.implicitHeight + Appearance.padding.small * 2

    color: Colours.tPalette.m3surfaceContainer
    radius: Appearance.rounding.full

    Item {
        anchors.fill: parent
        scale: root.onSpecial ? 0.8 : 1
        opacity: root.onSpecial ? 0.5 : 1

        layer.enabled: root.blur > 0
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: root.blur
            blurMax: 32
        }

        Loader {
            active: Config.bar.workspaces.occupiedBg

            anchors.fill: parent
            anchors.margins: Appearance.padding.small

            sourceComponent: OccupiedBg {
                workspaces: workspaces
                occupied: root.occupied
                workspaceIds: root.workspaceIds
            }
        }

        ColumnLayout {
            id: layout

            anchors.centerIn: parent
            spacing: Math.floor(Appearance.spacing.small / 2)

            Repeater {
                id: workspaces

                model: ScriptModel {
                    values: root.workspaceIds
                }

                Workspace {
                    activeWsId: root.activeWsId
                    occupied: root.occupied
                }
            }
        }

        Loader {
            anchors.horizontalCenter: parent.horizontalCenter
            active: Config.bar.workspaces.activeIndicator

            sourceComponent: ActiveIndicator {
                activeWsId: root.activeWsId
                workspaces: workspaces
                workspaceIds: root.workspaceIds
                mask: layout
            }
        }

        MouseArea {
            anchors.fill: layout
            onClicked: event => {
                const child = layout.childAt(event.x, event.y);
                if (!child)
                    return;
                const ws = child.ws;
                if (root.activeWsId !== ws)
                    Hypr.dispatch(`workspace ${ws}`);
                else
                    Hypr.dispatch("togglespecialworkspace special");
            }
        }

        Behavior on scale {
            Anim {}
        }

        Behavior on opacity {
            Anim {}
        }
    }

    Loader {
        id: specialWs

        anchors.fill: parent
        anchors.margins: Appearance.padding.small

        active: opacity > 0

        scale: root.onSpecial ? 1 : 0.5
        opacity: root.onSpecial ? 1 : 0

        sourceComponent: SpecialWorkspaces {
            screen: root.screen
        }

        Behavior on scale {
            Anim {}
        }

        Behavior on opacity {
            Anim {}
        }
    }

    Behavior on blur {
        Anim {
            duration: Appearance.anim.durations.small
        }
    }
}
