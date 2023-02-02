local Translations = {
    motel = {
        ["chest"] = "Chest",
        ["exitroom"] = "Exit",
        ["enterroom"] = "Enter",
        ["outfits"] = "Outfits",
        ["shower"] = "Shower",
        ["sleep"] = "Sleep",
    },
    notify = {
        ["giveroom"] = "New Room Given!",
        ["cd"] = "You can use this command every 30 seconds!",
        ["shower"] = "You are smelling good",
        ["sleep"] = "You are more comfortable",
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})