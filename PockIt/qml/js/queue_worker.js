WorkerScript.onMessage = function(msg) {
    console.log('queue_sync_start')

    var db_queue_items = msg.db_queue_items;

    var delete_queue_works = []

    for(var queue_i in db_queue_items) {
        var url = db_queue_items[queue_i].url
        var data = db_queue_items[queue_i].params
        var new_data = db_queue_items[queue_i].new_params

        var xhr = new XMLHttpRequest;
        xhr.open("POST", url);

        xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded; charset=UTF8");
        xhr.setRequestHeader("X-Accept", "application/json");

        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                if (xhr.status !== 0) {
                    console.log(xhr.responseText)
                    var results = JSON.parse(xhr.responseText);

                    if (results.status == 1) {
                        WorkerScript.sendMessage({'action': 'DELETE_WORKS', 'params': data, 'url': url, 'finish': queue_i+1==objectLength(db_queue_items)})
                    }
                }
            }
        }

        xhr.send(new_data);
    }
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
