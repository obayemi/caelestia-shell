pragma Singleton

import qs.config
import qs.utils
import Caelestia.Models
import Quickshell
import Quickshell.Io
import QtQuick

Searcher {
    id: root

    readonly property string currentNamePath: `${Paths.state}/wallpaper/path.txt`
    readonly property list<string> smartArg: Config.services.smartScheme ? [] : ["--no-smart"]

    property bool showPreview: false
    readonly property string current: showPreview ? previewPath : actualCurrent
    property string previewPath
    property string actualCurrent
    property bool previewColourLock

    // Per-screen wallpaper support for random per-screen mode
    property var perScreenPaths: ({})

    // Per-screen color analysis
    property var perScreenLuminance: ({})
    property var perScreenDominant: ({})

    function luminanceFor(screenName: string): real {
        return perScreenLuminance[screenName] ?? Colours.wallLuminance;
    }

    function dominantFor(screenName: string): color {
        return perScreenDominant[screenName] ?? Colours.palette.m3primary;
    }

    function setScreenAnalysis(screenName: string, luminance: real, dominant: color): void {
        const lum = Object.assign({}, perScreenLuminance);
        lum[screenName] = luminance;
        perScreenLuminance = lum;
        const dom = Object.assign({}, perScreenDominant);
        dom[screenName] = dominant;
        perScreenDominant = dom;
    }

    // Startup randomize state
    property bool startupDone: false
    property bool skipNextFileLoad: false

    function tryStartupRandomize(): void {
        if (!startupDone && Config.background.randomOnStart && wallpapers.entries.length > 0) {
            startupDone = true;
            randomize();
        }
    }

    function wallpaperFor(screenName: string): string {
        if (showPreview)
            return previewPath;
        return perScreenPaths[screenName] || actualCurrent;
    }

    function setWallpaper(path: string): void {
        perScreenPaths = ({});
        actualCurrent = path;
        Quickshell.execDetached(["caelestia", "wallpaper", "-f", path, ...smartArg]);
    }

    function randomize(): void {
        const allWallpapers = wallpapers.entries;
        if (allWallpapers.length === 0)
            return;

        const pool = Config.background.randomPool;
        let candidates = allWallpapers;
        if (pool.length > 0) {
            const poolSet = new Set(pool);
            const filtered = allWallpapers.filter(w => poolSet.has(w.path));
            if (filtered.length > 0)
                candidates = filtered;
        }

        if (Config.background.randomPerScreen) {
            const newPaths = {};
            for (const screen of Quickshell.screens) {
                const idx = Math.floor(Math.random() * candidates.length);
                newPaths[screen.name] = candidates[idx].path;
            }
            perScreenPaths = newPaths;
        } else {
            const idx = Math.floor(Math.random() * candidates.length);
            perScreenPaths = ({});
            skipNextFileLoad = true;
            setWallpaper(candidates[idx].path);
        }
    }

    function preview(path: string): void {
        previewPath = path;
        showPreview = true;

        if (Colours.scheme === "dynamic")
            getPreviewColoursProc.running = true;
    }

    function stopPreview(): void {
        showPreview = false;
        if (!previewColourLock)
            Colours.showPreview = false;
    }

    list: wallpapers.entries
    key: "relativePath"
    useFuzzy: Config.launcher.useFuzzy.wallpapers
    extraOpts: useFuzzy ? ({}) : ({
            forward: false
        })

    IpcHandler {
        target: "wallpaper"

        function get(): string {
            return root.actualCurrent;
        }

        function set(path: string): void {
            root.setWallpaper(path);
        }

        function list(): string {
            return root.list.map(w => w.path).join("\n");
        }

        function randomize(): string {
            root.randomize();
            return "OK";
        }

        function getPool(): string {
            return Config.background.randomPool.join("\n");
        }

        function addToPool(path: string): string {
            const pool = [...Config.background.randomPool];
            if (!pool.includes(path)) {
                pool.push(path);
                Config.background.randomPool = pool;
                Config.save();
            }
            return "OK";
        }

        function removeFromPool(path: string): string {
            const pool = [...Config.background.randomPool];
            const idx = pool.indexOf(path);
            if (idx !== -1) {
                pool.splice(idx, 1);
                Config.background.randomPool = pool;
                Config.save();
            }
            return "OK";
        }

        function clearPool(): string {
            Config.background.randomPool = [];
            Config.save();
            return "OK";
        }
    }

    FileView {
        path: root.currentNamePath
        watchChanges: true
        onFileChanged: reload()
        onLoaded: {
            if (root.skipNextFileLoad) {
                root.skipNextFileLoad = false;
                root.previewColourLock = false;
                return;
            }
            root.actualCurrent = text().trim();
            root.previewColourLock = false;
        }
    }

    FileSystemModel {
        id: wallpapers

        recursive: true
        path: Paths.wallsdir
        filter: FileSystemModel.Images
        onEntriesChanged: root.tryStartupRandomize()
    }

    Process {
        id: getPreviewColoursProc

        command: ["caelestia", "wallpaper", "-p", root.previewPath, ...root.smartArg]
        stdout: StdioCollector {
            onStreamFinished: {
                Colours.load(text, true);
                Colours.showPreview = true;
            }
        }
    }
}
