WorkerScript.onMessage = function(msg) {
    var api_entries = msg.api_entries
    var db_entries = msg.db_entries
    var db_articles = msg.db_articles
    var db_tags = msg.db_tags

    var entries_works = {}
    var delete_entries_works = {}
    var delete_articles_works = {}
    var delete_tags_works = {}

    for(var api_i in api_entries) {
        var api_item_id = api_entries[api_i].item_id

        // Entry exists in DB
        if (db_entries.hasOwnProperty(api_item_id)) {
            // Entry hasn't updated
            if (db_entries[api_item_id].time_updated === api_entries[api_i].time_updated) {
                entries_works[api_item_id] = {'action': 'KEEP'}
            } else {
                entries_works[api_item_id] = {'action': 'UPDATE'}
            }
        } else {
            entries_works[api_item_id] = {'action': 'INSERT'}
        }
    }

    for (var db_e_i in db_entries) {
        if (!api_entries.hasOwnProperty(db_e_i)) {
            delete_entries_works[db_e_i] = {'action': 'DELETE'}
        }
    }

    for (var db_a_i in db_articles) {
        if (!api_entries.hasOwnProperty(db_a_i)) {
            delete_articles_works[db_a_i] = {'action': 'DELETE'}
        }
    }

    for (var db_t_i in db_tags) {
        if (!api_entries.hasOwnProperty(db_tags[db_t_i].entry_id)) {
            delete_tags_works[db_t_i] = {'action': 'DELETE', 'entry_id': db_tags[db_t_i].entry_id}
        } else if (!api_entries[db_tags[db_t_i].entry_id]['tags'] || (api_entries[db_tags[db_t_i].entry_id]['tags'] && !api_entries[db_tags[db_t_i].entry_id]['tags'].hasOwnProperty(db_tags[db_t_i].item_key))) {
            delete_tags_works[db_t_i] = {'action': 'DELETE', 'item_key': db_tags[db_t_i].item_key, 'entry_id': db_tags[db_t_i].entry_id}
        }
    }

    WorkerScript.sendMessage({'action': 'ENTRIES_WORKS', 'entries_works': entries_works, 'api_entries': api_entries})
    WorkerScript.sendMessage({'action': 'DELETE_WORKS', 'entries': delete_entries_works, 'articles': delete_articles_works, 'tags': delete_tags_works})
}
