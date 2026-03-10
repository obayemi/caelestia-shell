import Quickshell.Io

JsonObject {
    property bool recolourLogo: false
    property bool enableFprint: true
    property int maxFprintTries: 3
    property bool showWeather: true
    property bool showFetch: true
    property bool showMedia: true
    property bool showResources: true
    property bool showNotifications: true
    property string backgroundMode: "blur"
    property Sizes sizes: Sizes {}

    component Sizes: JsonObject {
        property real heightMult: 0.7
        property real ratio: 16 / 9
        property int centerWidth: 600
    }
}
