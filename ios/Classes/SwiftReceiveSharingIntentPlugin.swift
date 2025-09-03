import Flutter
import UIKit
import Photos

public let kSchemePrefix = "ShareMedia"
public let kUserDefaultsKey = "ShareKey"
public let kUserDefaultsMessageKey = "ShareMessageKey"
public let kAppGroupIdKey = "AppGroupId"

public class SwiftReceiveSharingIntentPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    static let kMessagesChannel = "receive_sharing_intent/messages"
    static let kEventsChannelMedia = "receive_sharing_intent/events-media"
    
    private var initialMedia: [SharedMediaFile]?
    private var latestMedia: [SharedMediaFile]?
    
    private var eventSinkMedia: FlutterEventSink?
    
    public static let instance = SwiftReceiveSharingIntentPlugin()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: kMessagesChannel, binaryMessenger: registrar.messenger())
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        let chargingChannelMedia = FlutterEventChannel(name: kEventsChannelMedia, binaryMessenger: registrar.messenger())
        chargingChannelMedia.setStreamHandler(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getInitialMedia":
            result(toJson(data: self.initialMedia))
        case "reset":
            self.initialMedia = nil
            self.latestMedia = nil
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func hasMatchingSchemePrefix(url: URL?) -> Bool {
        if let url = url, let appDomain = Bundle.main.bundleIdentifier {
            return url.absoluteString.hasPrefix("\(kSchemePrefix)-\(appDomain)")
        }
        return false
    }
    
    // Public method to be called from AppDelegate
    public func handleUrl(_ url: URL, setInitialData: Bool = false) -> Bool {
        if hasMatchingSchemePrefix(url: url) {
            return processSharedData(setInitialData: setInitialData)
        }
        return false
    }
    
    // Public method to process shared data
    public func processSharedData(setInitialData: Bool) -> Bool {
        let appGroupId = Bundle.main.object(forInfoDictionaryKey: kAppGroupIdKey) as? String
        let defaultGroupId = "group.\(Bundle.main.bundleIdentifier!)"
        let userDefaults = UserDefaults(suiteName: appGroupId ?? defaultGroupId)
        
        let message = userDefaults?.string(forKey: kUserDefaultsMessageKey)
        if let json = userDefaults?.object(forKey: kUserDefaultsKey) as? Data {
            let sharedArray = decode(data: json)
            let sharedMediaFiles: [SharedMediaFile] = sharedArray.compactMap {
                guard let path = $0.type == .text || $0.type == .url ? $0.path
                        : getAbsolutePath(for: $0.path) else {
                    return nil
                }
                
                return SharedMediaFile(
                    path: path,
                    mimeType: $0.mimeType,
                    thumbnail: getAbsolutePath(for: $0.thumbnail),
                    duration: $0.duration,
                    message: message,
                    type: $0.type
                )
            }
            latestMedia = sharedMediaFiles
            if setInitialData {
                initialMedia = latestMedia
            }
            eventSinkMedia?(toJson(data: latestMedia))
            return true
        }
        return false
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSinkMedia = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        eventSinkMedia = nil
        return nil
    }
    
    private func getAbsolutePath(for identifier: String?) -> String? {
        guard let identifier else {
            return nil
        }
        
        if identifier.starts(with: "file://") || identifier.starts(with: "/var/mobile/Media") || identifier.starts(with: "/private/var/mobile") {
            return identifier.replacingOccurrences(of: "file://", with: "")
        }
        
        guard let phAsset = PHAsset.fetchAssets(
            withLocalIdentifiers: [identifier],
            options: .none).firstObject else {
            return nil
        }
        
        let (url, _) = getFullSizeImageURLAndOrientation(for: phAsset)
        return url
    }
    
    private func getFullSizeImageURLAndOrientation(for asset: PHAsset) -> (String?, Int) {
        var url: String? = nil
        var orientation: Int = 0
        let semaphore = DispatchSemaphore(value: 0)
        let options2 = PHContentEditingInputRequestOptions()
        options2.isNetworkAccessAllowed = true
        asset.requestContentEditingInput(with: options2) { (input, info) in
            orientation = Int(input?.fullSizeImageOrientation ?? 0)
            url = input?.fullSizeImageURL?.path
            semaphore.signal()
        }
        semaphore.wait()
        return (url, orientation)
    }
    
    private func decode(data: Data) -> [SharedMediaFile] {
        let encodedData = try? JSONDecoder().decode([SharedMediaFile].self, from: data)
        return encodedData ?? []
    }
    
    private func toJson(data: [SharedMediaFile]?) -> String? {
        guard let data = data else { return nil }
        let encodedData = try? JSONEncoder().encode(data)
        return encodedData.flatMap { String(data: $0, encoding: .utf8) }
    }
}

public class SharedMediaFile: Codable {
    var path: String
    var mimeType: String?
    var thumbnail: String?
    var duration: Double?
    var message: String?
    var type: SharedMediaType
    
    public init(
        path: String,
        mimeType: String? = nil,
        thumbnail: String? = nil,
        duration: Double? = nil,
        message: String? = nil,
        type: SharedMediaType
    ) {
        self.path = path
        self.mimeType = mimeType
        self.thumbnail = thumbnail
        self.duration = duration
        self.message = message
        self.type = type
    }
}

public enum SharedMediaType: String, Codable, CaseIterable {
    case image
    case video
    case text
    case file
    case url
    
    public var toUTTypeIdentifier: String {
        if #available(iOS 14.0, *) {
            switch self {
            case .image: return UTType.image.identifier
            case .video: return UTType.movie.identifier
            case .text: return UTType.text.identifier
            case .file: return UTType.fileURL.identifier
            case .url: return UTType.url.identifier
            }
        } else {
            switch self {
            case .image: return "public.image"
            case .video: return "public.movie"
            case .text: return "public.text"
            case .file: return "public.file-url"
            case .url: return "public.url"
            }
        }
    }
}