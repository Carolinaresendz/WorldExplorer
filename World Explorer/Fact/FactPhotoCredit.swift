import Foundation

struct FactPhotoCredit {
    let author: String
    let sourceURL: String
    let license: String
    let licenseURL: String

    private static let credits: [CultureFact.ID: FactPhotoCredit] = [
        "canada-maple-sap": FactPhotoCredit(
            author: "BiblioArchives / LibraryArchives",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Three_boys_carrying_buckets_of_maple_sap,_Qu%C3%A9bec_Trois_gar%C3%A7ons_transportant_des_chaudi%C3%A8res_d%E2%80%99eau_d%E2%80%99%C3%A9rable_(Qu%C3%A9bec)_(40018423323).jpg",
            license: "CC BY 2.0",
            licenseURL: "https://creativecommons.org/licenses/by/2.0"
        ),
        "guatemala-holy-week-carpets": FactPhotoCredit(
            author: "Infrogmation",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Semana_Santa_en_Antigua_Guatemala_1981_-_Alfombras_01.jpg",
            license: "CC BY-SA 4.0",
            licenseURL: "https://creativecommons.org/licenses/by-sa/4.0"
        ),
        "italy-matera-sassi": FactPhotoCredit(
            author: "RODRIG75O",
            sourceURL: "https://commons.wikimedia.org/wiki/File:MATERA_SASSI_PANORAMA.jpg",
            license: "CC BY-SA 4.0",
            licenseURL: "https://creativecommons.org/licenses/by-sa/4.0"
        ),
        "italy-naples-pizzaiuolo": FactPhotoCredit(
            author: "CDibisceglia",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Forno_a_legna_pizza_napoletana.jpg",
            license: "CC BY-SA 4.0",
            licenseURL: "https://creativecommons.org/licenses/by-sa/4.0"
        ),
        "italy-puglia-trulli": FactPhotoCredit(
            author: "Vasilios Vlachopoulos",
            sourceURL: "https://commons.wikimedia.org/wiki/File:I_trulli_di_Alberobello.jpg",
            license: "CC BY-SA 4.0",
            licenseURL: "https://creativecommons.org/licenses/by-sa/4.0"
        ),
        "italy-sicily-pupi": FactPhotoCredit(
            author: "Dennis G. Jarvis",
            sourceURL: "https://commons.wikimedia.org/wiki/File:PupiSiciliani.jpg",
            license: "CC BY-SA 2.0",
            licenseURL: "https://creativecommons.org/licenses/by-sa/2.0"
        ),
        "peru-taquile-textiles": FactPhotoCredit(
            author: "Thomas Quine",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Knitter_of_Taquile.jpg",
            license: "CC BY 2.0",
            licenseURL: "https://creativecommons.org/licenses/by/2.0"
        ),
        "usa-hawaii-hula": FactPhotoCredit(
            author: "Mezzapictura",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Hula_dancers.jpg",
            license: "CC BY-SA 4.0",
            licenseURL: "https://creativecommons.org/licenses/by-sa/4.0"
        ),
        "usa-los-angeles-mariachi": FactPhotoCredit(
            author: "RDNE Stock project",
            sourceURL: "https://www.pexels.com/photo/mariachi-band-playing-in-front-of-the-pasadena-city-hall-8638001/",
            license: "Pexels License",
            licenseURL: "https://www.pexels.com/license/"
        ),
        "argentina-uruguay-tango": FactPhotoCredit(
            author: "Ralf Steinberger from Milan, Berlin + Munich, Italy + Germany",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Tango_dancers_in_Buenos_Aires,_Argentina._(33570798082).jpg",
            license: "CC BY 2.0",
            licenseURL: "https://creativecommons.org/licenses/by/2.0"
        ),
        "colombia-barranquilla-carnival": FactPhotoCredit(
            author: "Michele Mariani",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Marimonda_-_Carnaval_de_Barranquilla_2012.jpg",
            license: "CC BY-SA 2.0",
            licenseURL: "https://creativecommons.org/licenses/by-sa/2.0"
        ),
        "brazil-capoeira-roda": FactPhotoCredit(
            author: "Ricardo André Frantz (User:Tetraktys)",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Roda_de_capoeira1.jpg",
            license: "CC BY-SA 3.0",
            licenseURL: "https://creativecommons.org/licenses/by-sa/3.0"
        ),
        "ecuador-toquilla-weaving": FactPhotoCredit(
            author: "hatsfromtheheart.ec",
            sourceURL: "https://commons.wikimedia.org/wiki/File:The_toquilla_straw_hat_is_woven_from_fibres_from_a_palm_tree_characteristic_of_the_Ecuadorian_coast.jpg",
            license: "CC BY-SA 4.0",
            licenseURL: "https://creativecommons.org/licenses/by-sa/4.0"
        ),
        "finland-sauna-loyly": FactPhotoCredit(
            author: "Santeri Viinamäki",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Finnish_sauna_20170826.jpg",
            license: "CC BY-SA 4.0",
            licenseURL: "https://creativecommons.org/licenses/by-sa/4.0"
        ),
        "ghana-kente-strips": FactPhotoCredit(
            author: "Warmglow",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Kente_weaving_in_loom.jpg",
            license: "CC0",
            licenseURL: "http://creativecommons.org/publicdomain/zero/1.0/deed.en"
        ),
        "indonesia-wayang-shadows": FactPhotoCredit(
            author: "Yudirahmat12",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Wayang_kulit.jpg",
            license: "CC BY-SA 4.0",
            licenseURL: "https://creativecommons.org/licenses/by-sa/4.0"
        ),
        "mexico-day-of-dead-offerings": FactPhotoCredit(
            author: "Carloospadilla7",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Ofrenda_de_d%C3%ADa_de_muertos.jpg",
            license: "CC BY-SA 4.0",
            licenseURL: "https://creativecommons.org/licenses/by-sa/4.0"
        ),
        "mexico-talavera-craft": FactPhotoCredit(
            author: "AlejandroLinaresGarcia",
            sourceURL: "https://commons.wikimedia.org/wiki/File:TalaveraPlateMAPDF.JPG",
            license: "CC BY-SA 4.0",
            licenseURL: "https://creativecommons.org/licenses/by-sa/4.0"
        ),
        "morocco-jemaa-storytelling": FactPhotoCredit(
            author: "Carlos ZGZ from Paris, France",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Storytellers_in_Jemaa_el-Fnaa_(Marrakech,_Morocco)_(15722800436).jpg",
            license: "CC0",
            licenseURL: "http://creativecommons.org/publicdomain/zero/1.0/deed.en"
        ),
        "spain-castells-teamwork": FactPhotoCredit(
            author: "Pere López Brosa",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Diada_castellera_de_la_Festa_Major_de_la_Salut_2026_-_Torre_de_7_dels_Castellers_de_la_Vila_de_Gr%C3%A0cia_-_20260906_134919.jpg",
            license: "CC BY-SA 4.0",
            licenseURL: "https://creativecommons.org/licenses/by-sa/4.0"
        ),
        "thailand-songkran-renewal": FactPhotoCredit(
            author: "ผู้สร้างสรรค์ผลงาน/ส่งข้อมูลเก็บในคลังข้อมูลเสรีวิกิมีเดียคอมมอนส์ - เทวประภาส มากคล้าย",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Songkran_in_Wat_Kungthapao004.jpg",
            license: "CC BY 3.0",
            licenseURL: "https://creativecommons.org/licenses/by/3.0"
        ),
        "tonga-lakalaka-stories": FactPhotoCredit(
            author: "Smita Biswas/Auckland Libraries Heritage Collections (POLY-D-2015-091)",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Tongan_Lakalaka_dance,_ASB_Polyfest._(POLY-D-2015-091).jpg",
            license: "CC BY 4.0",
            licenseURL: "https://creativecommons.org/licenses/by/4.0"
        ),
        "vanuatu-sand-stories": FactPhotoCredit(
            author: "PhillipC",
            sourceURL: "https://commons.wikimedia.org/wiki/File:Sand_drawing,_Vanuatu.jpg",
            license: "CC BY 2.0",
            licenseURL: "https://creativecommons.org/licenses/by/2.0"
        )
    ]

    static func credit(for fact: CultureFact) -> FactPhotoCredit? {
        credits[fact.id]
    }
}
