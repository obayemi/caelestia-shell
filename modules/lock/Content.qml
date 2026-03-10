import qs.components
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root

    required property var lock

    readonly property bool leftColumnVisible: Config.lock.showWeather || Config.lock.showFetch || Config.lock.showMedia
    readonly property bool rightColumnVisible: Config.lock.showResources || Config.lock.showNotifications

    spacing: Appearance.spacing.large * 2

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Appearance.spacing.normal
        visible: root.leftColumnVisible

        StyledRect {
            id: weatherRect

            Layout.fillWidth: true
            implicitHeight: weather.implicitHeight
            visible: Config.lock.showWeather

            topLeftRadius: Appearance.rounding.large
            radius: Appearance.rounding.small
            bottomLeftRadius: !Config.lock.showFetch && !Config.lock.showMedia ? Appearance.rounding.large : Appearance.rounding.small
            color: Colours.tPalette.m3surfaceContainer

            WeatherInfo {
                id: weather

                rootHeight: root.height
            }
        }

        StyledRect {
            id: fetchRect

            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: Config.lock.showFetch

            radius: Appearance.rounding.small
            topLeftRadius: !Config.lock.showWeather ? Appearance.rounding.large : Appearance.rounding.small
            bottomLeftRadius: !Config.lock.showMedia ? Appearance.rounding.large : Appearance.rounding.small
            color: Colours.tPalette.m3surfaceContainer

            Fetch {}
        }

        StyledClippingRect {
            id: mediaRect

            Layout.fillWidth: true
            implicitHeight: media.implicitHeight
            visible: Config.lock.showMedia

            radius: Appearance.rounding.small
            topLeftRadius: !Config.lock.showWeather && !Config.lock.showFetch ? Appearance.rounding.large : Appearance.rounding.small
            bottomLeftRadius: Appearance.rounding.large
            color: Colours.tPalette.m3surfaceContainer

            Media {
                id: media

                lock: root.lock
            }
        }
    }

    Center {
        lock: root.lock
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Appearance.spacing.normal
        visible: root.rightColumnVisible

        StyledRect {
            id: resourcesRect

            Layout.fillWidth: true
            implicitHeight: resources.implicitHeight
            visible: Config.lock.showResources

            topRightRadius: Appearance.rounding.large
            radius: Appearance.rounding.small
            bottomRightRadius: !Config.lock.showNotifications ? Appearance.rounding.large : Appearance.rounding.small
            color: Colours.tPalette.m3surfaceContainer

            Resources {
                id: resources
            }
        }

        StyledRect {
            id: notifsRect

            Layout.fillWidth: true
            Layout.fillHeight: true
            visible: Config.lock.showNotifications

            radius: Appearance.rounding.small
            topRightRadius: !Config.lock.showResources ? Appearance.rounding.large : Appearance.rounding.small
            bottomRightRadius: Appearance.rounding.large
            color: Colours.tPalette.m3surfaceContainer

            NotifDock {
                lock: root.lock
            }
        }
    }
}
