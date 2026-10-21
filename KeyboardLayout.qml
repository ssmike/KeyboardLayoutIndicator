import QtQuick
import Quickshell
import qs.Common
import qs.Widgets
import qs.Modules.Plugins

PluginComponent {
    id: root

    property bool showIcon: pluginData.showFlag !== false && pluginData.showIcon !== false
    property bool showText: pluginData.showText !== false
    property bool showFullName: pluginData.showFullName === true

    onPluginDataChanged: {
        const interval = parseInt(pluginData.refreshInterval) || 2000
        KeyboardService.refreshInterval = Math.max(500, interval)
    }

    popoutContent: Component {
        KeyboardPopout {}
    }
    popoutWidth: 320
    popoutHeight: 0

    pillRightClickAction: () => root.triggerPopout()

    // ── Bar pill (horizontal) ──────────────────────────────────────────────
    horizontalBarPill: Component {
        Item {
            implicitWidth: hRow.implicitWidth
            implicitHeight: hRow.implicitHeight

            Row {
                id: hRow
                anchors.centerIn: parent
                spacing: root.showIcon && root.showText ? Theme.spacingXS : 0

                DankIcon {
                    name: "language"
                    size: root.iconSize
                    color: Theme.primary
                    visible: root.showIcon
                    anchors.verticalCenter: parent.verticalCenter
                }

                StyledText {
                    id: hText
                    text: root.showFullName ? KeyboardService.fullName : KeyboardService.layout
                    font.pixelSize: Theme.fontSizeMedium
                    font.weight: Font.DemiBold
                    color: Theme.primary
                    visible: root.showText
                    anchors.verticalCenter: parent.verticalCenter

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Theme.shortDuration / 2
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                Connections {
                    target: KeyboardService
                    function onLayoutChanged() {
                        hText.opacity = 0
                        hFadeTimer.restart()
                    }
                }

                Timer {
                    id: hFadeTimer
                    interval: Theme.shortDuration / 2
                    onTriggered: hText.opacity = 1
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onClicked: KeyboardService.switchToNext()
            }
        }
    }

    // ── Bar pill (vertical) ────────────────────────────────────────────────
    verticalBarPill: Component {
        Item {
            implicitWidth: vCol.implicitWidth
            implicitHeight: vCol.implicitHeight

            Column {
                id: vCol
                anchors.centerIn: parent
                spacing: 1

                DankIcon {
                    name: "language"
                    size: root.iconSize
                    color: Theme.primary
                    visible: root.showIcon
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                StyledText {
                    id: vText
                    text: root.showFullName ? KeyboardService.fullName : KeyboardService.layout
                    font.pixelSize: Theme.fontSizeSmall
                    font.weight: Font.DemiBold
                    color: Theme.primary
                    visible: root.showText
                    anchors.horizontalCenter: parent.horizontalCenter

                    Behavior on opacity {
                        NumberAnimation {
                            duration: Theme.shortDuration / 2
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                Connections {
                    target: KeyboardService
                    function onLayoutChanged() {
                        vText.opacity = 0
                        vFadeTimer.restart()
                    }
                }

                Timer {
                    id: vFadeTimer
                    interval: Theme.shortDuration / 2
                    onTriggered: vText.opacity = 1
                }
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton
                onClicked: KeyboardService.switchToNext()
            }
        }
    }
}
