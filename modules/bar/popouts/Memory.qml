import qs.components
import qs.components.misc
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

Column {
    id: root

    spacing: Appearance.spacing.normal
    width: Config.bar.sizes.batteryWidth

    Ref {
        service: SystemUsage
    }

    RowLayout {
        width: parent.width
        spacing: Appearance.spacing.small

        MaterialIcon {
            text: "memory_alt"
            fill: 1
            color: Colours.palette.m3tertiary
            font.pointSize: Appearance.spacing.large
        }

        StyledText {
            Layout.fillWidth: true
            text: qsTr("Memory")
            font.pointSize: Appearance.font.size.normal
            elide: Text.ElideRight
        }
    }

    Item {
        width: parent.width
        height: width

        Canvas {
            id: gaugeCanvas

            readonly property real arcStartAngle: 0.75 * Math.PI
            readonly property real arcSweep: 1.5 * Math.PI
            property real animatedPercentage: 0

            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height)
            height: width

            Connections {
                target: SystemUsage

                function onMemPercChanged(): void {
                    gaugeCanvas.animatedPercentage = SystemUsage.memPerc;
                }
            }

            onPaint: {
                const ctx = getContext("2d");
                ctx.reset();
                const cx = width / 2;
                const cy = height / 2;
                const radius = (Math.min(width, height) - 12) / 2;
                const lineWidth = 10;
                ctx.beginPath();
                ctx.arc(cx, cy, radius, arcStartAngle, arcStartAngle + arcSweep);
                ctx.lineWidth = lineWidth;
                ctx.lineCap = "round";
                ctx.strokeStyle = Colours.layer(Colours.palette.m3surfaceContainerHigh, 2);
                ctx.stroke();
                if (animatedPercentage > 0) {
                    ctx.beginPath();
                    ctx.arc(cx, cy, radius, arcStartAngle, arcStartAngle + arcSweep * animatedPercentage);
                    ctx.lineWidth = lineWidth;
                    ctx.lineCap = "round";
                    ctx.strokeStyle = Colours.palette.m3tertiary;
                    ctx.stroke();
                }
            }

            Component.onCompleted: {
                animatedPercentage = SystemUsage.memPerc;
                requestPaint();
            }

            Connections {
                function onAnimatedPercentageChanged() {
                    gaugeCanvas.requestPaint();
                }

                target: gaugeCanvas
            }

            Connections {
                function onPaletteChanged() {
                    gaugeCanvas.requestPaint();
                }

                target: Colours
            }

            Behavior on animatedPercentage {
                Anim {
                    duration: Appearance.anim.durations.large
                }
            }
        }

        StyledText {
            anchors.centerIn: parent
            text: `${Math.round(SystemUsage.memPerc * 100)}%`
            font.pointSize: Appearance.font.size.extraLarge
            font.weight: Font.Medium
            color: Colours.palette.m3tertiary
        }
    }

    StyledText {
        anchors.horizontalCenter: parent.horizontalCenter
        text: {
            const usedFmt = SystemUsage.formatKib(SystemUsage.memUsed);
            const totalFmt = SystemUsage.formatKib(SystemUsage.memTotal);
            return `${usedFmt.value.toFixed(1)} / ${Math.floor(totalFmt.value)} ${totalFmt.unit}`;
        }
        font.pointSize: Appearance.font.size.smaller
        color: Colours.palette.m3onSurfaceVariant
    }
}
