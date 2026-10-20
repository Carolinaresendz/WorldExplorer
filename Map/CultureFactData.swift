import Foundation

enum CultureFactData {
    static let facts: [CultureFact] = [
        CultureFact(
            id: "japan-rabbit-island",
            category: .asia,
            country: "Japan",
            flag: "🇯🇵",
            title: "The Island Ruled by 1,000 Wild Rabbits",
            catchyHook: "Cars and predators are restricted here—tap to see what greets visitors at the ferry dock.",
            fullFact: "Ōkunoshima is a small island in the Inland Sea of Japan known as 'Usagi Jima' (Rabbit Island). Over 1,000 friendly wild rabbits roam freely across its forests and beaches. Dogs and cats are prohibited on the island to protect the rabbit population, and tourists travel from around the world to feed them cabbage and carrots.",
            imageURL: URL(string: "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800")
        ),
        CultureFact(
            id: "thailand-train-market",
            category: .asia,
            country: "Thailand",
            flag: "🇹🇭",
            title: "The Train Market That Folds Up in 60 Seconds",
            catchyHook: "Eight times a day, a live train barrels directly through the middle of this food market.",
            fullFact: "At the Maeklong Railway Market near Bangkok, vendors set up their fresh fruit and seafood stalls right on top of active train tracks. Whenever the train horn sounds, shopkeepers pull back their bamboo awnings and baskets in seconds, letting the train pass just inches away before resuming business immediately.",
            imageURL: URL(string: "https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?w=800")
        ),
        CultureFact(
            id: "italy-orange-battle",
            category: .europe,
            country: "Italy",
            flag: "🇮🇹",
            title: "The Medieval Town with a Three-Day Orange Food Fight",
            catchyHook: "Every February, thousands of locals dress in armor to pelt each other with 500,000 kilos of citrus.",
            fullFact: "In the northern Italian town of Ivrea, the historic Carnival features the 'Battle of the Oranges.' Residents divide into nine costumed foot squads and horse-drawn carts to reenact a medieval uprising against a tyrant—using crates of oranges as weapons. Anyone wearing a red Phrygian cap is spared from being hit!",
            imageURL: URL(string: "https://images.unsplash.com/photo-1516483638261-f4dbaf036963?w=800")
        ),
        CultureFact(
            id: "iceland-geothermal-bread",
            category: .europe,
            country: "Iceland",
            flag: "🇮🇸",
            title: "Baking Rye Bread Underground Using Volcano Heat",
            catchyHook: "No oven required: locals bury their dough in black volcanic sand for 24 hours.",
            fullFact: "In geothermal areas like Laugarvatn, Icelanders bake a dense, sweet dark rye bread called 'Hverabrauð' (hot spring bread). They seal the dough in a metal pot, bury it inside bubbling geothermal sand at 100°C, and dig it up the next day perfectly baked.",
            imageURL: URL(string: "https://images.unsplash.com/photo-1504893524553-b855bce32c67?w=800")
        ),
        CultureFact(
            id: "morocco-fez-tannery",
            category: .africa,
            country: "Morocco",
            flag: "🇲🇦",
            title: "The 1,000-Year-Old Leather Dye Pits of Fez",
            catchyHook: "Workers carry bunches of fresh mint up to the balconies—and it's not for making tea.",
            fullFact: "The Chouara Tannery in Fez has operated since the 11th century, using hundreds of stone vessels filled with natural dyes like poppy (red), saffron (yellow), and indigo (blue) to color leather by hand. Visitors are handed sprigs of fresh mint to hold near their noses while admiring the vivid honeycomb of dye vats.",
            imageURL: URL(string: "https://images.unsplash.com/photo-1539020140153-e479b8c22e70?w=800")
        ),
        CultureFact(
            id: "peru-uros-islands",
            category: .americas,
            country: "Peru",
            flag: "🇵🇪",
            title: "Floating Islands Hand-Woven From Lake Reeds",
            catchyHook: "When neighbors disagree here, they can literally untie their house and float away.",
            fullFact: "High in the Andes on Lake Titicaca, the indigenous Uros people construct entire floating islands, homes, and boats out of bundled Totora reeds. Because the bottom layers rot in the water over time, residents constantly add fresh layers of reeds on top to keep their island afloat.",
            imageURL: URL(string: "https://images.unsplash.com/photo-1526392060635-9d6019884377?w=800")
        ),
        CultureFact(
            id: "new-zealand-long-place-name",
            category: .oceania,
            country: "New Zealand",
            flag: "🇳🇿",
            title: "The Town With an 85-Letter Māori Name",
            catchyHook: "The street sign is longer than a bus—and tells a story of music and heartbreak.",
            fullFact: "A hill in Hawke's Bay holds the Guinness World Record for the longest place name in an English-speaking country: 'Taumatawhakatangihangakoauauotamateaturipukakapikimaungahoronukupokaiwhenuakitanatahu'. In Māori, it translates to 'The summit where Tamatea, the man with the big knees, the slider, climber of mountains, the land-swallower who travelled about, played his nose flute to his loved one.'",
            imageURL: URL(string: "https://images.unsplash.com/photo-1507699622108-4be3abd695ad?w=800")
        )
    ]
}
