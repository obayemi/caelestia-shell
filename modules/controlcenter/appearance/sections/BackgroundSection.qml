pragma ComponentBehavior: Bound

import ".."
import "../../components"
import qs.components
import qs.components.controls
import qs.components.containers
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

CollapsibleSection {
    id: root

    required property var rootPane

    title: qsTr("Background")
    showBackground: true

    SwitchRow {
        label: qsTr("Background enabled")
        checked: rootPane.backgroundEnabled
        onToggled: checked => {
            rootPane.backgroundEnabled = checked;
            rootPane.saveConfig();
        }
    }

    SwitchRow {
        label: qsTr("Wallpaper enabled")
        checked: rootPane.wallpaperEnabled
        onToggled: checked => {
            rootPane.wallpaperEnabled = checked;
            rootPane.saveConfig();
        }
    }

    SectionContainer {
        contentSpacing: Appearance.spacing.small

        StyledText {
            text: qsTr("Wallpaper folder")
            font.pointSize: Appearance.font.size.larger
            font.weight: 500
        }

        StyledRect {
            Layout.fillWidth: true
            implicitHeight: wallpaperDirRow.implicitHeight + Appearance.padding.large * 2
            radius: Appearance.rounding.normal
            color: Colours.layer(Colours.palette.m3surfaceContainer, 2)

            RowLayout {
                id: wallpaperDirRow
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: Appearance.padding.large
                spacing: Appearance.spacing.normal

                StyledRect {
                    Layout.fillWidth: true
                    implicitHeight: wallpaperDirField.implicitHeight + Appearance.padding.small * 2
                    radius: Appearance.rounding.small
                    color: Colours.layer(Colours.palette.m3surfaceContainerHigh, 2)
                    border.width: 1
                    border.color: Colours.palette.m3outline

                    StyledTextField {
                        id: wallpaperDirField
                        anchors.fill: parent
                        anchors.margins: Appearance.padding.small
                        horizontalAlignment: TextInput.AlignLeft
                        text: rootPane.wallpaperDir
                        onEditingFinished: {
                            rootPane.wallpaperDir = text;
                            rootPane.saveConfig();
                        }
                    }
                }
            }
        }

        SwitchRow {
            label: qsTr("Random on start")
            checked: rootPane.randomOnStart
            onToggled: checked => {
                rootPane.randomOnStart = checked;
                rootPane.saveConfig();
            }
        }

        SwitchRow {
            label: qsTr("Random per screen")
            checked: rootPane.randomPerScreen
            onToggled: checked => {
                rootPane.randomPerScreen = checked;
                rootPane.saveConfig();
            }
        }

        RowLayout {
            visible: Config.background.randomPool.length > 0
            spacing: Appearance.spacing.normal

            StyledText {
                Layout.fillWidth: true
                text: qsTr("Random pool (%1 selected)").arg(Config.background.randomPool.length)
                font.pointSize: Appearance.font.size.normal
                color: Colours.palette.m3onSurfaceVariant
            }

            TextButton {
                text: qsTr("Clear")
                onClicked: {
                    Config.background.randomPool = [];
                    Config.save();
                }
            }
        }
    }

    StyledText {
        Layout.topMargin: Appearance.spacing.normal
        text: qsTr("Desktop Clock")
        font.pointSize: Appearance.font.size.larger
        font.weight: 500
    }

    SwitchRow {
        label: qsTr("Desktop Clock enabled")
        checked: rootPane.desktopClockEnabled
        onToggled: checked => {
            rootPane.desktopClockEnabled = checked;
            rootPane.saveConfig();
        }
    }

    SectionContainer {
        id: posContainer

        contentSpacing: Appearance.spacing.small
        z: 1

        readonly property var pos: (rootPane.desktopClockPosition || "top-left").split('-')
        readonly property string currentV: pos[0]
        readonly property string currentH: pos[1]

        function updateClockPos(v, h) {
            rootPane.desktopClockPosition = v + "-" + h;
            rootPane.saveConfig();
        }

        StyledText {
            text: qsTr("Positioning")
            font.pointSize: Appearance.font.size.larger
            font.weight: 500
        }

        SplitButtonRow {
            label: qsTr("Vertical Position")
            enabled: rootPane.desktopClockEnabled

            menuItems: [
                MenuItem {
                    text: qsTr("Top")
                    icon: "vertical_align_top"
                    property string val: "top"
                },
                MenuItem {
                    text: qsTr("Middle")
                    icon: "vertical_align_center"
                    property string val: "middle"
                },
                MenuItem {
                    text: qsTr("Bottom")
                    icon: "vertical_align_bottom"
                    property string val: "bottom"
                }
            ]

            Component.onCompleted: {
                for (let i = 0; i < menuItems.length; i++) {
                    if (menuItems[i].val === posContainer.currentV)
                        active = menuItems[i];
                }
            }

            // The signal from SplitButtonRow
            onSelected: item => posContainer.updateClockPos(item.val, posContainer.currentH)
        }

        SplitButtonRow {
            label: qsTr("Horizontal Position")
            enabled: rootPane.desktopClockEnabled
            expandedZ: 99

            menuItems: [
                MenuItem {
                    text: qsTr("Left")
                    icon: "align_horizontal_left"
                    property string val: "left"
                },
                MenuItem {
                    text: qsTr("Center")
                    icon: "align_horizontal_center"
                    property string val: "center"
                },
                MenuItem {
                    text: qsTr("Right")
                    icon: "align_horizontal_right"
                    property string val: "right"
                }
            ]

            Component.onCompleted: {
                for (let i = 0; i < menuItems.length; i++) {
                    if (menuItems[i].val === posContainer.currentH)
                        active = menuItems[i];
                }
            }

            onSelected: item => posContainer.updateClockPos(posContainer.currentV, item.val)
        }
    }

    SwitchRow {
        label: qsTr("Invert colors")
        checked: rootPane.desktopClockInvertColors
        onToggled: checked => {
            rootPane.desktopClockInvertColors = checked;
            rootPane.saveConfig();
        }
    }

    SectionContainer {
        contentSpacing: Appearance.spacing.small

        StyledText {
            text: qsTr("Shadow")
            font.pointSize: Appearance.font.size.larger
            font.weight: 500
        }

        SwitchRow {
            label: qsTr("Enabled")
            checked: rootPane.desktopClockShadowEnabled
            onToggled: checked => {
                rootPane.desktopClockShadowEnabled = checked;
                rootPane.saveConfig();
            }
        }

        SectionContainer {
            contentSpacing: Appearance.spacing.normal

            SliderInput {
                Layout.fillWidth: true

                label: qsTr("Opacity")
                value: rootPane.desktopClockShadowOpacity * 100
                from: 0
                to: 100
                suffix: "%"
                validator: IntValidator {
                    bottom: 0
                    top: 100
                }
                formatValueFunction: val => Math.round(val).toString()
                parseValueFunction: text => parseInt(text)

                onValueModified: newValue => {
                    rootPane.desktopClockShadowOpacity = newValue / 100;
                    rootPane.saveConfig();
                }
            }
        }

        SectionContainer {
            contentSpacing: Appearance.spacing.normal

            SliderInput {
                Layout.fillWidth: true

                label: qsTr("Blur")
                value: rootPane.desktopClockShadowBlur * 100
                from: 0
                to: 100
                suffix: "%"
                validator: IntValidator {
                    bottom: 0
                    top: 100
                }
                formatValueFunction: val => Math.round(val).toString()
                parseValueFunction: text => parseInt(text)

                onValueModified: newValue => {
                    rootPane.desktopClockShadowBlur = newValue / 100;
                    rootPane.saveConfig();
                }
            }
        }
    }

    SectionContainer {
        contentSpacing: Appearance.spacing.small

        StyledText {
            text: qsTr("Background")
            font.pointSize: Appearance.font.size.larger
            font.weight: 500
        }

        SwitchRow {
            label: qsTr("Enabled")
            checked: rootPane.desktopClockBackgroundEnabled
            onToggled: checked => {
                rootPane.desktopClockBackgroundEnabled = checked;
                rootPane.saveConfig();
            }
        }

        SwitchRow {
            label: qsTr("Blur enabled")
            checked: rootPane.desktopClockBackgroundBlur
            onToggled: checked => {
                rootPane.desktopClockBackgroundBlur = checked;
                rootPane.saveConfig();
            }
        }

        SectionContainer {
            contentSpacing: Appearance.spacing.normal

            SliderInput {
                Layout.fillWidth: true

                label: qsTr("Opacity")
                value: rootPane.desktopClockBackgroundOpacity * 100
                from: 0
                to: 100
                suffix: "%"
                validator: IntValidator {
                    bottom: 0
                    top: 100
                }
                formatValueFunction: val => Math.round(val).toString()
                parseValueFunction: text => parseInt(text)

                onValueModified: newValue => {
                    rootPane.desktopClockBackgroundOpacity = newValue / 100;
                    rootPane.saveConfig();
                }
            }
        }
    }

    StyledText {
        Layout.topMargin: Appearance.spacing.normal
        text: qsTr("Visualiser")
        font.pointSize: Appearance.font.size.larger
        font.weight: 500
    }

    SwitchRow {
        label: qsTr("Visualiser enabled")
        checked: rootPane.visualiserEnabled
        onToggled: checked => {
            rootPane.visualiserEnabled = checked;
            rootPane.saveConfig();
        }
    }

    SwitchRow {
        label: qsTr("Visualiser auto hide")
        checked: rootPane.visualiserAutoHide
        onToggled: checked => {
            rootPane.visualiserAutoHide = checked;
            rootPane.saveConfig();
        }
    }

    SectionContainer {
        contentSpacing: Appearance.spacing.normal

        SliderInput {
            Layout.fillWidth: true

            label: qsTr("Visualiser rounding")
            value: rootPane.visualiserRounding
            from: 0
            to: 10
            stepSize: 1
            validator: IntValidator {
                bottom: 0
                top: 10
            }
            formatValueFunction: val => Math.round(val).toString()
            parseValueFunction: text => parseInt(text)

            onValueModified: newValue => {
                rootPane.visualiserRounding = Math.round(newValue);
                rootPane.saveConfig();
            }
        }
    }

    SectionContainer {
        contentSpacing: Appearance.spacing.normal

        SliderInput {
            Layout.fillWidth: true

            label: qsTr("Visualiser spacing")
            value: rootPane.visualiserSpacing
            from: 0
            to: 2
            validator: DoubleValidator {
                bottom: 0
                top: 2
            }

            onValueModified: newValue => {
                rootPane.visualiserSpacing = newValue;
                rootPane.saveConfig();
            }
        }
    }
}
