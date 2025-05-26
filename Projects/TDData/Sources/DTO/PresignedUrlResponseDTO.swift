public struct PresignedUrlResponseDTO: Decodable {
    public let fileUrlsDtos: [FileURLDTO]
    
    public struct FileURLDTO: Decodable {
        public let presignedUrl: String
        public let fileUrl: String
    }
}
