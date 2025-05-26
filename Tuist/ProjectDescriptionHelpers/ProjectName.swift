import ProjectDescription

public enum TDModule: String {
    case toduck
    case TDCore
    case TDDesign
    
    case TDNetwork
    case TDStorage
    case TDData
    case TDDomain
    case TDPresentation
}

extension TDModule: CaseIterable {}
