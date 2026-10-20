enum QuizQuestionBank {
    static func questions(for region: WorldRegion) -> [QuizQuestion] {
        switch region {
        case .africa:
            africaQuestions
        case .asia:
            asiaQuestions
        case .europe:
            europeQuestions
        case .northAmerica:
            northAmericaQuestions
        case .oceania:
            oceaniaQuestions
        case .southAmerica:
            southAmericaQuestions
        }
    }

    private static let africaQuestions = [
        QuizQuestion(
            id: "africa-city",
            location: "Morocco",
            prompt: "In which city is Jemaa el-Fna Square?",
            answers: ["Marrakesh", "Cairo", "Dakar", "Tunis"],
            correctAnswer: "Marrakesh",
            imageName: "Djemaa_el_Fna"
        ),
        QuizQuestion(
            id: "africa-square",
            location: "Marrakesh, Morocco",
            prompt: "What is Jemaa el-Fna especially known for?",
            answers: [
                "Storytellers and performers",
                "Ice sculpture",
                "Opera houses",
                "Tea plantations"
            ],
            correctAnswer: "Storytellers and performers",
            imageName: "Djemaa_el_Fna"
        ),
        QuizQuestion(
            id: "africa-heritage",
            location: "Marrakesh, Morocco",
            prompt: "Jemaa el-Fna is recognized as what kind of heritage?",
            answers: [
                "Living cultural heritage",
                "Marine heritage",
                "Industrial heritage",
                "Space heritage"
            ],
            correctAnswer: "Living cultural heritage",
            imageName: "Djemaa_el_Fna"
        )
    ]

    private static let asiaQuestions = [
        QuizQuestion(
            id: "asia-hanbok",
            location: "South Korea",
            prompt: "What is traditional Korean clothing called?",
            answers: ["Hanbok", "Kimono", "Cheongsam", "Sari"],
            correctAnswer: "Hanbok",
            imageName: "Hanbok_(female_and_male)"
        ),
        QuizQuestion(
            id: "asia-holi",
            location: "India",
            prompt: "Which festival is famous for brightly colored powders?",
            answers: ["Holi", "Diwali", "Vesak", "Obon"],
            correctAnswer: "Holi",
            imageName: "Hindu-Holi-Festival-Mathura-Uttar-Pradesh-India.jpg"
        ),
        QuizQuestion(
            id: "asia-silence",
            location: "Japan",
            prompt: "In many Japanese social situations, silence can communicate what?",
            answers: ["Thoughtfulness", "Disinterest only", "A greeting", "A celebration"],
            correctAnswer: "Thoughtfulness",
            imageName: "images"
        )
    ]

    private static let europeQuestions = [
        QuizQuestion(
            id: "europe-sauna",
            location: "Finland",
            prompt: "In Finland, a sauna can also be what kind of place?",
            answers: ["A social space", "A courtroom", "A market", "A library"],
            correctAnswer: "A social space",
            imageName: "images-2"
        ),
        QuizQuestion(
            id: "europe-sauna-purpose",
            location: "Finland",
            prompt: "Finnish sauna culture is associated with relaxation and what else?",
            answers: [
                "Spending time together",
                "Competitive racing",
                "Street trading",
                "Mountain climbing"
            ],
            correctAnswer: "Spending time together",
            imageName: "images-2"
        ),
        QuizQuestion(
            id: "europe-sauna-common",
            location: "Finland",
            prompt: "How are saunas generally regarded in Finnish everyday life?",
            answers: ["Familiar and ordinary", "Forbidden", "Only ceremonial", "Only for tourists"],
            correctAnswer: "Familiar and ordinary",
            imageName: "images-2"
        )
    ]

    private static let northAmericaQuestions = [
        QuizQuestion(
            id: "north-flower",
            location: "Michoacán, Mexico",
            prompt: "Which flower is strongly associated with Día de Muertos?",
            answers: ["Cempasúchil", "Tulip", "Lotus", "Lavender"],
            correctAnswer: "Cempasúchil",
            imageName: "images-3"
        ),
        QuizQuestion(
            id: "north-color",
            location: "Michoacán, Mexico",
            prompt: "What color are cempasúchil flowers usually known for?",
            answers: ["Bright orange", "Deep blue", "Pure black", "Silver"],
            correctAnswer: "Bright orange",
            imageName: "images-3"
        ),
        QuizQuestion(
            id: "north-path",
            location: "Michoacán, Mexico",
            prompt: "Why are paths of marigolds sometimes created?",
            answers: [
                "To symbolically guide loved ones",
                "To mark a race",
                "To measure rainfall",
                "To dry the flowers"
            ],
            correctAnswer: "To symbolically guide loved ones",
            imageName: "images-3"
        )
    ]

    private static let oceaniaQuestions = [
        QuizQuestion(
            id: "oceania-material",
            location: "Vanuatu",
            prompt: "Where are traditional Vanuatu drawings traced?",
            answers: ["Sand, ash or clay", "Glass", "Silk", "Metal"],
            correctAnswer: "Sand, ash or clay",
            imageName: "images-4"
        ),
        QuizQuestion(
            id: "oceania-method",
            location: "Vanuatu",
            prompt: "How is the continuous line traditionally drawn?",
            answers: ["With one finger", "With a compass", "With a brush", "With a chisel"],
            correctAnswer: "With one finger",
            imageName: "images-4"
        ),
        QuizQuestion(
            id: "oceania-purpose",
            location: "Central and northern Vanuatu",
            prompt: "What can sand drawings help transmit?",
            answers: [
                "Stories and knowledge",
                "Only decoration",
                "Weather forecasts only",
                "Currency values"
            ],
            correctAnswer: "Stories and knowledge",
            imageName: "images-4"
        )
    ]

    private static let southAmericaQuestions = [
        QuizQuestion(
            id: "south-country",
            location: "Cusco Region, Peru",
            prompt: "The Qoyllurit’i pilgrimage takes place in which country?",
            answers: ["Peru", "Chile", "Brazil", "Argentina"],
            correctAnswer: "Peru",
            imageName: "images-5"
        ),
        QuizQuestion(
            id: "south-valley",
            location: "Cusco Region, Peru",
            prompt: "Where is the Qoyllurit’i sanctuary located?",
            answers: ["Sinakara Valley", "Sacred Valley", "Colca Canyon", "Atacama Desert"],
            correctAnswer: "Sinakara Valley",
            imageName: "images-5"
        ),
        QuizQuestion(
            id: "south-expression",
            location: "Sinakara Valley, Peru",
            prompt: "Which expression plays a central role in the pilgrimage?",
            answers: ["Dance", "Sculpture", "Cinema", "Calligraphy"],
            correctAnswer: "Dance",
            imageName: "images-5"
        )
    ]
}
