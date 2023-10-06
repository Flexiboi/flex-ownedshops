local Translations = {
    error = {
        notenooughinv = 'Bu eşyadan yeterince yok...',
        notenooughstock = 'Stokta bu kadar yok...',
        error404item = 'Bu ürüne veya bu miktara sahip değilsiniz...',
        notworkinghere = 'Burada çalışmıyorsun..',
        notonduty = 'Görevde değilsin!',
        notboss = 'Buranın patronu sen değilsin.',
        nonegativeprice = 'Fiyat 0\'dan düşük olamaz..',
        broke = 'Yeterince paran yok..',
        buycantbezero = '0 alamazsın..',
    },
    success = {
        refillstock = 'Stoğa %{value} x %{value2} eklediniz',
        stockrefilled = 'Stoklar kaydedildi!',
        successbuy = '$%{value3} karşılığında %{value} x %{value2} satın aldınız',
        setprice = '%{value} itemini $%{value2}\'dan satışa çıkardınız',
        boughtshop = 'Bu dükkanı $%{value} karşılığında satın aldınız',
    },
    info = {
        openshop = 'Mağazayı Aç',
        manageshop = 'Mağazayı Yönet',
        dutychange = 'Göreve başla / bitir',
        onduty = 'Görev başındasınız',
        offduty = 'Görevde değilsin',
        emptyshop = 'Bu dükkan boş..',
    },
    managemenu = {
        buyshopheader = 'Bunu almak istediğine emin misin?',
        buyshop = 'Mağazayı $%{value} karşılığında satın alın',
        header = 'Mağazayı Yönet',
        checkstock = 'Stok Yönetimi </br> Stoklarınızı Görüntüleyin / Değiştirin',
        restock = 'Mağazaya ekle',
        close = 'Kapat',
        inventory = 'Envanter',
        buyheader = 'Mağaza',
        amount = 'Miktar: ',
        confirm = 'Onayla',
        stockamount = 'Stoğa ne kadar %{value} eklemek istiyorsunuz? (Elinizde: %{value2})',
        amountstock = 'Miktar',
        instock = 'Stoklarınızı yönetin </br> Fiyatı değiştirmek için tıklayın',
        goback = 'Geri',
        buyamount = 'Ne kadar %{value} almak istiyorsun? </br> $%{value2}/adet </br> Stok: %{value3}',
        price = '$%{value} adet',
        buy = 'Satın Al',
        whatprice = 'Kaç $ karşılığında %{value} satmak istiyorsun?',
        setprice = 'Onayla',
        howmuch = 'Adet başına kaç $?',
    }
}

if GetConvar('qb_locale', 'en') == 'tr' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end