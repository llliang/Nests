//
//  NPlayer.swift
//  Nests
//
//  Created by qlchat on 2019/10/17.
//

import Foundation
import AVFoundation

public protocol NPlayerDelegate: NSObjectProtocol {
    
    /// 播放结束
    ///
    /// - Parameter player: 当前播放器
    func playerDidPlayEnd(player: NPlayer)
    
    /// 播放失败
    ///
    /// - Parameters:
    ///   - player: 当前播放器
    ///   - failed: 失败原因
    func playerDidPlay(player: NPlayer, failed: Error?)
    
    /// 播放进度
    ///
    /// - Parameters:
    ///   - player: 当前播放器
    ///   - progress: 当前 playItem 进度
    func playerDidPlay(player: NPlayer, progress: Double)
    
    /// 当前缓冲进度
    ///
    /// - Parameters:
    ///   - player: 当前播放器
    ///   - progress: 当前缓冲进度
    func playerDidLoadTimeRange(player: NPlayer, progress: Double)
    
    /// 播放内容若为视频，则画面准备好的回调
    ///
    /// - Parameter player: 当前播放器
    func playerLayerCanDisplay(player: NPlayer)
}

// MARK: - base
public class NPlayer: NSObject {
    
    /// 单例
    public static let shared = NPlayer()
    
    public var delegates = [NPlayerDelegate]()
    
    public var player: AVPlayer?
    
    /// 内容为视频时的画面显示容器
    public var playerView: QLPlayerView?
    
    private var progressObserver: Any?
    
    override init() {
        super.init()
        self.addPlayerNotifications()
    }
    
    func add(delegate: NPlayerDelegate) {
        weak var weakDelegate = delegate
        guard let d = weakDelegate else { return }
        delegates.append(d)
    }
    
    private var currentItem: AVPlayerItem?
    
    /// 设置播放器资源
    var asset: AVAsset? {
        
        willSet {
            self.removeObserverStatus(fromPlayerItem: currentItem)
            self.removeObserverLoadedTimeRanges(fromPlayerItem: currentItem)
            
            playerView = nil
            currentItem = nil
            
            self.removeProgressObserver()
        }
        
        didSet {
            guard let asset = asset else {
                return
            }
            
            currentItem = AVPlayerItem(asset: asset)
            
            self.observerStatus(forPlayerItem: currentItem)
            self.observerLoadedTimeRanges(forPlayerItem: currentItem)
           
            // 重设currentItem
            player = AVPlayer(playerItem: currentItem)
            player?.replaceCurrentItem(with: currentItem)
            
            // 监听播放进度
            progressObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: DispatchQueue.main, using: { [weak self] (time) in
                
                let currentSeconds = CMTimeGetSeconds(time)
                guard let duration = self?.currentItem?.duration else {
                    return
                }
                
                let totalSeconds = CMTimeGetSeconds(duration)
                var progress: Double = 0
                if totalSeconds > 0 {
                    progress = currentSeconds/totalSeconds
                   
                }

                self?.map(transform: { (delegate) in
                    if let s = self {
                        delegate.playerDidPlay(player: s, progress: progress)
                    }
                })
            })
            
            playerView = QLPlayerView()
            playerView?.playerLayer.player = player
            self.observerPlayerLayerDisplay(forPlayerLayer: playerView!.playerLayer)
        }
    }
    
    private func removeProgressObserver() {
        if progressObserver == nil {
            return
        }
        player?.removeTimeObserver(progressObserver!)
        progressObserver = nil
    }
}

// MARK: - action
extension NPlayer {
    
    /// 播放
    public func play() {
        player?.play()
    }
    
    /// 暂停
    public func pause() {
        player?.pause()
    }
    
    /// 恢复播放
    public func resume() {
        player?.play()
    }
    
    /// 停止播放 位置定位到从头开始
    public func stop() {
        player?.pause()
        self.seek(to: 0, completionHander: nil)
    }
    
    /// 定位到当前多少秒
    ///
    /// - Parameters:
    ///   - to: 当前秒数
    ///   - completionHander: 完成回调
    public func seek(to: Double, completionHander: ((Bool) -> ())?) {
        let time =  CMTime(value: CMTimeValue(to) * 600, timescale: 600)
        let tolerance = CMTime.zero
        player?.seek(to: time, toleranceBefore: tolerance, toleranceAfter: tolerance, completionHandler: { (completion) in
            if let handler = completionHander {
                handler(completion)
            }
        })
    }
}

