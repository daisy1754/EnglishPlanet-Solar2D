local module = {}

module.seedQuery = [[INSERT INTO words ('word', 'translation', 'category') VALUES
    ('apple ', 'りんご', 'food'),
    ('orange', 'みかん', 'food'),
    ('strawberry', 'いちご', 'food'),
    ('grape', 'ぶどう', 'food'),
    ('watermelon', 'すいか', 'food'),
    ('tea', 'おちゃ', 'food'),
    ('coffee', 'コーヒー', 'food'),
    ('milk', 'ぎゅうにゅう', 'food'),
    ('rice', 'ごはん', 'food'),
    ('soup', 'スープ', 'food'),
    ('egg', 'たまご', 'food'),
    ('pizza', 'ピザ', 'food'),
    ('chocolate', 'チョコレート', 'food'),
    ('pumpkin', 'かぼちゃ', 'food'),
    ('potato', 'じゃがいも', 'food'),
    ('onion', 'たまねぎ', 'food'),
    ('carrot', 'にんじん', 'food'),
    ('chiken', 'とりにく', 'food'),
    ('bread', 'パン', 'food'),
    ('water', 'みず', 'food'),
    ('Monday', 'げつようび', 'jikan'),
    ('Tuesday', 'かようび', 'jikan'),
    ('Wednesday', 'すいようび', 'jikan'),
    ('Thursday', 'もくようび', 'jikan'),
    ('Friday', 'きんようび', 'jikan'),
    ('Saturday', 'どようび', 'jikan'),
    ('Sunday', 'にちようび', 'jikan'),
    ('January', '1がつ', 'jikan'),
    ('February', '2がつ', 'jikan'),
    ('March', '3がつ', 'jikan'),
    ('April', '4がつ', 'jikan'),
    ('May', '5がつ', 'jikan'),
    ('June', '6がつ', 'jikan'),
    ('July', '7がつ', 'jikan'),
    ('August', '8がつ', 'jikan'),
    ('September', '9がつ', 'jikan'),
    ('October', '10がつ', 'jikan'),
    ('November', '11がつ', 'jikan'),
    ('December', '12がつ', 'jikan'),
    ('spring', 'はる', 'jikan'),
    ('summer', 'なつ', 'jikan'),
    ('fall', 'あき', 'jikan'),
    ('winter', 'ふゆ', 'jikan'),
    ('father', 'おとうさん', 'family'),
    ('mother', 'おかあさん', 'family'),
    ('broser', 'きょうだい', 'family'),
    ('sister', 'しまい', 'family'),
    ('parent', 'おや', 'family'),
    ('child', 'こども', 'family'),
    ('son', 'むすこ', 'family'),
    ('daughter', 'むすめ', 'family'),
    ('grandfather', 'おじいちゃん', 'family'),
    ('grandmother', 'おばあちゃん', 'family'),
    ('uncle', 'おじさん', 'family'),
    ('aunt', 'おばさん', 'family'),
    ('cousin', 'いとこ', 'family'),
    ('sunny', 'はれ', 'weather'),
    ('cloudy', 'くもり', 'weather'),
    ('rainy', 'あめ', 'weather'),
    ('snow', 'ゆき', 'weather'),
    ('warm', 'あたたかい', 'weather'),
    ('cold', 'さむい', 'weather'),
    ('wet', 'しめった', 'weather'),
    ('dry', 'かんそうした', 'weather'),
    ('rainbow', 'にじ', 'weather'),
    ('windy', 'かぜがつよい', 'weather'),
    ('thunderbolt', 'かみなり', 'weather'),
    ('storm', 'あらし', 'weather'),
    ('car', 'くるま', 'norimono'),
    ('bike', 'バイク', 'norimono'),
    ('train', 'でんしゃ', 'norimono'),
    ('bus', 'バス', 'norimono'),
    ('bicycle', 'じてんしゃ', 'norimono'),
    ('airplane', 'ひこうき', 'norimono'),
    ('boat', 'ボート', 'norimono'),
    ('ship', 'ふね', 'norimono'),
    ('spaceship', 'うちゅうせん', 'norimono'),
    ('taxi', 'タクシー', 'norimono'),
    ('engine', 'エンジン', 'norimono'),
    ('house', 'いえ', 'mono'),
    ('kitchen', 'キッチン', 'mono'),
    ('window', 'まど', 'mono'),
    ('room', 'へや', 'mono'),
    ('computer', 'コンピューター', 'mono'),
    ('desk', 'つくえ', 'mono'),
    ('table', 'テーブル', 'mono'),
    ('chair', 'いす', 'mono'),
    ('door', 'ドア', 'mono'),
    ('bed', 'ベッド', 'mono'),
    ('garden', 'にわ', 'mono'),
    ('bag', 'かばん', 'mono'),
    ('camera', 'カメラ', 'mono'),
    ('notebook', 'ノート', 'mono'),
    ('pen', 'ペン', 'mono'),
    ('picture', 'しゃしん', 'mono'),
    ('dog', 'いぬ', 'riku'),
    ('cat', 'ねこ', 'riku'),
    ('panda', 'パンダ', 'riku'),
    ('mouse', 'ねずみ', 'riku'),
    ('pig', 'ぶた', 'riku'),
    ('cow', 'うし', 'riku'),
    ('horse', 'うま', 'riku'),
    ('tiger', 'トラ', 'riku'),
    ('koala', 'コアラ', 'riku'),
    ('rabbit', 'うさぎ', 'riku'),
    ('monkey', 'さる', 'riku'),
    ('lion', 'ライオン', 'riku'),
    ('elephant', 'ぞう', 'riku'),
    ('bird', 'とり', 'riku'),
    ('fox', 'キリン', 'riku'),
    ('dolphin', 'いるか', 'umi'),
    ('fish', 'さかな', 'umi'),
    ('turtle', 'かめ', 'umi'),
    ('whale', 'くじら', 'umi'),
    ('sea', 'うみ', 'umi'),
    ('starfish', 'ひとで', 'umi'),
    ('jerryfish', 'くらげ', 'umi'),
    ('run', 'はしる', 'koudou'),
    ('walk', 'あるく', 'koudou'),
    ('eat', 'たべる', 'koudou'),
    ('want', 'ほしがる', 'koudou'),
    ('drive', 'うんてんする', 'koudou'),
    ('speak', 'はなす', 'koudou'),
    ('use', 'つかう', 'koudou'),
    ('drink', 'のむ', 'koudou'),
    ('wash', 'あらう', 'koudou'),
    ('work', 'はたらく', 'koudou');
]]

return module
