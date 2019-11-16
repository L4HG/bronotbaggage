import UIKit
import SnapKit


class BorcheckerViewController: UIViewController {
    
    enum Segment: Int, CaseIterable {
        case input
        case segmentation
        case overlay
    }
    
    /// UI elements
    let imageView = UIImageView(image: .cat1)
    lazy var photoCameraButton: UIButton = {
        let button = UIButton()
        button.setTitle("Camera", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        return button
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let item = UISegmentedControl(items: Segment.allCases.map { "\($0)" })
        return item
    }()
    
    let cropSwitch = UISwitch()
    let inferenceStatusLabel = UILabel()
    let legendLabel = UILabel()
    
    /// Image picker for accessing the photo library or camera.
    private var imagePicker = UIImagePickerController()
    
    /// Image segmentator instance that runs image segmentation.
    private var imageSegmentator: ImageSegmentator?
    
    /// Target image to run image segmentation on.
    private var targetImage: UIImage?
    
    /// Processed (e.g center cropped)) image from targetImage that is fed to imageSegmentator.
    private var segmentationInput: UIImage?
    
    /// Image segmentation result.
    private var segmentationResult: SegmentationResult?
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        view.addSubviews([
            imageView,
            photoCameraButton,
            segmentedControl,
            cropSwitch,
            inferenceStatusLabel,
            legendLabel
        ])
        
        imageView.contentMode = .scaleAspectFit
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupActions()
        
        // Setup image picker.
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        // Enable camera option only if current device has camera.
        let isCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.front)
            || UIImagePickerController.isCameraDeviceAvailable(.rear)
        if isCameraAvailable {
            photoCameraButton.isEnabled = true
        }
        
