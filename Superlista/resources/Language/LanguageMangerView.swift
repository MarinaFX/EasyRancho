//
//  LanguageMangerView.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 10/11/21.
//

import SwiftUI

public struct LanguageManagerView<Content: View>: View {
  
  // MARK: - Private properties
  
  private let content: Content
  @ObservedObject private var settings: LanguageSettings
  
  // MARK: init
  
  ///
  /// - Parameters:
  ///   - defaultLanguage: The default language when the app starts for the first time.
  ///
  public init(_ defaultLanguage: Languages, content: () -> Content) {
    self.content = content()
    self.settings = LanguageSettings(defaultLanguage: defaultLanguage)
  }
  
  // MARK: - body

  public var body: some View {
    content
      .environment(\.locale, settings.local)
      .environment(\.layoutDirection, settings.layout)
      .id(settings.uuid)
      .environmentObject(settings)
  }
}


