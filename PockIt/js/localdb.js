// DB
function init() {
    var db = LocalStorage.openDatabaseSync("pockit", "1.0", "Database for PockIt", "1000000");

    db.transaction(function(tx) {
        tx.executeSql('CREATE TABLE IF NOT EXISTS user(key TEXT UNIQUE, value TEXT)');

        tx.executeSql('CREATE TABLE IF NOT EXISTS Entries(item_id TEXT UNIQUE, resolved_id TEXT, sortid INTEGER, given_url TEXT, resolved_url TEXT, given_title, resolved_title, favorite TEXT, status TEXT, excerpt TEXT, is_article TEXT, has_image TEXT, has_video TEXT, word_count TEXT, tags TEXT, authors TEXT, images TEXT, videos TEXT, image TEXT, is_index TEXT, time_added TEXT, time_updated TEXT)');
        tx.executeSql('CREATE TABLE IF NOT EXISTS Articles(item_id TEXT UNIQUE, resolved_url TEXT, title TEXT, host TEXT, article TEXT, datePublished TEXT)');

        tx.executeSql('CREATE TABLE IF NOT EXISTS Tags(item_id TEXT, item_key TEXT, tag VARCHAR(250), entry_id TEXT)');
    });

    return db;
}
