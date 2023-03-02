//
//  PDFReaderViewModel.swift
//  PdfToSpeech
//
//  Created by Priyanka Vithani on 01/03/23.
//

import Foundation
import PDFKit
import AVFoundation

class PDFReaderViewModel {
    // The PDF document to read
    var pdfDocument: PDFDocument?
    
    // The AVSpeechSynthesizer to read the text out loud
    var speechSynthesizer: AVSpeechSynthesizer?
    
    // Extract text from the PDF document and return it as a string
    func extractText(from url: URL) -> String? {
        pdfDocument = PDFDocument(url: url)
        return pdfDocument?.string
    }
    
    // Start reading the text out loud using AVSpeechSynthesizer
    func startSpeech() {
        let utterance = AVSpeechUtterance(string: pdfDocument?.string ?? "")
        speechSynthesizer = AVSpeechSynthesizer()
        
        // if speech is already started then it is not speak again
        if !(speechSynthesizer?.isSpeaking ?? false){
            speechSynthesizer?.speak(utterance)
        }
        
    }
    // Stop reading the text out loud
    func stopSpeech() {
        speechSynthesizer?.stopSpeaking(at: .immediate)
    }
}
