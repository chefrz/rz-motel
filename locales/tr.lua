local Translations = {
    motel = {
        ["chest"] = "Sandık",
        ["exitroom"] = "Ayrıl",
        ["enterroom"] = "Motel",
        ["outfits"] = "Kıyafet Dolabı",
        ["shower"] = "Duş",
        ["sleep"] = "Yat",
    },
    notify = {
        ["giveroom"] = "Yeni Oda Verildi!",
        ["cd"] = "Bu komutu 30 saniyede bir kullanabilirsin!",
        ["shower"] = "Güzel Kokuyorsun",
        ["sleep"] = "Rahatladın",
        ["room_full"] = "Model odası dolu!",
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
