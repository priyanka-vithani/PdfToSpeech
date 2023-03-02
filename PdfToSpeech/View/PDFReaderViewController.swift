//
//  PDFReaderViewController.swift
//  PdfToSpeech
//
//  Created by Priyanka Vithani on 01/03/23.
//

import UIKit
import PDFKit
import UniformTypeIdentifiers

class PDFReaderViewController: UIViewController {
    
    //MARK: IBOutlet
    @IBOutlet weak var filePickerButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var pdfView: PDFView!
    //MARK: Properties
    // View model instance to handle PDF document and speech synthesis
    var viewModel: PDFReaderViewModel?
    
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel = PDFReaderViewModel()
    }
    
    // Function to setup the PDF view
    func setupView(){
        playButton.isHidden = true
        pauseButton.isHidden = true
        pdfView.backgroundColor = .white
    }
    // Funtion to enable button state
    func enableButton(button:UIButton){
        button.isEnabled = true
        button.backgroundColor = UIColor(red: 98/255, green: 72/255, blue: 232/255, alpha: 1.0)
    }
    // Function to disable button state
    func DisableButton(button:UIButton){
        button.isEnabled = false
        button.backgroundColor = .lightGray
    }
    
    //MARK: IBActions
    // Function to handle file picker button press
    @IBAction func pickFile(_ sender: Any) {
        
        let supportedTypes: [UTType] = [UTType.pdf]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }
    // Function to handle play button press for speech synthesis
    @IBAction func startSpeech(_ sender: UIButton) {
        if !(viewModel?.speechSynthesizer?.isSpeaking ?? false){
            viewModel?.startSpeech()
            enableButton(button: pauseButton)
            DisableButton(button: sender)
        }
    }
    // Function to handle pause button press for speech synthesis
    @IBAction func stopSpeech(_ sender: UIButton) {
        if let isSpeaking = viewModel?.speechSynthesizer?.isSpeaking, isSpeaking{
            viewModel?.stopSpeech()
            enableButton(button: playButton)
            DisableButton(button: sender)
        }
    }
}
//MARK:  Extension to handle the document picker
extension PDFReaderViewController: UIDocumentPickerDelegate {
    
    // Delegate Method to handle the selection of a document
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        // Getting the URL of the selected document
        guard let url = urls.first else { return }
        playButton.isHidden = false
        pauseButton.isHidden = false
        DisableButton(button: pauseButton)
        // Setting the selected document as the PDF view's document
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        
        // Extracting text from the PDF document and enabling the play button if text is successfully extracted
        if (viewModel?.extractText(from: url)) != nil {
            playButton.isEnabled = true
        }
    }
}
