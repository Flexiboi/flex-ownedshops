local Translations = {
    error = {
        notenooughinv = 'Je hebt zoveel niet in je broekzak zitten..',
        notenooughstock = 'Niet zo veel op voorraad..',
        error404item = 'Je hebt dit spul niet of de hoeveelheid..',
        notworkinghere = 'Je werkt hier niet..',
        notonduty = 'Je bent niet in dienst!',
        notboss = 'Je bent de baas niet..',
        nonegativeprice = 'Je prijs mag niet onder de 0 zijn..',
        broke = 'Je hebt niet geneog geld..',
        buycantbezero = 'Je kan niet niets kopen..',
    },
    success = {
        refillstock = 'Je vulde je stock aan met %{value} x %{value2}',
        stockrefilled = 'Je stock is bijgewerkt!',
        successbuy = 'Je hebt %{value} x %{value2} gekocht voor €%{value3}',
        setprice = 'Je zette %{value} op €%{value2}',
        boughtshop = 'Je kocht deze winkel voor €%{value}',
    },
    info = {
        openshop = 'Open winkel',
        manageshop = 'Beheer winkel',
        dutychange = 'Ga in/uit dienst',
        onduty = 'Je bent nu in dienst',
        offduty = 'Je bent nu uit dienst',
        emptyshop = 'Deze winkel is leeg..',
    },
    managemenu = {
        buyheader = 'Zeker dat je dit wil kopen?',
        buyshop = 'Koop winkel voor €%{value}',
        header = 'Winkel beheren',
        checkstock = 'Beheer stock </br> Bekijk en pas je stock aan',
        restock = 'Hervul winkel',
        close = 'Sluit',
        inventory = 'Broekzak',
        buyheader = 'Winkel',
        amount = 'Hoeveelheid: ',
        confirm = 'Bevestig',
        stockamount = 'Hoeveel van %{value} wil in je stock steken? (In bezit: %{value2})',
        amountstock = 'Hoeveelheid',
        instock = 'Beheer je stock </br> Klik op iets om je prijs in te stellen',
        goback = 'Ga terug',
        buyamount = 'Hoeveel van %{value} wil je kopen? </br> €%{value2}/stuk </br> In stock: %{value3}',
        price = '€%{value} per stuk',
        buy = 'Koop',
        whatprice = 'Voor hoeveel € wil je %{value} te koop zetten?',
        setprice = 'Stel in',
        howmuch = 'Hoeveel € per stuk?',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
