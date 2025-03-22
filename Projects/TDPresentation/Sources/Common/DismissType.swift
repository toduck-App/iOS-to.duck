public enum DismissType {
    case pop
    case modal
    case sheet(completion: () -> Void)
}
