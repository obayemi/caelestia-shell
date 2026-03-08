import ".."
import "../components"
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower
import qs.components
import qs.components.controls
import qs.config
import qs.services

SectionContainer {
    id: root

    required property var rootItem
    // GPU toggle is hidden when gpuType is "NONE" (no GPU data available)
    readonly property bool gpuAvailable: SystemUsage.gpuType !== "NONE"
    // Battery toggle is hidden when no laptop battery is present
    readonly property bool batteryAvailable: UPower.displayDevice.isLaptopBattery

    Layout.fillWidth: true
    alignTop: true

    StyledText {
        text: qsTr("Performance Resources")
        font.pointSize: Appearance.font.size.normal
    }

    ConnectedButtonGroup {
        rootItem: root.rootItem
        options: {
            let opts = [];
            if (root.batteryAvailable)
                opts.push({
                    "label": qsTr("Battery"),
                    "propertyName": "showBattery",
                    "onToggled": function (checked) {
                        root.rootItem.showBattery = checked;
                        root.rootItem.saveConfig();
                    }
                });

            if (root.gpuAvailable)
                opts.push({
                    "label": qsTr("GPU"),
                    "propertyName": "showGpu",
                    "onToggled": function (checked) {
                        root.rootItem.showGpu = checked;
                        root.rootItem.saveConfig();
                    }
                });

            opts.push({
                "label": qsTr("CPU"),
                "propertyName": "showCpu",
                "onToggled": function (checked) {
                    root.rootItem.showCpu = checked;
                    root.rootItem.saveConfig();
                }
            }, {
                "label": qsTr("Memory"),
                "propertyName": "showMemory",
                "onToggled": function (checked) {
                    root.rootItem.showMemory = checked;
                    root.rootItem.saveConfig();
                }
            }, {
                "label": qsTr("Storage"),
                "propertyName": "showStorage",
                "onToggled": function (checked) {
                    root.rootItem.showStorage = checked;
                    root.rootItem.saveConfig();
                }
            }, {
                "label": qsTr("Network"),
                "propertyName": "showNetwork",
                "onToggled": function (checked) {
                    root.rootItem.showNetwork = checked;
                    root.rootItem.saveConfig();
                }
            });
            return opts;
        }
    }

    StyledRect {
        Layout.fillWidth: true
        implicitHeight: tempUnitRow.implicitHeight + Appearance.padding.large * 2
        radius: Appearance.rounding.normal
        color: Colours.layer(Colours.palette.m3surfaceContainer, 2)

        RowLayout {
            id: tempUnitRow

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: Appearance.padding.large
            spacing: Appearance.spacing.normal

            StyledText {
                Layout.fillWidth: true
                text: qsTr("Temperature unit")
            }

            RowLayout {
                spacing: Appearance.spacing.small

                TextButton {
                    text: qsTr("°C")
                    checked: root.rootItem.temperatureUnit === "celsius"
                    type: TextButton.Tonal
                    onClicked: {
                        root.rootItem.temperatureUnit = "celsius";
                        root.rootItem.saveConfig();
                    }
                }

                TextButton {
                    text: qsTr("°F")
                    checked: root.rootItem.temperatureUnit === "fahrenheit"
                    type: TextButton.Tonal
                    onClicked: {
                        root.rootItem.temperatureUnit = "fahrenheit";
                        root.rootItem.saveConfig();
                    }
                }
            }
        }
    }
}
