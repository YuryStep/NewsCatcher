//
//  Request.swift
//  NewsCatcher
//
//  Created by Юрий Степанчук on 28.09.2023.
//

struct SearchSettings: Codable {
    enum Country: String, CaseIterable, Codable {
        case any = "Any:any"
        case australia = "🇦🇺 Australia:au"
        case brazil = "🇧🇷 Brazil:br"
        case canada = "🇨🇦 Canada:ca"
        case china = "🇨🇳 China:cn"
        case egypt = "🇪🇬 Egypt:eg"
        case france = "🇫🇷 France:fr"
        case germany = "🇩🇪 Germany:de"
        case greece = "🇬🇷 Greece:gr"
        case hongkong = "🇭🇰 Hong Kong:hk"
        case india = "🇮🇳 India:in"
        case ireland = "🇮🇪 Ireland:ie"
        case israel = "🇮🇱 Israel:il"
        case italy = "🇮🇹 Italy:it"
        case japan = "🇯🇵 Japan:jp"
        case netherlands = "🇳🇱 Netherlands:nl"
        case norway = "🇳🇴 Norway:no"
        case pakistan = "🇵🇰 Pakistan:pk"
        case peru = "🇵🇪 Peru:pe"
        case philippines = "🇵🇭 Philippines:ph"
        case portugal = "🇵🇹 Portugal:pt"
        case romania = "🇷🇴 Romania:ro"
        case russianFederation = "🇷🇺 Russia:ru"
        case singapore = "🇸🇬 Singapore:sg"
        case spain = "🇪🇸 Spain:es"
        case sweden = "🇸🇪 Sweden:se"
        case switzerland = "🇨🇭 Switzerland:ch"
        case taiwan = "🇹🇼 Taiwan:tw"
        case ukraine = "🇺🇦 Ukraine:ua"
        case unitedKingdom = "🇬🇧 United Kingdom:gb"
        case unitedStates = "🇺🇸 United States:us"

        static func fromName(_ name: String) -> Country {
            return Country.allCases.first { $0.name == name } ?? any
        }

        var name: String {
            return rawValue.components(separatedBy: ":").first ?? ""
        }

        var code: String {
            return rawValue.components(separatedBy: ":").last ?? ""
        }
    }

    enum Language: String, CaseIterable, Codable {
        case any = "Any:any"
        case arabic = "Arabic:ar"
        case chinese = "Chinese:zh"
        case dutch = "Dutch:nl"
        case english = "English:en"
        case french = "French:fr"
        case german = "German:de"
        case greek = "Greek:el"
        case hebrew = "Hebrew:he"
        case hindi = "Hindi:hi"
        case italian = "Italian:it"
        case japanese = "Japanese:ja"
        case malayalam = "Malayalam:ml"
        case marathi = "Marathi:mr"
        case norwegian = "Norwegian:no"
        case portuguese = "Portuguese:pt"
        case romanian = "Romanian:ro"
        case russian = "Russian:ru"
        case spanish = "Spanish:es"
        case swedish = "Swedish:sv"
        case tamil = "Tamil:ta"
        case telugu = "Telugu:te"
        case ukrainian = "Ukrainian:uk"

        static func fromName(_ name: String) -> Language {
            return Language.allCases.first { $0.name == name } ?? any
        }

        var name: String {
            return rawValue.components(separatedBy: ":").first ?? ""
        }

        var code: String {
            return rawValue.components(separatedBy: ":").last ?? ""
        }
    }

    private enum Constants {
        static let defaultSortBy = "publishedAt"
        static let titleSortQueryParameter = "title"
        static let descriptionSortQueryParameter = "description"
    }

    var articleLanguage: Language
    var publicationCountry: Country
    var searchInTitlesIsOn: Bool
    var searchInDescriptionsIsOn: Bool
    var searchInContentsIsOn: Bool
    var sortedBy: String

    init(articleLanguage: Language = Language.english,
         publicationCountry: Country = Country.any,
         searchInTitlesIsOn: Bool = true,
         searchInDescriptionsIsOn: Bool = true,
         searchInContentsIsOn: Bool = false,
         sortedBy: String = Constants.defaultSortBy)
    {
        self.articleLanguage = articleLanguage
        self.publicationCountry = publicationCountry
        self.searchInTitlesIsOn = searchInTitlesIsOn
        self.searchInDescriptionsIsOn = searchInDescriptionsIsOn
        self.searchInContentsIsOn = searchInContentsIsOn
        self.sortedBy = sortedBy
    }
}

struct Request {
    private enum Constants {
        static let keyword = "Apple"
    }

    let settings: SearchSettings
    let keyword: String

    init(settings: SearchSettings = SearchSettings(), keyword: String = Constants.keyword) {
        self.settings = settings
        self.keyword = keyword
    }
}
