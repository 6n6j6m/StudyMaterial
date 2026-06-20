//
//  SummaryData.swift
//  StudyMaterial
//
//  Created by Muhammad Najmi Rahmani  on 16/06/26.
//

import Foundation
import FoundationModels
import SwiftData

@Generable
struct SummaryData {
        var reasoningSteps: String
        
        @Guide(description: "The full title of the academic paper.")
        var title: String
        
        @Guide(description: "Comma-separated list of the primary authors.")
        var authors: String
        
        @Guide(description: "The research problem, specific knowledge gap, and primary objective or hypothesis.")
        var contextAndObjective: String
        
        @Guide(description: "The research design, subjects/participants, and key tools or data collection methods used.")
        var methods: String
        
        @Guide(description: "The core statistical or thematic findings. State clearly if the hypothesis was supported.")
        var primaryResults: String
        
        @Guide(description: "The real-world implications, applications, future directions, and ultimate takeaway.")
        var discussionAndImpact: String
}

struct PDFSummary {
    var reasoningSteps: String
    var title: String
    var authors: String
    var contextAndObjective: String
    var methods: String
    var primaryResults: String
    var discussionAndImpact: String
    
    init(reasoningSteps: String, title: String, authors: String, contextAndObjective: String, methods: String, primaryResults: String, discussionAndImpact: String) {
        self.reasoningSteps = reasoningSteps
        self.title = title
        self.authors = authors
        self.contextAndObjective = contextAndObjective
        self.methods = methods
        self.primaryResults = primaryResults
        self.discussionAndImpact = discussionAndImpact
    }
}
