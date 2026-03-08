pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import Quickshell
import QtQuick

Item {
    id: root

    required property Repeater workspaces
    required property var occupied
    required property var workspaceIds

    property list<var> pills: []

    onOccupiedChanged: updatePills()
    onWorkspaceIdsChanged: updatePills()

    function updatePills(): void {
        if (!occupied || !workspaceIds)
            return;
        let count = 0;
        for (let i = 0; i < workspaceIds.length; i++) {
            const wsId = workspaceIds[i];
            if (occupied[wsId]) {
                const isFirst = i === 0 || !occupied[workspaceIds[i - 1]];
                const isLast = i === workspaceIds.length - 1 || !occupied[workspaceIds[i + 1]];
                if (isFirst) {
                    if (pills[count])
                        pills[count].startIdx = i;
                    else
                        pills.push(pillComp.createObject(root, {
                            startIdx: i
                        }));
                    count++;
                }
                if (isLast && pills[count - 1])
                    pills[count - 1].endIdx = i;
            }
        }
        if (pills.length > count)
            pills.splice(count, pills.length - count).forEach(p => p.destroy());
    }

    Repeater {
        model: ScriptModel {
            values: root.pills.filter(p => p)
        }

        StyledRect {
            id: rect

            required property var modelData

            readonly property Workspace start: root.workspaces.count > 0 ? root.workspaces.itemAt(modelData.startIdx) ?? null : null
            readonly property Workspace end: root.workspaces.count > 0 ? root.workspaces.itemAt(modelData.endIdx) ?? null : null

            anchors.horizontalCenter: root.horizontalCenter

            y: (start?.y ?? 0) - 1
            implicitWidth: Config.bar.sizes.innerWidth - Appearance.padding.small * 2 + 2
            implicitHeight: start && end ? end.y + end.size - start.y + 2 : 0

            color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 2)
            radius: Appearance.rounding.full

            scale: 0
            Component.onCompleted: scale = 1

            Behavior on scale {
                Anim {
                    easing.bezierCurve: Appearance.anim.curves.standardDecel
                }
            }

            Behavior on y {
                Anim {}
            }

            Behavior on implicitHeight {
                Anim {}
            }
        }
    }

    component Pill: QtObject {
        property int startIdx
        property int endIdx
    }

    Component {
        id: pillComp

        Pill {}
    }
}
