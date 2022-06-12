<?php

$memcache = new Memcache;
$memcache->connect('memcached', 11211) or die ("接続できませんでした");

$version = $memcache->getVersion();
echo "サーバーのバージョン: ".$version."<br/>\n";

$tmp_object = new stdClass;
$tmp_object->str_attr = 'test';
$tmp_object->int_attr = 123;

$memcache->set('key', $tmp_object, false, 10) or die ("データをサーバーに保存できませんでした");
echo "データをキャッシュに保存します (データの有効期限は 10 秒です)<br/>\n";

$get_result = $memcache->get('key');
echo "キャッシュから取得したデータ:<br/>\n";

var_dump($get_result);

?>
