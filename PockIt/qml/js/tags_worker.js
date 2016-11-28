WorkerScript.onMessage = function(msg) {
    var model = msg.model
    var db_tags = msg.db_tags

    if (msg.clear_model) {
        model.clear()
    }

    model.append({"item_id":"0", "item_key":"0", "tag":"0", "entry_id":"0"});

    for(var db_i = 0; db_i < db_tags.length; db_i++) {
        var item_id = db_tags[db_i].item_id
        var item_key = db_tags[db_i].item_key
        var tag = db_tags[db_i].tag
        var entry_id = db_tags[db_i].entry_id

        model.append({"item_id":item_id, "item_key":item_key, "tag":tag, "entry_id":entry_id});
    }

    model.sync()
}
