import Kingfisher
import UIKit

public extension KingfisherManager {
    /// 단일 URL의 이미지 비율(H/W)을 가져옵니다. (캐시 우선, 없으면 비동기 로드)
    /// - Returns: width == 0 이면 nil
    func fetchImageAspect(
        for url: URL,
        options: KingfisherOptionsInfo? = nil
    ) async -> CGFloat? {
        let resource = KF.ImageResource(downloadURL: url)
        let cache = self.cache

        let resolvedOptions: KingfisherOptionsInfo
        if let options {
            resolvedOptions = options
        } else {
            let scale = await MainActor.run { UIScreen.main.scale }
            resolvedOptions = [.cacheOriginalImage, .backgroundDecode, .scaleFactor(scale)]
        }

        if let cached = cache.retrieveImageInMemoryCache(forKey: resource.cacheKey) {
            let size = cached.size
            guard size.width > 0 else { return nil }
            return size.height / size.width
        }

        return await withCheckedContinuation { cont in
            self.retrieveImage(with: resource, options: resolvedOptions) { result in
                switch result {
                case .success(let v):
                    let size = v.image.size
                    cont.resume(returning: size.width > 0 ? (size.height / size.width) : nil)
                case .failure:
                    cont.resume(returning: nil)
                }
            }
        }
    }

    /// 여러 URL의 이미지 비율(H/W)을 미리 가져옵니다. (캐시 포함)
    /// - Returns: 입력 순서를 보장하는 [CGFloat?]
    func fetchImageAspects(
        for urls: [URL],
        options: KingfisherOptionsInfo? = nil
    ) async -> [CGFloat?] {
        // Resolve options once to avoid touching UIScreen.main in a nonisolated context
        let resolvedOptions: KingfisherOptionsInfo
        if let options {
            resolvedOptions = options
        } else {
            let scale = await MainActor.run { UIScreen.main.scale }
            resolvedOptions = [.cacheOriginalImage, .backgroundDecode, .scaleFactor(scale)]
        }

        return await withTaskGroup(of: (Int, CGFloat?).self) { group in
            for (idx, url) in urls.enumerated() {
                group.addTask { [weak self] in
                    guard let self else { return (idx, nil) }
                    let aspect = await self.fetchImageAspect(for: url, options: resolvedOptions)
                    return (idx, aspect)
                }
            }

            var aspects = Array<CGFloat?>(repeating: nil, count: urls.count)
            for await (i, a) in group {
                aspects[i] = a
            }
            return aspects
        }
    }
}

/// 편의: `[URL]`에서 바로 호출
public extension Array where Element == URL {
    func kf_fetchAspects(
        options: KingfisherOptionsInfo? = nil
    ) async -> [CGFloat?] {
        await KingfisherManager.shared.fetchImageAspects(for: self, options: options)
    }
}

