//
//  Swift+Localizable.swift
//  PopularMovies
//
//  Created by Scott Takahashi on 04/07/20.
//
import Foundation


extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }

}
