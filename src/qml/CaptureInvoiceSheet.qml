import QtQuick 2.7
import QtQuick.Controls 2.0 as QQC2
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.1 as Kirigami

import QtMultimedia 5.8
import QZXing 2.3

Kirigami.OverlaySheet {
    onSheetOpenChanged: {
        if (sheetOpen) {
            qrScannerViewfinder.camera.start()
        }
        else {
            qrScannerViewfinder.camera.stop()
        }
    }

    header:
        OverlaySheetHeader {
        text: qsTr("Scan QR Code")
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
    }


    ColumnLayout {
        id: columnLayout

        QRScannerViewfinder {
            id: qrScannerViewfinder
            width: parent.width * 0.9
            height: width
            Layout.alignment: Qt.AlignCenter
            zxingFilter.decoder.onTagFound: {
                checkIfValidBolt11(tag)
            }
        }

        QQC2.TextArea {
            Layout.topMargin: Kirigami.Units.gridUnit / 2
            id: pasteTextArea
            font: fixedFont
            selectByMouse: true
            wrapMode: Text.WrapAnywhere
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: qrScannerViewfinder.width
            placeholderText: qsTr("Or Paste Invoice Here")
            onTextChanged: {
                checkIfValidBolt11(text);
            }
        }
    }

    function checkIfValidBolt11(text) {
        if (text.startsWith("lightning:")) {
            text = text.slice(10)
        }

        payInvoiceSheet.bolt11 = text
        paymentsModel.decodePayment(text);
    }
}

