import Granite

struct SinatraService: GraniteService {
    @Service(.online) var center: Center
}
