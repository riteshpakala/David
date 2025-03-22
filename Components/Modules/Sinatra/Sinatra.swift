import Granite

struct Sinatra: GraniteComponent {
    @Command var center: Center
    @Relay var service: SinatraService
}
