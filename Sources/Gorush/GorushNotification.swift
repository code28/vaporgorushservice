//
//  GorushNotification.swift
//  Gorush
//
//  Created by Simon Kempendorf on 15.01.19.
//

import Foundation
import Vapor

public struct GorushNotification: Encodable {
    public struct iosAlertPayload: Content {
        let title: String?
        let subtitle: String?
        let body: String?

        public init(title: String? = nil, subtitle: String? = nil, body: String? = nil) {
            self.title = title
            self.subtitle = subtitle
            self.body = body
        }
    }

    public enum Platform: Int, Content {
        case ios = 1
        case android = 2
    }

    let tokens: [String]
    let platform: Platform

    let message: String
    let title: String?
    let alert: iosAlertPayload?

    let data: AnyEncodable?
    let content_available: Bool?

    public init(tokens: [String], platform: GorushNotification.Platform, message: String, title: String? = nil, alert: GorushNotification.iosAlertPayload? = nil, data: Encodable? = nil, content_available: Bool? = nil) {
        self.tokens = tokens
        self.platform = platform
        self.message = message
        self.title = title
        self.alert = alert
        if let data = data {
            self.data = AnyEncodable(data)
        } else {
            self.data = nil
        }
        self.content_available = content_available
    }
}

// MARK: Type erasure

struct AnyEncodable: Encodable {
    var _encodeFunc: (Encoder) throws -> Void

    init(_ encodable: Encodable) {
        func _encode(to encoder: Encoder) throws {
            try encodable.encode(to: encoder)
        }
        self._encodeFunc = _encode
    }
    func encode(to encoder: Encoder) throws {
        try _encodeFunc(encoder)
    }
}
