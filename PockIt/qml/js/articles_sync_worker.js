WorkerScript.onMessage = function(msg) {
    console.log('articles_sync_start')

    var item_id = msg.item_id
    var resolved_url = msg.resolved_url
    var index = msg.index
    var mustGetArticlesList = msg.mustGetArticlesList

    var parseArticle = false
    if (msg.parseArticle) {
        parseArticle = true
    }

    var data = "consumer_key="+msg.consumer_key+"&url="+encodeURIComponent(resolved_url)+"&refresh=1&images=1&videos=1&output=json";

    var xhr = new XMLHttpRequest;
    xhr.open("POST", "http://text.getpocket.com/v3/text");

    xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded; charset=UTF8");
    xhr.setRequestHeader("X-Accept", "application/json");

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            if (xhr.status !== 0) {
                var results = JSON.parse(xhr.responseText);

                console.log('geldi')

                WorkerScript.sendMessage({'action': 'ARTICLES_WORKS', 'article_result': results, 'item_id': item_id, 'parseArticle': parseArticle, 'finish': index+1===objectLength(mustGetArticlesList)})
                if (index+1 < objectLength(mustGetArticlesList)) {
                    WorkerScript.sendMessage({'action': 'LOOP_WORKS', 'index': index+1, 'mustGetArticlesList': mustGetArticlesList})
                }
            }
        }
    }

    xhr.send(data);
}

function objectLength(obj) {
    var result = 0

    for(var prop in obj) {
        if (obj.hasOwnProperty(prop)) {
          result++
        }
    }

    return result
}
