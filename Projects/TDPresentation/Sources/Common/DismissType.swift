public enum DismissType {
    case pop
    case popNotAnimated
    case modal
    case sheet(completion: () -> Void)
}
