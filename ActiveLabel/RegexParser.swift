//
//  RegexParser.swift
//  ActiveLabel
//
//  Created by Pol Quintana on 06/01/16.
//  Copyright © 2016 Optonaut. All rights reserved.
//

import Foundation

struct RegexParser {
    
    static let urlPattern = "(^|[\\s.:;?\\-\\]<\\(])" +
        "((https?://|www.|pic.)[-\\w;/?:@&=+$\\|\\_.!~*\\|'()\\[\\]%#,☺]+[\\w/#](\\(\\))?)" +
    "(?=$|[\\s',\\|\\(\\).:;?\\-\\[\\]>\\)])"
    
    static let hashtagRegex = try? NSRegularExpression(pattern: "(?:^|\\s|$)#[a-z0-9_]*", options: [.CaseInsensitive])
    static let mentionRegex = try? NSRegularExpression(pattern: "(?:^|\\s|$|[.])@[a-z0-9_]*", options: [.CaseInsensitive])
    static let urlDetector = try? NSRegularExpression(pattern: urlPattern, options: [.CaseInsensitive])
    
    static func getMentions(fromText text: String, range: NSRange, mentionCharacter: String) -> [NSTextCheckingResult] {
        guard let mentionRegex = mentionRegex(mentionCharacter) else { return [] }
        return mentionRegex.matchesInString(text, options: [], range: range)
    }
    
    static func getHashtags(fromText text: String, range: NSRange) -> [NSTextCheckingResult] {
        guard let hashtagRegex = hashtagRegex else { return [] }
        return hashtagRegex.matchesInString(text, options: [], range: range)
    }
    
    static func getURLs(fromText text: String, range: NSRange) -> [NSTextCheckingResult] {
        guard let urlDetector = urlDetector else { return [] }
        return urlDetector.matchesInString(text, options: [], range: range)
    }
    
    private static var mentionRegexs: [String: NSRegularExpression] = [:]
    private static func mentionRegex(mentionCharacter: String) -> NSRegularExpression? {
        if let mentionRegex = mentionRegexs[mentionCharacter] {
            return mentionRegex
        } else {
            let mentionRegex = try? NSRegularExpression(pattern: "(?:^|\\s|$|[.])\(mentionCharacter)[a-z0-9_]*", options: [.CaseInsensitive])
            mentionRegexs[mentionCharacter] = mentionRegex
            return mentionRegex
        }
    }
}