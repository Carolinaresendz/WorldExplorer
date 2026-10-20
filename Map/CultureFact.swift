import Foundation

enum FactCategory: String {
    case asia = "Asia"
    case europe = "Europe"
    case africa = "Africa"
    case americas = "Americas"
    case oceania = "Oceania"
}

struct CultureFact: Identifiable {
    let id: String
    let category: FactCategory
    let country: String
    let flag: String
    let title: String
    let catchyHook: String
    let fullFact: String
    let imageName: String

    var imageURL: String { imageName }

    init(
        id: String,
        category: FactCategory,
        country: String,
        flag: String,
        title: String,
        catchyHook: String,
        fullFact: String,
        imageName: String
    ) {
        self.id = id
        self.category = category
        self.country = country
        self.flag = flag
        self.title = title
        self.catchyHook = catchyHook
        self.fullFact = fullFact
        self.imageName = imageName
    }

    init(
        id: String,
        category: FactCategory,
        country: String,
        flag: String,
        title: String,
        catchyHook: String,
        fullFact: String,
        imageURL: String
    ) {
        self.init(
            id: id,
            category: category,
            country: country,
            flag: flag,
            title: title,
            catchyHook: catchyHook,
            fullFact: fullFact,
            imageName: imageURL
        )
    }
}
