import Quickshell.Io

JsonObject {
    property string logo: ""
    property Apps apps: Apps {}
    property Idle idle: Idle {}
    property Battery battery: Battery {}
    property Memory memory: Memory {}

    component Apps: JsonObject {
        property list<string> terminal: ["foot"]
        property list<string> audio: ["pavucontrol"]
        property list<string> playback: ["mpv"]
        property list<string> explorer: ["thunar"]
    }

    component Idle: JsonObject {
        property bool lockBeforeSleep: true
        property bool inhibitWhenAudio: true
        property list<var> timeouts: [
            {
                timeout: 180,
                idleAction: "lock"
            },
            {
                timeout: 300,
                idleAction: "dpms off",
                returnAction: "dpms on"
            },
            {
                timeout: 600,
                idleAction: ["systemctl", "suspend-then-hibernate"]
            }
        ]
    }

    component Memory: JsonObject {
        property int reminderInterval: 5
        property list<var> warnLevels: [
            {
                level: 60,
                title: qsTr("Memory usage elevated"),
                message: qsTr("Memory usage is above 60%"),
                icon: "memory"
            },
            {
                level: 80,
                title: qsTr("Memory usage high"),
                message: qsTr("Memory usage is above 80%"),
                icon: "memory",
                critical: false
            },
            {
                level: 90,
                title: qsTr("Critical memory usage"),
                message: qsTr("Memory usage is above 90%! Close some applications"),
                icon: "memory",
                critical: true
            }
        ]
    }

    component Battery: JsonObject {
        property list<var> warnLevels: [
            {
                level: 20,
                title: qsTr("Low battery"),
                message: qsTr("You might want to plug in a charger"),
                icon: "battery_android_frame_2"
            },
            {
                level: 10,
                title: qsTr("Did you see the previous message?"),
                message: qsTr("You should probably plug in a charger <b>now</b>"),
                icon: "battery_android_frame_1"
            },
            {
                level: 5,
                title: qsTr("Critical battery level"),
                message: qsTr("PLUG THE CHARGER RIGHT NOW!!"),
                icon: "battery_android_alert",
                critical: true
            },
        ]
        property int criticalLevel: 3
    }
}
