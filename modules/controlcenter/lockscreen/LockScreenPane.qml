pragma ComponentBehavior: Bound

import ".."
import "../components"
import qs.components
import qs.components.controls
import qs.components.effects
import qs.components.containers
import qs.services
import qs.config
import qs.utils
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property Session session

    // Module visibility
    property bool showWeather: Config.lock.showWeather ?? true
    property bool showFetch: Config.lock.showFetch ?? true
    property bool showMedia: Config.lock.showMedia ?? true
    property bool showResources: Config.lock.showResources ?? true
    property bool showNotifications: Config.lock.showNotifications ?? true

    // Background mode
    property string backgroundMode: Config.lock.backgroundMode ?? "blur"

    // Auth settings
    property bool enableFprint: Config.lock.enableFprint ?? true
    property int maxFprintTries: Config.lock.maxFprintTries ?? 3
    property bool recolourLogo: Config.lock.recolourLogo ?? false

    anchors.fill: parent

    function saveConfig() {
        Config.lock.showWeather = root.showWeather;
        Config.lock.showFetch = root.showFetch;
        Config.lock.showMedia = root.showMedia;
        Config.lock.showResources = root.showResources;
        Config.lock.showNotifications = root.showNotifications;
        Config.lock.backgroundMode = root.backgroundMode;
        Config.lock.enableFprint = root.enableFprint;
        Config.lock.maxFprintTries = root.maxFprintTries;
        Config.lock.recolourLogo = root.recolourLogo;
        Config.save();
    }

    ClippingRectangle {
        id: clippingRect
        anchors.fill: parent
        anchors.margins: Appearance.padding.normal
        anchors.leftMargin: 0
        anchors.rightMargin: Appearance.padding.normal

        radius: border.innerRadius
        color: "transparent"

        Loader {
            id: contentLoader

            anchors.fill: parent
            anchors.margins: Appearance.padding.large + Appearance.padding.normal
            anchors.leftMargin: Appearance.padding.large
            anchors.rightMargin: Appearance.padding.large

            sourceComponent: contentComponent
        }
    }

    InnerBorder {
        id: border
        leftThickness: 0
        rightThickness: Appearance.padding.normal
    }

    Component {
        id: contentComponent

        StyledFlickable {
            id: flickable
            flickableDirection: Flickable.VerticalFlick
            contentHeight: layout.height

            StyledScrollBar.vertical: StyledScrollBar {
                flickable: flickable
            }

            ColumnLayout {
                id: layout
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top

                spacing: Appearance.spacing.normal

                RowLayout {
                    spacing: Appearance.spacing.smaller

                    StyledText {
                        text: qsTr("Lock Screen")
                        font.pointSize: Appearance.font.size.large
                        font.weight: 500
                    }
                }

                ModulesSection {
                    rootItem: root
                }

                BackgroundSection {
                    rootItem: root
                }

                AuthSection {
                    rootItem: root
                }
            }
        }
    }
}