        // Initialize an image segmentator instance.
        ImageSegmentator.newInstance { result in
            print("ImageSegmentator initiated")
            switch result {
            case let .success(segmentator):
                // Store the initialized instance for use.
                self.imageSegmentator = segmentator
                
                // Run image segmentation on a demo image.
                self.showDemoSegmentation()
            case .error(_):
                print("Failed to initialize.")
            }
        }
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(self.photoCameraButton.frame)

        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseOut], animations: {
            self.segmentedControl.snp.remakeConstraints {
                $0.top.equalTo(self.imageView.snp.bottom).offset(20)
                $0.left.right.equalToSuperview().offset(0)
                $0.height.equalTo(30)
            }
            self.setContstraint(height: 30, for: self.photoCameraButton)
        }, completion: { _ in
            
        })
        
    }
    
    private func animtingButtonHeight() {
        
    }
    
    
    private func setupUI() {
        
    }
    
    private func setupActions() {
        segmentedControl.addTarget(self,
                                   action: #selector(onSegmentChanged(_:)),
                                   for: .valueChanged)
        
        photoCameraButton.addTarget(self,
                                    action: #selector(onTapOpenCamera(_:)),
                                    for: .touchUpInside)
        
        
        cropSwitch.addTarget(self,
                             action: #selector(onCropSwitchValueChanged(_:)),
                             for: .valueChanged)
        
        
    
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-150)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(0)
            $0.width.equalTo(0)
        }
        segmentedControl.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        photoCameraButton.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().offset(-300)
            $0.height.equalTo(30)
        }
        
        photoCameraButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        photoCameraButton.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(20)
            $0.width.equalTo(140)
            $0.height.equalTo(0)
            $0.left.equalToSuperview().offset(-80)
        }
        
        cropSwitch.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(20)
            $0.height.equalTo(30)
            $0.right.equalToSuperview().offset(-40)
        }
        
        
        
    }
    
    private func setContstraint(height: CGFloat, for view: UIView) {
        
        imageView.snp.remakeConstraints {
            $0.centerY.equalToSuperview().offset(-150)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(300)
            $0.width.equalToSuperview()
        }
        
        view.snp.remakeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(20)
            $0.width.equalTo(140)
            $0.height.equalTo(height)
            $0.left.equalToSuperview().offset(40)
        }
        
        view.superview?.layoutIfNeeded()
    }
    
    
    
    /// Open camera to allow user taking photo.
    @objc
    func onTapOpenCamera(_ sender: Any) {
        print("tap on camera")
        guard
            UIImagePickerController.isCameraDeviceAvailable(.front)
            || UIImagePickerController.isCameraDeviceAvailable(.rear)
        else {
            print("didn't access to camera or device")
            return
        }
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    /// Open photo library for user to choose an image from.
    @objc
    func onTapPhotoLibrary(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc
    func onSegmentChanged(_ sender: Any) {
        let selectedSegment = Segment(rawValue: segmentedControl.selectedSegmentIndex)
        switch selectedSegment {
        case .input:
            imageView.image = segmentationInput
        case .segmentation:
            imageView.image = segmentationResult?.resultImage
        case .overlay:
            imageView.image = segmentationResult?.overlayImage
        default:
            break
        }
    }
    
    /// Handle changing center crop setting.
    @objc
    func onCropSwitchValueChanged(_ sender: Any) {
        // Make sure that cached segmentation target image is available.
        guard targetImage != nil else {
            self.inferenceStatusLabel.text = "Error: Input image is nil."
            return
        }
        
        // Re-run the segmentation upon center-crop setting changed.
        runSegmentation(targetImage!)
    }
}

// MARK: - Image Segmentation

extension BorcheckerViewController {
    /// Run image segmentation on the given image, and show result on screen.
    ///  - Parameter image: The target image for segmentation.
    func runSegmentation(_ image: UIImage) {
        clearResults()
        
        // Rotate target image to .up orientation to avoid potential orientation misalignment.
        guard let targetImage = image.transformOrientationToUp() else {
            inferenceStatusLabel.text = "ERROR: Image orientation couldn't be fixed."
            return
        }
        
        // Make sure that image segmentator is initialized.
        guard imageSegmentator != nil else {
            inferenceStatusLabel.text = "ERROR: Image Segmentator is not ready."
            return
        }
        
        // Cache the target image.
        self.targetImage = targetImage
        
        // Center-crop the target image if the user has enabled the option.
        let willCenterCrop = cropSwitch.isOn
        let image = willCenterCrop ? targetImage.cropCenter() : targetImage
        
        // Cache the potentially cropped image as input to the segmentation model.
        segmentationInput = image
        
        // Show the potentially cropped image on screen.
        imageView.image = image
        
        // Make sure that the image is ready before running segmentation.
        guard image != nil else {
            inferenceStatusLabel.text = "ERROR: Image could not be cropped."
            return
        }
        
        // Lock the crop switch while segmentation is running.
        cropSwitch.isEnabled = false
        
        // Run image segmentation.
        imageSegmentator?.runSegmentation(
            image!,
            completion: { result in
                // Unlock the crop switch
                self.cropSwitch.isEnabled = true
                
                // Show the segmentation result on screen
                switch result {
                case let .success(segmentationResult):
                    self.segmentationResult = segmentationResult
                    
                    // Change to show segmentation overlay result
                    self.segmentedControl.selectedSegmentIndex = 2
                    self.onSegmentChanged(self)
                    
                    // Show result metadata
                    self.showInferenceTime(segmentationResult)
                    self.showClassLegend(segmentationResult)
                    
                    // Enable switching between different display mode: input, segmentation, overlay
                    self.segmentedControl.isEnabled = true
                case let .error(error):
                    self.inferenceStatusLabel.text = error.localizedDescription
                }
        })
    }
    
    /// Clear result from previous run to prepare for new segmentation run.
    private func clearResults() {
        inferenceStatusLabel.text = "Running inference with TensorFlow Lite..."
        legendLabel.text = nil
        segmentedControl.isEnabled = false
        segmentedControl.selectedSegmentIndex = 0
    }
    
    /// Demo image segmentation with a bundled image.
    private func showDemoSegmentation() {
        runSegmentation(.cat1)
    }
    
    /// Show segmentation latency on screen.
    private func showInferenceTime(_ segmentationResult: SegmentationResult) {
        let timeString = "Preprocessing: \(Int(segmentationResult.preprocessingTime * 1000))ms.\n"
            + "Model inference: \(Int(segmentationResult.inferenceTime * 1000))ms.\n"
            + "Postprocessing: \(Int(segmentationResult.postProcessingTime * 1000))ms.\n"
            + "Visualization: \(Int(segmentationResult.visualizationTime * 1000))ms.\n"
        
        inferenceStatusLabel.text = timeString
    }
    
    /// Show color legend of each class found in the image.
    private func showClassLegend(_ segmentationResult: SegmentationResult) {
        let legendText = NSMutableAttributedString()
        
        // Loop through the classes founded in the image.
        segmentationResult.colorLegend.forEach { (className, color) in
            // If the color legend is light, use black text font. If not, use white text font.
            let textColor = color.isLight() ?? true ? UIColor.black : UIColor.white
            
            // Construct the legend text for current class.
            let attributes = [
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline),
                NSAttributedString.Key.backgroundColor: color,
                NSAttributedString.Key.foregroundColor: textColor,
            ]
            let string = NSAttributedString(string: " \(className) ", attributes: attributes)
            
            // Add class legend to string to show on the screen.
            legendText.append(string)
            legendText.append(NSAttributedString(string: "  "))
        }
        
        // Show the class legends on the screen.
        legendLabel.attributedText = legendText
    }
}

// MARK: - UIImagePickerControllerDelegate

extension BorcheckerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        
        if let pickedImage = info[.originalImage] as? UIImage {
            runSegmentation(pickedImage)
        }
        
        dismiss(animated: true)
    }
}
