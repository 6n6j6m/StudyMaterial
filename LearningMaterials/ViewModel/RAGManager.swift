//
//  RAGManager.swift
//  StudyMaterial
//
//  Created by Muhammad Najmi Rahmani  on 22/06/26.
//

import Foundation
import NaturalLanguage
import VecturaKit
import VecturaNLKit
import PDFKit

@Observable
class RAGManager {
    static var shared: RAGManager?
    let db: VecturaKit
//    var context: [String] = []
    var scores: [Float] = []
    
    
    private init(db: VecturaKit) {
        self.db = db
    }
    
    // Async factory
    static func initialize() async throws {
        do {
            let config = try VecturaConfig(name: "vector-db")
            let embedder = try await NLContextualEmbedder(language: .english)
            let vecturaDB = try await VecturaKit(config: config, embedder: embedder)
            
            shared = RAGManager(db: vecturaDB)
        } catch {
            print("\(error.localizedDescription)")
        }
    }
    
    static func loadDB() async throws {
        
    }
    
    func addDocumentToDB(text: [String]) async {
            do {
                _ = try await RAGManager.shared?.db.addDocuments(texts: text)
            } catch {
                print("\(error.localizedDescription)")
            }
    }
    
    func searchText(query: String) async -> [String]{
        var contexts: [String] = []
        do {
            let searchEmbedder = try await NLContextualEmbedder(language: .english)
            let embeddedQuery = try await searchEmbedder.embed(text: query)
            let results = try await RAGManager.shared?.db.search(query: .vector(embeddedQuery), numResults: 2, threshold: 0.2)
//            var contexts: [String] = []
            
            for result in results! {
                contexts.append(result.text)
                scores.append(result.score)
            }
            
            return contexts
        } catch {
            print("\(error.localizedDescription)")
        }
        
        return contexts
    }
    
    private func extractText(file: FileMaterial) -> String? {
        guard let pdf = PDFDocument(url: file.fileURL) else {
            print("Gagal membuka PDF dari URL: \(file.fileURL)")
            return nil
        }
        let pageCount = pdf.pageCount
        
        var extractedText = ""
        
        for pageIndex in 0..<pageCount {
            guard let page = pdf.page(at: pageIndex) else { continue }
            if let pageText = page.string {
                extractedText += pageText
                extractedText += "\n"
            } else { continue }
        }
        
        return extractedText
    }
    
    func countTokens(text: String) -> Int {
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = text
        
        let tokens = tokenizer.tokens(for: text.startIndex..<text.endIndex)
        return tokens.count
    }
    
    func chunkText(_ text: String, maxTokens: Int = 600, overlapTokens: Int = 100) -> [String] {
        // Convert maxChunkSize from characters to approximate tokens (roughly 4 chars per token)
        
        let sentences = text.components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .map { sentence in
                sentence.hasSuffix(".") || sentence.hasSuffix("!") || sentence.hasSuffix("?") ?
                sentence : sentence + "."
            }
        
        var chunks: [String] = []
        var currentChunk = ""
        var currentTokenCount = 0
        var previousChunkSentences: [String] = []
        
        for sentence in sentences {
            let sentenceTokenCount = countTokens(text: sentence)
            let potentialChunk = currentChunk.isEmpty ? sentence : currentChunk + " " + sentence
            let potentialTokenCount = currentTokenCount + sentenceTokenCount + (currentChunk.isEmpty ? 0 : 1)
            
            if potentialTokenCount <= maxTokens {
                currentChunk = potentialChunk
                currentTokenCount = potentialTokenCount
            } else {
                // Current chunk is ready, save it
                if !currentChunk.isEmpty {
                    chunks.append(currentChunk)
                    
                    // Store sentences for overlap calculation
                    let chunkSentences = currentChunk.components(separatedBy: CharacterSet(charactersIn: ".!?"))
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                        .filter { !$0.isEmpty }
                    previousChunkSentences = chunkSentences
                }
                
                // Start new chunk with overlap from previous chunk
                var overlapText = ""
                var overlapTokenCount = 0
                
                if !previousChunkSentences.isEmpty && chunks.count > 0 {
                    // Take sentences from the end of previous chunk for overlap
                    for sentenceIndex in stride(from: previousChunkSentences.count - 1, through: 0, by: -1) {
                        let overlapSentence = previousChunkSentences[sentenceIndex]
                        let overlapSentenceTokens = countTokens(text: overlapSentence)
                        
                        if overlapTokenCount + overlapSentenceTokens <= overlapTokens {
                            overlapText = overlapSentence + (overlapText.isEmpty ? "" : " " + overlapText)
                            overlapTokenCount += overlapSentenceTokens
                        } else {
                            break
                        }
                    }
                }
                
                // Start new chunk with overlap + current sentence
                if sentenceTokenCount <= maxTokens {
                    if !overlapText.isEmpty {
                        currentChunk = overlapText + " " + sentence
                        currentTokenCount = overlapTokenCount + sentenceTokenCount + 1
                    } else {
                        currentChunk = sentence
                        currentTokenCount = sentenceTokenCount
                    }
                } else {
                    // Sentence is too long, truncate it
                    let words = sentence.components(separatedBy: .whitespaces)
                    var truncatedSentence = ""
                    var truncatedTokenCount = 0
                    
                    for word in words {
                        let wordTokenCount = countTokens(text: word)
                        if truncatedTokenCount + wordTokenCount <= maxTokens {
                            truncatedSentence += (truncatedSentence.isEmpty ? "" : " ") + word
                            truncatedTokenCount += wordTokenCount
                        } else {
                            break
                        }
                    }
                    
                    if !truncatedSentence.isEmpty {
                        if !truncatedSentence.hasSuffix(".") && !truncatedSentence.hasSuffix("!") && !truncatedSentence.hasSuffix("?") {
                            truncatedSentence += "."
                        }
                        chunks.append(truncatedSentence)
                    }
                    currentChunk = ""
                    currentTokenCount = 0
                }
            }
        }
        
        // Add the final chunk if not empty
        if !currentChunk.isEmpty {
            chunks.append(currentChunk)
        }
        
        return chunks.filter { !$0.isEmpty }
    }
    
    func IndexPDF(file: FileMaterial) async {
            let extractedText = extractText(file: file)
            guard let extractedText else { return print("Gagal index extractednya kosong")}
            let chunkText = chunkText(extractedText)
            await addDocumentToDB(text: chunkText)
            print("Done indexing")
    }
}
