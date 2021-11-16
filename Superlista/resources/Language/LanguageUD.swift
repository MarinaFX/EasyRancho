//
//  LanguageUD.swift
//  Superlista
//
//  Created by Gabriela Zorzo on 10/11/21.
//

import Foundation

@propertyWrapper
struct AppUserDefault<T> {
  let key: String
  let defaultValue: T
  
  init(_ key: DefaultsKeys, defaultValue: T) {
    self.key = key.rawValue
    self.defaultValue = defaultValue
  }
  
  var wrappedValue: T {
    get {
      return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}

enum DefaultsKeys: String {
  case selectedLanguage = "LanguageManagerSelectedLanguage"
}
