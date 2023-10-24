var result = {}
$('#UnusualGemsQuality tbody tr').each((index, element) => {
	var tds = $(element).find('td');
    var gem = $(tds[0]).find('a')[0].innerHTML
    var type = tds[1].innerHTML
    var weight = tds[3].innerHTML
    if (result[gem] === undefined) {
        result[gem] = {}
    }
    result[gem][type] = parseInt(weight)
})