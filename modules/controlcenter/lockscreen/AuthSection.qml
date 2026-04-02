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
        text: qsTr("Authentication")
        font.pointSize: Appearance.font.size.normal
    }

    SwitchRow {
        label: qsTr("Fingerprint unlock")
        checked: root.rootItem.enableFprint
        onToggled: checked => {
            root.rootItem.enableFprint = checked;
            root.rootItem.saveConfig();
        }
    }

    SectionContainer {
        contentSpacing: Appearance.spacing.normal

        SliderInput {
            Layout.fillWidth: true

            label: qsTr("Max fingerprint tries")
            value: root.rootItem.maxFprintTries
            from: 1
            to: 10
            stepSize: 1
            validator: IntValidator {
                bottom: 1
                top: 10
            }
            formatValueFunction: val => Math.round(val).toString()
            parseValueFunction: text => parseInt(text)

            onValueModified: newValue => {
                root.rootItem.maxFprintTries = Math.round(newValue);
                root.rootItem.saveConfig();
            }
        }
    }

    SwitchRow {
        label: qsTr("Recolour logo")
        checked: root.rootItem.recolourLogo
        onToggled: checked => {
            root.rootItem.recolourLogo = checked;
            root.rootItem.saveConfig();
        }
    }
}
