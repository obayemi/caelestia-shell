import ".."
import "../components"
import qs.components
import qs.components.controls
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

SectionContainer {
    id: root

    required property var rootItem

    Layout.fillWidth: true
    alignTop: true

    StyledText {
        text: qsTr("Background")
        font.pointSize: Appearance.font.size.normal
    }

    StyledRect {
        Layout.fillWidth: true
        implicitHeight: bgRow.implicitHeight + Appearance.padding.large * 2
        radius: Appearance.rounding.normal
        color: Colours.layer(Colours.palette.m3surfaceContainer, 2)

        RowLayout {
            id: bgRow

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.margins: Appearance.padding.large
            spacing: Appearance.spacing.normal

            StyledText {
                Layout.fillWidth: true
                text: qsTr("Mode")
            }

            RowLayout {
                spacing: Appearance.spacing.small

                TextButton {
                    text: qsTr("Blur")
                    checked: root.rootItem.backgroundMode === "blur"
                    type: TextButton.Tonal
                    onClicked: {
                        root.rootItem.backgroundMode = "blur";
                        root.rootItem.saveConfig();
                    }
                }

                TextButton {
                    text: qsTr("Wallpaper")
                    checked: root.rootItem.backgroundMode === "wallpaper"
                    type: TextButton.Tonal
                    onClicked: {
                        root.rootItem.backgroundMode = "wallpaper";
                        root.rootItem.saveConfig();
                    }
                }
            }
        }
    }
}
