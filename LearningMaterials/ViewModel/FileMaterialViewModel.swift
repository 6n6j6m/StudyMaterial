//
//  FileMaterialViewModel.swift
//  StudyMaterial
//
//  Created by Muhammad Najmi Rahmani  on 15/06/26.
//

import Foundation
import Observation
import SwiftData
import FoundationModels
import PDFKit
import YoutubeTranscript

@MainActor
@Observable
class FileMaterialViewModel {
    var paperSummary: PDFSummary = PDFSummary(reasoningSteps: "", title: "", authors: "", contextAndObjective: "", methods: "", primaryResults: "", discussionAndImpact: "")
    
    var presentImporter: Bool = false
    var showSummary: Bool = false
    var isSummarizing: Bool = false
    
    var summaryResult: String = ""
    
    var urlToView: URL?
    
    private let model = SystemLanguageModel.default
    var youtubeTitle: String = "Gaada"
    
    var fileToDelete: FileMaterial = FileMaterial(id: UUID(), fileURL: URL(fileURLWithPath: ""), fileName: "", fileSize: 0, fileExtension: "")
    
    // placeholder buat materi dlm bntk link
    private var urlToAdd: FileMaterial = FileMaterial(id: UUID(), fileURL: URL(fileURLWithPath: ""), fileName: "", fileSize: 0, fileExtension: "")
    
    func savePdf(topic: String, url: URL) -> FileMaterial? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // masih bingung si unique identifier yg lebih praktis selain uuid
        //        let fileName = "StudyMaterial-\(UUID().uuidString)-\(fileName)"
        
        if url.isFileURL != true {
            return FileMaterial(id: UUID(), fileURL: url, fileName: urlToAdd.fileName, fileSize: 0, fileExtension: "URL")
        }
        
        // Bikin directory per topik
        do {
            let pdfData = try Data(contentsOf: url)
            let fileName = url.lastPathComponent
            
            let folderPath = documentsDirectory.appending(path: topic)
            let fileSize = pdfData.count
            
            try FileManager.default.createDirectory(at: folderPath, withIntermediateDirectories: true, attributes: nil)
            
            let actualPath = folderPath.appending(path: fileName)
            
            // Check filenya udah ada apa belom biar ga ngawur
            if FileManager.default.fileExists(atPath: actualPath.path){
                // skip
                print("File already exists")
                return nil
            }
            
            try pdfData.write(to: actualPath, options: .atomic)
            
            //            let fileMaterial = FileMaterial(id: UUID(), fileURL: actualPath, fileName: fileName, fileSize: fileSize, fileExtension: actualPath.pathExtension)
            
            return FileMaterial(id: UUID(), fileURL: actualPath, fileName: fileName, fileSize: fileSize, fileExtension: actualPath.pathExtension)
            
        } catch let error as NSError {
            print("Failed to create directory: \(error.localizedDescription)")
            
            return nil
        }
    }
    
    func deletePdf(material: StudyMaterial) {
        do {
            try FileManager.default.removeItem(at: fileToDelete.fileURL)
            material.sumber.removeAll { $0 == fileToDelete}
        } catch {
            print("Delete failed: \(error)")
        }
    }
    
    // helper func buat si summarize
    private func extractText(file: FileMaterial) -> String? {
        guard let pdf = PDFDocument(url: file.fileURL) else { return nil }
        let pageCount = pdf.pageCount
        
        var extractedText = ""
        
        for pageIndex in 0..<2 {
            guard let page = pdf.page(at: pageIndex) else { continue }
            if let pageText = page.string {
                extractedText += pageText
                extractedText += "\n"
            } else { continue }
        }
        
        return extractedText
    }
    
    func summarizePdf(file: FileMaterial) async {
        guard model.isAvailable else {
            print("model not available")
            return
        }
        
        let modelContext = extractText(file: file)
        let prompt = "Summarize this whole document/text from this contetnt: \(modelContext ?? "")"
        let session = LanguageModelSession()
        
        isSummarizing = true
        
        do {
            print(modelContext ?? "No Context")
            let response = try await session.respond(to: prompt, generating: SummaryData.self)
            print("===========================================")
            print(response.content)
            let result = response.content
            paperSummary.reasoningSteps = result.reasoningSteps
            paperSummary.authors = result.authors
            paperSummary.contextAndObjective = result.contextAndObjective
            paperSummary.discussionAndImpact = result.discussionAndImpact
            paperSummary.methods = result.methods
            paperSummary.primaryResults = result.primaryResults
            paperSummary.title = result.title
            showSummary = true
        } catch {
            print("\(error.localizedDescription)")
        }
        
        isSummarizing = false
    }
    
    func getYouTubeTranscript(url: URL) async {
        do {
            let config = TranscriptConfig(lang: "en")
            let transcript = try await YoutubeTranscript.fetchTranscript(for: url.absoluteString, config: config)
            for entry in transcript {
                print("\(entry.offset)s: \(entry.text)")
            }
        } catch {
            print("Failed to fetch transcript: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func getYouTubeTitle(url: String) async {
        do {
            let video = Video(videoUid: url)
            let metadata = try await video.GetMeta()
            
            print(metadata.videoDetails.title)
            urlToAdd.fileName = metadata.videoDetails.title
            print(youtubeTitle)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
}
