import Quickshell.Io

JsonObject {
    property bool expire: true
    property int defaultExpireTimeout: 5000
    property real clearThreshold: 0.3
    property int expandThreshold: 20
    property bool actionOnClick: false
    property int groupPreviewNum: 3
    property bool openExpanded: false // Show the notifichation in expanded state when opening
    property bool focusOnClick: false // Click notification to focus the source app window
    property bool expandOnHover: false // Expand notification on mouse hover
    property Sizes sizes: Sizes {}

    component Sizes: JsonObject {
        property int width: 400
        property int image: 41
        property int badge: 20
    }
}
