import AVFoundation
import SnapKit
import TDDesign
import UIKit

final class QRScannerViewController: UIViewController {
    // MARK: - Callback

    var onSessionTokenDetected: ((String) -> Void)?

    // MARK: - AVFoundation

    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    private var hasDetected = false

    // MARK: - UI

    private let dimView = UIView().then {
        $0.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }

    private let scanFrameView = UIView().then {
        $0.layer.borderColor = TDColor.Primary.primary500.cgColor
        $0.layer.borderWidth = 3
        $0.layer.cornerRadius = 16
        $0.backgroundColor = .clear
    }

    private let guideLabel = TDLabel(
        toduckFont: .mediumBody2,
        toduckColor: TDColor.baseWhite
    ).then {
        $0.setText("웹 페이지의 QR 코드를 네모 안에 맞춰주세요")
        $0.textAlignment = .center
    }

    private let closeButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = TDColor.baseWhite
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCamera()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !captureSession.isRunning {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.captureSession.startRunning()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning {
            captureSession.stopRunning()
        }
    }

    // MARK: - Camera Setup

    private func setupCamera() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else {
            showCameraUnavailableAlert()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        captureSession.beginConfiguration()

        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
            metadataOutput.metadataObjectTypes = [.qr]
        }

        captureSession.commitConfiguration()

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)
        self.previewLayer = previewLayer

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    // MARK: - UI Setup

    private func setupUI() {
        view.addSubview(dimView)
        view.addSubview(scanFrameView)
        view.addSubview(guideLabel)
        view.addSubview(closeButton)

        dimView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        let scanSize: CGFloat = 260
        scanFrameView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(scanSize)
        }

        guideLabel.snp.makeConstraints {
            $0.top.equalTo(scanFrameView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(44)
        }

        // scanFrame 영역은 투명하게 뚫어주기
        view.layoutIfNeeded()
        applyDimMask()

        closeButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .touchUpInside)
    }

    private func applyDimMask() {
        let path = UIBezierPath(rect: view.bounds)
        let scanFrame = scanFrameView.frame
        let scanPath = UIBezierPath(roundedRect: scanFrame, cornerRadius: 16)
        path.append(scanPath)
        path.usesEvenOddFillRule = true

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        dimView.layer.mask = maskLayer
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
        applyDimMask()
        updateScanRectOfInterest()
    }

    private func updateScanRectOfInterest() {
        guard let previewLayer else { return }
        let scanFrame = scanFrameView.frame
        // AVFoundation 좌표계 변환 (정규화, 원점이 우하단)
        let metadataOutput = captureSession.outputs.first as? AVCaptureMetadataOutput
        metadataOutput?.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: scanFrame)
    }

    // MARK: - Helpers

    private func showCameraUnavailableAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "카메라를 사용할 수 없어요",
                message: "설정에서 카메라 접근 권한을 허용해 주세요.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            })
            alert.addAction(UIAlertAction(title: "닫기", style: .cancel) { [weak self] _ in
                self?.dismiss(animated: true)
            })
            self.present(alert, animated: true)
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard !hasDetected,
              let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let rawString = metadata.stringValue,
              let url = URL(string: rawString) else { return }

        // https://toduck.app/_ul/w/{sessionToken} 패턴 확인
        guard url.host == "toduck.app",
              url.path.hasPrefix("/_ul/w/") else { return }

        let sessionToken = String(url.path.dropFirst("/_ul/w/".count))
        guard !sessionToken.isEmpty else { return }

        hasDetected = true
        captureSession.stopRunning()

        onSessionTokenDetected?(sessionToken)
    }
}
