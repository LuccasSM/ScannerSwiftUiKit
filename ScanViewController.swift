import AVFoundation
import UIKit

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    @IBOutlet weak var grView: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    
    let systemSoundID: SystemSoundID = 1016
    let lineRed = UIView(frame: .zero)
    let imageClose = UIImageView(frame: .zero)
    let textPixCopy = UILabel(frame: .zero)
    let ligaLanterna = UIButton(frame: .zero)
    let lanterna = UIImageView(frame: .zero)
    let footer = UIView(frame: .zero)
    let topBorderFooter = CALayer()
    let imagePagar = UIImageView(frame: .zero)
    let textPagar = UILabel(frame: .zero)
    let imageCobrar = UIImageView(frame: .zero)
    let textCobrar = UILabel(frame: .zero)
    
//    override func viewWillAppear(_ animated: Bool) {
//        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {}
        
        reStart()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeLeft)
        view.isUserInteractionEnabled = true
        
        //----------------------------------------------------------------------------//
        
        lineRed.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineRed)
        lineRed.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lineRed.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        lineRed.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        lineRed.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        lineRed.backgroundColor = UIColor(red: CGFloat(234.0/255.0), green: CGFloat(0.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0))
        lineRed.layer.zPosition = 1
        
        //----------------------------------------------------------------------------//
        
        imageClose.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageClose)
        imageClose.image = UIImage(named: "cancel")
        imageClose.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30).isActive = true
        imageClose.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30).isActive = true
        imageClose.widthAnchor.constraint(equalToConstant: 20).isActive = true
        imageClose.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //----------------------------------------------------------------------------//
        
        textPixCopy.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textPixCopy)
        textPixCopy.attributedText = NSAttributedString(string: "Pix copia e cola", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        textPixCopy.textColor = .white
        textPixCopy.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -120).isActive = true
        textPixCopy.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        //----------------------------------------------------------------------------//
        
        ligaLanterna.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(ligaLanterna)
        ligaLanterna.backgroundColor = .white
        ligaLanterna.widthAnchor.constraint(equalToConstant: 50).isActive = true
        ligaLanterna.heightAnchor.constraint(equalToConstant: 50).isActive = true
        ligaLanterna.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        ligaLanterna.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 90).isActive = true
        ligaLanterna.addTarget(self, action: #selector(flashlight), for: .touchUpInside)
        ligaLanterna.layer.cornerRadius = 25
        
        lanterna.translatesAutoresizingMaskIntoConstraints = false
        ligaLanterna.addSubview(lanterna)
        lanterna.image = UIImage(named: "lanterna")
        lanterna.widthAnchor.constraint(equalToConstant: 25).isActive = true
        lanterna.heightAnchor.constraint(equalToConstant: 25).isActive = true
        lanterna.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        lanterna.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 90).isActive = true
        
        //----------------------------------------------------------------------------//
        
        footer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footer)
        footer.backgroundColor = .white
        footer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        footer.heightAnchor.constraint(equalToConstant: 70).isActive = true
        footer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        footer.addSubview(imagePagar)
        footer.addSubview(textPagar)
        footer.addSubview(imageCobrar)
        footer.addSubview(textCobrar)
        
        //----------------------------------------------------------------------------//
        
        imagePagar.translatesAutoresizingMaskIntoConstraints = false
        topBorderFooter.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0, blue: 0, alpha: 1)
        topBorderFooter.frame = CGRect(x: 0, y: 0, width: view.frame.width/2, height: 2)
        footer.layer.addSublayer(topBorderFooter)
        
        //----------------------------------------------------------------------------//
        
        imagePagar.translatesAutoresizingMaskIntoConstraints = false
        imagePagar.image = UIImage(named: "pagar-codebars")
        imagePagar.widthAnchor.constraint(equalToConstant: 28).isActive = true
        imagePagar.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imagePagar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -35).isActive = true
        imagePagar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 65).isActive = true
        
        //----------------------------------------------------------------------------//
        
        textPagar.translatesAutoresizingMaskIntoConstraints = false
        textPagar.text = "Pagar"
        textPagar.textColor = UIColor(red: CGFloat(203.0/255.0), green: CGFloat(1.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0))
        textPagar.font = UIFont.systemFont(ofSize: 12)
        textPagar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        textPagar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 63).isActive = true
        
        //----------------------------------------------------------------------------//
        
        imageCobrar.translatesAutoresizingMaskIntoConstraints = false
        imageCobrar.image = UIImage(named: "cobrar-qrcode")
        imageCobrar.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageCobrar.heightAnchor.constraint(equalToConstant: 25).isActive = true
        imageCobrar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -35).isActive = true
        imageCobrar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -65).isActive = true
        
        //----------------------------------------------------------------------------//
        
        textCobrar.translatesAutoresizingMaskIntoConstraints = false
        textCobrar.text = "Cobrar"
        textCobrar.font = UIFont.systemFont(ofSize: 12)
        textCobrar.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true
        textCobrar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -58).isActive = true
    
    }
                     
    @objc func swipe(){
        self.dismiss(animated: true, completion: nil)
    }

    func reStart(){
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .code39, .code128, .qr]
        } else {
            failed()
            
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = self.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }
    
    @objc func goBackAgain(){}
    
    func failed() {
        let ac = UIAlertController(title: "Digitalização não suportada", message: "Seu dispositivo não suporta a leitura de um código de um item. Use um dispositivo com câmera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
           
        }

        dismiss(animated: true)
    }

    func found(code: String) {
        
        AudioServicesPlaySystemSound(systemSoundID)
        print("CODIGO => \(code)")
        
        let ac = UIAlertController(title: "Sucesso de digitalização", message: "\(code)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            _ in

        }))
        
        self.present(ac, animated: true)
        self.code = code
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            self.reStart()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    var code: String!
    
    @objc func flashlight() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else{
            return
        }
    if (device.hasTorch) {
        do {
        try device.lockForConfiguration()
        if (device.torchMode == .on) {
        device.torchMode = .off
        } else {
            device.torchMode = .on

        }
            device.unlockForConfiguration()
        } catch {
            print("Scanner não pode ser usada")
                print(error)
            }
        }
        else{
            print("Scanner não está disponível")
        }
    }
}

