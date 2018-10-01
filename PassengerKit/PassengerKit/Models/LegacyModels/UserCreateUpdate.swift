

//struct UserCreate: Encodable {
//
//    var firstName: String
//
//    var lastName: String
//
//    var email: String
//
//    var password: String?
//
//}

typealias UserCreate = User

struct UserUpdate: Encodable {

    enum Role: String, Encodable {

        case any = "Any"

        case attendant = "Attendant"

        case managementConsole = "ManagementConsoleUser"

        case marketing = "MarketingUser"

        case none = "None"

        case passenger = "Passenger"

        case warehouse = "WarehouseUser"

    }

    var firstName: String

    var lastName: String

    var email: String

    var role: Role?

}
