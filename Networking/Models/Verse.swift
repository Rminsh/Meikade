//
//  Verse.swift
//  Meikade
//
//  Created by Armin on 12/22/23.
//

import Foundation

public struct Verse: Codable {
    let id = UUID()
    let verseOrder: Int
    let position: Int
    let text: String?
    
    enum CodingKeys: String, CodingKey {
        case verseOrder = "vorder"
        case position
        case text
    }
    
    public init(
        verseOrder: Int,
        position: Int,
        text: String?
    ) {
        self.verseOrder = verseOrder
        self.position = position
        self.text = text ?? ""
    }
}

struct VersesResponse: Codable {
    let result: [Verse]
}

extension Verse {
    static let preview: [Verse] = [
        .init(
            verseOrder: 1,
            position: 0,
            text: "زاهد ظاهرپرست از حال ما آگاه نیست"
        ),
        .init(
            verseOrder: 2,
            position: 1,
            text: "در حق ما هر چه گوید جای هیچ اکراه نیست"
        ),
        .init(
            verseOrder: 3,
            position: 0,
            text: "در طریقت هر چه پیش سالک آید خیر اوست"
        ),
        .init(
            verseOrder: 4,
            position: 1,
            text: "در صراط مستقیم ای دل کسی گمراه نیست"
        ),
        .init(
            verseOrder: 5,
            position: 0,
            text: "تا چه بازی رخ نماید بیدقی خواهیم راند"
        ),
        .init(
            verseOrder: 6,
            position: 1,
            text: "عرصه شطرنج رندان را مجال شاه نیست"
        ),
        .init(
            verseOrder: 7,
            position: 0,
            text: "چیست این سقف بلند ساده بسیارنقش"
        ),
        .init(
            verseOrder: 8,
            position: 1,
            text: "زین معما هیچ دانا در جهان آگاه نیست"
        ),
        .init(
            verseOrder: 9,
            position: 0,
            text: "این چه استغناست یا رب وین چه قادر حکمت است"
        ),
        .init(
            verseOrder: 10,
            position: 1,
            text: "کاین همه زخم نهان هست و مجال آه نیست"
        ),
        .init(
            verseOrder: 11,
            position: 0,
            text: "صاحب دیوان ما گویی نمی‌داند حساب"
        ),
        .init(
            verseOrder: 12,
            position: 1,
            text: "کاندر این طغرا نشان حسبه لله نیست"
        ),
        .init(
            verseOrder: 13,
            position: 0,
            text: "هر که خواهد گو بیا و هر چه خواهد گو بگو"
        ),
        .init(
            verseOrder: 14,
            position: 1,
            text: "کبر و ناز و حاجب و دربان بدین درگاه نیست"
        ),
        .init(
            verseOrder: 15,
            position: 0,
            text: "بر در میخانه رفتن کار یک رنگان بود"
        ),
        .init(
            verseOrder: 16,
            position: 1,
            text: "خودفروشان را به کوی می فروشان راه نیست"
        ),
        .init(
            verseOrder: 17,
            position: 0,
            text: "هر چه هست از قامت ناساز بی اندام ماست"
        ),
        .init(
            verseOrder: 18,
            position: 1,
            text: "ور نه تشریف تو بر بالای کس کوتاه نیست"
        ),
        .init(
            verseOrder: 19,
            position: 0,
            text: "بنده پیر خراباتم که لطفش دایم است"
        ),
        .init(
            verseOrder: 20,
            position: 1,
            text: "ور نه لطف شیخ و زاهد گاه هست و گاه نیست"
        ),
        .init(
            verseOrder: 21,
            position: 0,
            text: "حافظ ار بر صدر ننشیند ز عالی مشربیست"
        ),
        .init(
            verseOrder: 22,
            position: 1,
            text: "عاشق دردی کش اندربند مال و جاه نیست"
        )
    ]
}
