import qs.components.misc
import qs.config
import qs.services
import Caelestia
import Quickshell
import QtQuick

Scope {
    id: root

    readonly property list<var> warnLevels: [...Config.general.memory.warnLevels].sort((a, b) => b.level - a.level)
    property int activeLevel: -1

    Ref {
        service: SystemUsage
    }

    function notifyLevel(level: var): void {
        Toaster.toast(level.title ?? qsTr("Memory warning"), level.message ?? qsTr("Memory usage is high"), level.icon ?? "memory", level.critical ? Toast.Error : Toast.Warning);
    }

    function highestExceededLevel(): int {
        const p = SystemUsage.memPerc * 100;
        for (let i = 0; i < root.warnLevels.length; i++) {
            if (p >= root.warnLevels[i].level)
                return i;
        }
        return -1;
    }

    Connections {
        target: SystemUsage

        function onMemPercChanged(): void {
            if (!Config.utilities.toasts.memoryWarning)
                return;

            const idx = root.highestExceededLevel();

            if (idx === -1) {
                // Below all thresholds — reset
                if (root.activeLevel !== -1) {
                    root.activeLevel = -1;
                    reminderTimer.stop();
                }
                return;
            }

            if (idx !== root.activeLevel) {
                // Crossed into a new (higher or lower) threshold
                root.activeLevel = idx;
                root.notifyLevel(root.warnLevels[idx]);
                reminderTimer.restart();
            }
        }
    }

    Timer {
        id: reminderTimer

        interval: Config.general.memory.reminderInterval * 60000
        repeat: true
        running: false

        onTriggered: {
            if (!Config.utilities.toasts.memoryWarning || root.activeLevel === -1)
                return;

            const idx = root.highestExceededLevel();
            if (idx === -1) {
                root.activeLevel = -1;
                reminderTimer.stop();
                return;
            }

            root.activeLevel = idx;
            root.notifyLevel(root.warnLevels[idx]);
        }
    }
}
