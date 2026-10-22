extension FactPhotoCredit {
    static func credit(forImageNamed imageName: String) -> FactPhotoCredit? {
        if let credit = assetCredits[imageName] {
            return credit
        }

        guard let fact = CultureFactData.facts.first(where: { $0.imageName == imageName }) else {
            return nil
        }
        return credit(for: fact)
    }

    private static let assetCredits: [String: FactPhotoCredit] = [
        "ceramic3": FactPhotoCredit(
            author: "Dainé Zeferino",
            sourceURL: "https://www.pexels.com/photo/colorful-mexican-talavera-pottery-display-36103768/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "colorbags": FactPhotoCredit(
            author: "Dux Camp.",
            sourceURL: "https://www.pexels.com/photo/knitted-bags-hanging-on-the-wall-12333375/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "egypt": FactPhotoCredit(
            author: "Deepak Ramesha",
            sourceURL: "https://www.pexels.com/photo/close-up-of-colorful-dolls-7868580/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "elfna": FactPhotoCredit(
            author: "serdar barış",
            sourceURL: "https://www.pexels.com/photo/vibrant-market-scene-in-marrakesh-morocco-37295806/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "fiji": FactPhotoCredit(
            author: "Luis Ruiz",
            sourceURL: "https://www.pexels.com/photo/five-brown-bowls-on-table-1322841/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "fin2": FactPhotoCredit(
            author: "HUUM │sauna heaters",
            sourceURL: "https://www.pexels.com/photo/relaxing-nordic-sauna-with-wooden-interior-33517862/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "hat": FactPhotoCredit(
            author: "Joice Rivas",
            sourceURL: "https://www.pexels.com/photo/close-up-of-a-woman-weaving-a-traditional-basket-7261278/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "irish": FactPhotoCredit(
            author: "cottonbro studio",
            sourceURL: "https://www.pexels.com/photo/back-view-of-a-woman-recording-a-song-in-a-music-studio-7086742/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "korea": FactPhotoCredit(
            author: "Fernando B M",
            sourceURL: "https://www.pexels.com/photo/traditional-hanbok-attire-at-historic-korean-palace-34259246/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "mangolia": FactPhotoCredit(
            author: "Julia Volk",
            sourceURL: "https://www.pexels.com/photo/positive-mongolian-eagle-hunters-riding-horses-on-mountainous-terrain-5275479/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "maori": FactPhotoCredit(
            author: "Gaurav Kumar",
            sourceURL: "https://www.pexels.com/photo/traditional-maori-carving-in-lush-new-zealand-garden-32876104/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "mask": FactPhotoCredit(
            author: "Ana Belen Gomez Garcia",
            sourceURL: "https://www.pexels.com/photo/colorful-diablada-dance-performance-in-bolivia-36351401/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "music": FactPhotoCredit(
            author: "Tahir Xəlfə",
            sourceURL: "https://www.pexels.com/photo/capoeira-group-performing-outdoors-near-historic-building-37192940/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "music3": FactPhotoCredit(
            author: "Miguel Lozano",
            sourceURL: "https://www.pexels.com/photo/grayscale-photo-of-a-jazz-band-playing-live-music-11948658/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "napoli": FactPhotoCredit(
            author: "Wendy Wei",
            sourceURL: "https://www.pexels.com/photo/three-cups-of-coffee-on-saucers-1551346/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "sewing": FactPhotoCredit(
            author: "Los Muertos Crew",
            sourceURL: "https://www.pexels.com/photo/wood-person-art-creative-7205803/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "sweden": FactPhotoCredit(
            author: "Ea Ehn",
            sourceURL: "https://www.pexels.com/photo/white-ceramic-mug-with-coffee-beside-stainless-steel-teapot-on-brown-wooden-tray-3670580/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "tatu": FactPhotoCredit(
            author: "Dianne Magbanua-Negado",
            sourceURL: "https://www.pexels.com/photo/elderly-woman-tattooing-16561685/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "thai": FactPhotoCredit(
            author: "tejas gawde",
            sourceURL: "https://www.pexels.com/photo/a-woman-pouring-water-to-a-man-s-hand-during-a-wedding-ceremony-9144367/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        )
    ]
}
