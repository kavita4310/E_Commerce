//
//  ApiModel.swift
//  ECommerceDemo
//
//  Created by kavita chauhan on 21/06/24.
//

import Foundation

// MARK: - Welcome
struct WSApiModel: Codable {
    let status: Int
    let message: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let id, sku: String
    let isReturn: Int
    let name, attributeSetID, price, finalPrice: String
    let status, type: String
    let webURL: String
    let brandName, brand: String
    let isFollowingBrand: Int
    let brandBannerURL: String
    let isSalable: Bool
    let isNew, isSale, isTrending, isBestSeller: Int
    let image: String
    let createdAt, updatedAt: String
    let weight: JSONNull?
    let description: String
    let shortDescription, howToUse, manufacturer, keyIngredients: JSONNull?
    let returnsAndExchanges, shippingAndDelivery, aboutTheBrand: JSONNull?
    let metaTitle: String
    let metaKeyword: JSONNull?
    let metaDescription: String
    let sizeChart: JSONNull?
    let wishlistItemID: Int
    let hasOptions: String
    let options, bundleOptions: [JSONAny]?
    let configurableOption: [ConfigurableOption]
    let remainingQty: Int
    let images: [String]
    let upsell, related: [JSONAny]?
    let review: Review

    enum CodingKeys: String, CodingKey {
        case id, sku
        case isReturn = "is_return"
        case name
        case attributeSetID = "attribute_set_id"
        case price
        case finalPrice = "final_price"
        case status, type
        case webURL = "web_url"
        case brandName = "brand_name"
        case brand
        case isFollowingBrand = "is_following_brand"
        case brandBannerURL = "brand_banner_url"
        case isSalable = "is_salable"
        case isNew = "is_new"
        case isSale = "is_sale"
        case isTrending = "is_trending"
        case isBestSeller = "is_best_seller"
        case image
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case weight, description
        case shortDescription = "short_description"
        case howToUse = "how_to_use"
        case manufacturer
        case keyIngredients = "key_ingredients"
        case returnsAndExchanges = "returns_and_exchanges"
        case shippingAndDelivery = "shipping_and_delivery"
        case aboutTheBrand = "about_the_brand"
        case metaTitle = "meta_title"
        case metaKeyword = "meta_keyword"
        case metaDescription = "meta_description"
        case sizeChart = "size_chart"
        case wishlistItemID = "wishlist_item_id"
        case hasOptions = "has_options"
        case options
        case bundleOptions = "bundle_options"
        case configurableOption = "configurable_option"
        case remainingQty = "remaining_qty"
        case images, upsell, related, review
    }
}

// MARK: - ConfigurableOption
struct ConfigurableOption: Codable {
    let attributeID: Int
    let type, attributeCode: String
    let attributes: [Attribute]

    enum CodingKeys: String, CodingKey {
        case attributeID = "attribute_id"
        case type
        case attributeCode = "attribute_code"
        case attributes
    }
}

// MARK: - Attribute
struct Attribute: Codable {
    let value, optionID, attributeImageURL, price: String
    let images: [String]
    let colorCode: JSONNull?
    let swatchURL: String

    enum CodingKeys: String, CodingKey {
        case value
        case optionID = "option_id"
        case attributeImageURL = "attribute_image_url"
        case price, images
        case colorCode = "color_code"
        case swatchURL = "swatch_url"
    }
}

// MARK: - Review
struct Review: Codable {
    let totalReview, ratingCount: Int

    enum CodingKeys: String, CodingKey {
        case totalReview = "total_review"
        case ratingCount = "rating_count"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
            return nil
    }

    required init?(stringValue: String) {
            key = stringValue
    }

    var intValue: Int? {
            return nil
    }

    var stringValue: String {
            return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if container.decodeNil() {
                    return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                    return value
            }
            if let value = try? container.decode(Int64.self) {
                    return value
            }
            if let value = try? container.decode(Double.self) {
                    return value
            }
            if let value = try? container.decode(String.self) {
                    return value
            }
            if let value = try? container.decodeNil() {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                    return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                    return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                    if value {
                            return JSONNull()
                    }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                    return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                    return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                    let value = try decode(from: &container)
                    arr.append(value)
            }
            return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                    let value = try decode(from: &container, forKey: key)
                    dict[key.stringValue] = value
            }
            return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                    if let value = value as? Bool {
                            try container.encode(value)
                    } else if let value = value as? Int64 {
                            try container.encode(value)
                    } else if let value = value as? Double {
                            try container.encode(value)
                    } else if let value = value as? String {
                            try container.encode(value)
                    } else if value is JSONNull {
                            try container.encodeNil()
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer()
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                    let key = JSONCodingKey(stringValue: key)!
                    if let value = value as? Bool {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Int64 {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? Double {
                            try container.encode(value, forKey: key)
                    } else if let value = value as? String {
                            try container.encode(value, forKey: key)
                    } else if value is JSONNull {
                            try container.encodeNil(forKey: key)
                    } else if let value = value as? [Any] {
                            var container = container.nestedUnkeyedContainer(forKey: key)
                            try encode(to: &container, array: value)
                    } else if let value = value as? [String: Any] {
                            var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                            try encode(to: &container, dictionary: value)
                    } else {
                            throw encodingError(forValue: value, codingPath: container.codingPath)
                    }
            }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                    try container.encode(value)
            } else if let value = value as? Int64 {
                    try container.encode(value)
            } else if let value = value as? Double {
                    try container.encode(value)
            } else if let value = value as? String {
                    try container.encode(value)
            } else if value is JSONNull {
                    try container.encodeNil()
            } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
            }
    }

    public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                    self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                    self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                    let container = try decoder.singleValueContainer()
                    self.value = try JSONAny.decode(from: container)
            }
    }

    public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                    var container = encoder.unkeyedContainer()
                    try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                    var container = encoder.container(keyedBy: JSONCodingKey.self)
                    try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                    var container = encoder.singleValueContainer()
                    try JSONAny.encode(to: &container, value: self.value)
            }
    }
}
