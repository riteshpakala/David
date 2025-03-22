import Granite

struct TonalService: GraniteService {
    @Service(.online) var center: Center
    
    static var tonality: Tonality {
        .init()
    }
}