// MARK: - observer
extension NPlayer {
   
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        DispatchQueue.main.async {
            switch keyPath {
            case self.observerKeyPathStatus:
                
                guard let status = change?[NSKeyValueChangeKey.newKey] as? AVPlayer.Status else {
                    return
                }
                
                self.handlePlayer(status: status)
                
            case self.observerKeyPathLoadedTimeRanges:
                guard let ranges = change?[NSKeyValueChangeKey.newKey] as? Array<NSValue> else {
                    return
                }
                
                guard let range = ranges.first?.timeRangeValue else {
                    return
                }
                
                self.handlePlayer(LoadedTimeRange: range)
            case self.observerKeyPathPlayerLayerReadyForDisplay:
                if let isReadyForDisplay = self.playerView?.playerLayer.isReadyForDisplay {
                   self.handlePlayer(readyForDisplay: isReadyForDisplay)
                }
            default:
                let _ = 1
            }
        }
    }
    
    private func handlePlayer(status: AVPlayer.Status) {
        if status == .failed {
            self.map { (delegate) in
                delegate.playerDidPlay(player: self, failed: player?.error)
            }
        }
    }
    
    private func handlePlayer(LoadedTimeRange: CMTimeRange) {
        let startTime = CMTimeGetSeconds(LoadedTimeRange.start)
        let duration = CMTimeGetSeconds(LoadedTimeRange.duration)
        let total = startTime + duration
        
        guard let currentItemDuration = self.currentItem?.duration, CMTIME_IS_NUMERIC(currentItemDuration) else {
            return
        }
        
        let itemDuration = CMTimeGetSeconds(currentItemDuration)
        if itemDuration != 0 {
            let progress = total/itemDuration
            self.map {
                $0.playerDidLoadTimeRange(player: self, progress: progress)
            }
        }
    }
    
    private func handlePlayer(readyForDisplay: Bool) {
        if readyForDisplay {
            self.map {
                $0.playerLayerCanDisplay(player: self)
            }
        }
    }
    
    private var observerKeyPathStatus: String {
        return "status"
    }
    
    private var observerKeyPathLoadedTimeRanges: String {
        return "loadedTimeRanges"
    }
    
    private var observerKeyPathPlayerLayerReadyForDisplay: String {
        return "readyForDisplay"
    }
    
    private func observerPlayerLayerDisplay(forPlayerLayer: AVPlayerLayer?) {
        forPlayerLayer?.addObserver(self, forKeyPath: observerKeyPathPlayerLayerReadyForDisplay, options: [.old, .new], context: nil)
    }
    
    private func observerStatus(forPlayerItem: AVPlayerItem?) {
        forPlayerItem?.addObserver(self, forKeyPath: observerKeyPathStatus, options: [.old, .new], context: nil)
    }
    
    private func removeObserverStatus(fromPlayerItem: AVPlayerItem?) {
        fromPlayerItem?.removeObserver(self, forKeyPath: observerKeyPathStatus)
    }
    
    private func observerLoadedTimeRanges(forPlayerItem: AVPlayerItem?) {
        forPlayerItem?.addObserver(self, forKeyPath: observerKeyPathLoadedTimeRanges, options: [.old, .new], context: nil)
    }
    
    private func removeObserverLoadedTimeRanges(fromPlayerItem: AVPlayerItem?) {
        fromPlayerItem?.removeObserver(self, forKeyPath: observerKeyPathLoadedTimeRanges)
    }
}

extension NPlayer {
    func map(transform: (NPlayerDelegate) -> Void) {
        let _ = delegates.map({
            transform($0)
        })
    }
}

// MARK: - notification
private extension NPlayer {
    
    func addPlayerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidPlayToEndTime), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerFailedToPlayToEndTime(notification:)), name: Notification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func playerDidPlayToEndTime() {
        self.map {
            $0.playerDidPlayEnd(player: self)
        }
    }
    
    @objc func playerFailedToPlayToEndTime(notification: Notification) {
        let reason = notification.userInfo?[AVPlayerItemFailedToPlayToEndTimeErrorKey]
        self.map {
            $0.playerDidPlay(player: self, failed:  reason as? Error ?? nil)
        }
    }
}

public class QLPlayerView: UIView {
    override public class var layerClass: AnyClass {
        get {
            return AVPlayerLayer.self
        }
    }
    
    public var playerLayer: AVPlayerLayer {
        get {
            let avLayer = self.layer as! AVPlayerLayer
            avLayer.videoGravity = .resizeAspect
            return avLayer
        }
    }
}
