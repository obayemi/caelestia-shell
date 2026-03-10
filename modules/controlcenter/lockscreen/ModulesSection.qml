import ".."
import "../components"
import QtQuick
import QtQuick.Layouts
import qs.components
import qs.components.controls
import qs.config
import qs.services

SectionContainer {
    id: root

    required property var rootItem

    Layout.fillWidth: true
    alignTop: true

    StyledText {
        text: qsTr("Modules")
        font.pointSize: Appearance.font.size.normal
    }

    ConnectedButtonGroup {
        rootItem: root.rootItem
        options: [
            {
                "label": qsTr("Weather"),
                "propertyName": "showWeather",
                "onToggled": function (checked) {
                    root.rootItem.showWeather = checked;
                    root.rootItem.saveConfig();
                }
            },
            {
                "label": qsTr("Fetch"),
                "propertyName": "showFetch",
                "onToggled": function (checked) {
                    root.rootItem.showFetch = checked;
                    root.rootItem.saveConfig();
                }
            },
            {
                "label": qsTr("Media"),
                "propertyName": "showMedia",
                "onToggled": function (checked) {
                    root.rootItem.showMedia = checked;
                    root.rootItem.saveConfig();
                }
            },
            {
                "label": qsTr("Resources"),
                "propertyName": "showResources",
                "onToggled": function (checked) {
                    root.rootItem.showResources = checked;
                    root.rootItem.saveConfig();
                }
            },
            {
                "label": qsTr("Notifications"),
                "propertyName": "showNotifications",
                "onToggled": function (checked) {
                    root.rootItem.showNotifications = checked;
                    root.rootItem.saveConfig();
                }
            }
        ]
    }
}
