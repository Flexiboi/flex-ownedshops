local Translations = {
    error = {
        notenooughinv = 'You dont have enough of this item..',
        notenooughstock = 'There is not this much in stock..',
        error404item = 'You dont have this item or this amount..',
        notworkinghere = 'You dont work here..',
        notonduty = 'You are not on duty!',
        notboss = 'You are not the boss here..',
        nonegativeprice = 'The price cant be lower than 0..',
        broke = 'You dont have enough money..',
        buycantbezero = 'You cant buy 0..',
    },
    success = {
        refillstock = 'You added %{value} x %{value2} to the stock',
        stockrefilled = 'Stock has been saved!',
        successbuy = 'You bought %{value} x %{value2} for $%{value3}',
        setprice = 'You put %{value} up for sale at $%{value2}',
        boughtshop = 'You bought this shop for $%{value}',
    },
    info = {
        openshop = 'Open Shop',
        manageshop = 'Manage Shop',
        dutychange = 'Go on/off duty',
        onduty = 'You are on duty',
        offduty = 'You are off duty',
        emptyshop = 'This shop is empty..',
    },
    managemenu = {
        buyshopheader = 'You sure you want to buy this?',
        buyshop = 'Buy shop for $%{value}',
        header = 'Manage Shop',
        checkstock = 'Manage Stock </br> View / Change your stock',
        restock = 'Add to shop',
        close = 'Close',
        inventory = 'Inventory',
        buyheader = 'Shop',
        amount = 'Amount: ',
        confirm = 'Confirm',
        stockamount = 'How much %{value} you want to add to the stock? (You have: %{value2})',
        amountstock = 'Amount',
        instock = 'Manage your stock </br> Click on something to change the price',
        goback = 'Go Back',
        buyamount = 'How much %{value} you want to buy? </br> $%{value2}/piece </br> Stock: %{value3}',
        price = '$%{value} a piece',
        buy = 'Buy',
        whatprice = 'For much much in $ you want to sell %{value}?',
        setprice = 'Confirm',
        howmuch = 'How much $ per piece?',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
