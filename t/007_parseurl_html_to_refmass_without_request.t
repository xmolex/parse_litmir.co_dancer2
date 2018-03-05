# тест функции parseurl в модуле Lib::Parseurl
# отдаем url, возвращает ссылку на массив с данными id,title,poster,rating,page,writer,genres,lang,year,link

use strict;
use utf8;
use Modern::Perl;
use Test::Spec;
use Lib::Parseurl;

# получаем наш шаблон со страницей заглушкой
my $html = tmpl();

# проводим тест
describe "Parseurl" => sub {
    describe "got" => sub {
        # получаем данные эмуляцией
        Lib::Parseurl->expects('_get_data_from_url')->returns($html)->once;
        
        # парсим страницу
        my $data = parseurl();
        
        # проводим тест
        it "ID" => sub {
            is $$data[0], '602889';
        };
        it "TITLE" => sub {
            is $$data[1], 'Ким и Булат';
        };
        it "POSTER" => sub {
            is $$data[2], 'http://www.litmir.me//data/Book/0/602000/602889/BC4_1515758295.jpg';
        };
        it "RATING" => sub {
            is $$data[3], '10';
        };
        it "PAGE" => sub {
            is $$data[4], '12';
        };
        it "WRITER" => sub {
            like $$data[5], qr/\w+/i;
        };
        it "GENRES" => sub {
            is $$data[6], 'Слеш,Историческое фэнтези';
        };
        it "LANG" => sub {
            is $$data[7], 'Русский';
        };
        it "YEAR" => sub {
            is $$data[8], '2004';
        };
        it "LINK" => sub {
            is $$data[9], 'http://www.litmir.me/bd/?b=602889';
        };
    };
};

runtests unless caller;

#########################################################################
# шаблон html
#########################################################################
sub tmpl {
    return q|
<!DOCTYPE html>
<table class="lts49"><tr><td><div jq="PlaceLoad"><div jq=""></div><div jq="BookList">
<table class="island" style="max-height:750px;"><tr><td class="lt22"><a href="/bd/?b=602889"><img jq="BookCover" class="lt32 lazy" width="250" height="375" alt="Ким и Булат" src="/img/blank.gif" data-src="/data/Book/0/602000/602889/BC4_1515758295.jpg"></a></td><td class="item"><div itemscope="" itemtype="http://schema.org/Book"><div class="book_name"><a href="/bd/?b=602889"><span itemprop="name">Ким и Булат</span></a></div><div class="description"><div style="float:left;"><img class="lazy" src="/img/blank.gif" data-src="/img/star.png" alt="Оценка" style="margin-bottom: -1px;">&nbsp;&nbsp;&nbsp;<span class="orange_desc">10</span>&nbsp;(1) <span style="color:#cc33ff;background-color: #fff;">1</span></div><div style="float:right;"><span class="desc1">Добавила:</span> <a class="lt98_2" href="/p/?u=601798"><span class="lt99">Мафдет</span></a> <span class="desc3">12&nbsp;января&nbsp;2018,&nbsp;14:58</span></div><div class="desc_container"><div class="desc_box"><span class="desc1">Автор:</span><span itemprop="author" itemscope itemtype="http://schema.org/Person" class="desc2"> <meta itemprop="name" content="Тенже"><a href="/a/?id=99748">Тенже</a></span></div><div class="desc_box"><span class="desc1">Жанр:</span><span itemprop="genre" class="desc2"> <a href="/bs/?g=sg276&hc=1&rs=5%7C1%7C0">Слеш</a>, <a href="/bs/?g=sg162&hc=1&rs=5%7C1%7C0">Историческое фэнтези</a></span></div><div class="desc_box"><span class="desc1">Год:</span><span class="desc2"> <a href="/bs/?year_after=2004&amp;year_before=2004">2004</a></span><span class="desc1">Язык книги:</span><span class="desc2"> Русский</span><span class="desc1">Страниц:</span><span class="desc2"> 12 </span></div><div class="desc_box"><span class="desc1" style="color:#32ae17;">Книга закончена</span></div></div></div><div class="lt25"><div style="float:left;"><div style="width:180px; padding-top: 10px; margin-bottom: 13px;"><a class="read" jq="needEmail" href="/br/?b=602889">Читать</a></div><div style="padding-top:13px; margin-bottom: 13px;"><div>&nbsp;&nbsp;&nbsp;<img class="lazy" src="/img/blank.gif" data-src="/img/bubble.png">&nbsp;&nbsp;&nbsp;<span class="desc4"><div id="jq-dropdown-book2_602889" class="jq-dropdown jq-dropdown-tip jq-dropdown-relative"><ul class="jq-dropdown-menu" style="padding:10px;"><div><div style="text-align:justify;"><b>Яроминка</b> <i>13&nbsp;января&nbsp;2018,&nbsp;22:24</i><br> <i>оценила книгу на 10</i><br /><br /><div style="text-indent:25px;"><div class="BBHtmlCode"><div class="BBHtmlCodeInner"><span itemprop="reviewBody">
Очень необычный сюжет, мне очень понравилось. Честно заработанная 10-ка!
</span></div></div></div><br /></div><a href="/bd/?b=602889#Comments" class="lt99" style="color:#16BAFF">Перейти к комментариям</a></div></ul></div><a data-jq-dropdown="#jq-dropdown-book2_602889" style="border-bottom: 1px solid #e4e4e4;"><span style="cursor: pointer;color:#333;font-size:13px;font-size:1.3rem;">Комментарии</span></a></span>&nbsp;&nbsp;<span class="orange_desc">(<span itemprop="commentCount">1</span>)</span></div></div></div><div style="float:left;"><div style="margin-bottom: 13px;"><div class="desc_box2"><span class="desc1">Формат:</span><div id="download602889" class="download"><div style="float:left;"><input id="radio6028891" type="radio" name="format602889" value="/BookFileDownloadLink/?id=842104" checked><label for="radio6028891">txt</label></div><div style="float:left;"><input id="radio6028892" type="radio" name="format602889" value="/BookFileDownloadLink/?id=842103"><label for="radio6028892">fb2</label></div></div></div></div><div style="padding-top:26px; margin-bottom: 13px;"><img class="lazy" src="/img/blank.gif" data-src="/img/download.png">&nbsp;&nbsp;&nbsp;<a class="lt99" style="color:#16BAFF" href="" onclick="location.href=$('#download602889 input[type=radio]:checked').val();return false;">Скачать</a></div></div></div></td></tr><tr><td colspan="2" style="padding:10px;"><div class="item_description"><div class="lt37"><div itemprop="description" class="description"><div class="BBHtmlCode"><div class="BBHtmlCodeInner"><p> Так бы и состарился Ким в областном центре, совершая ежедневную ходку в архив, раз в неделю вытаскивая на свет божий зеркальные грешки местных партийцев и вояк, да вмешалась Олимпиада-80. В столицу со всех концов страны согнали кукловодов, псиоников, гипнотизеров, с... <a style="color:#16BAFF;" class="blue_desc2" href="/bd/?b=602889">Полное описание</a></div></div></div></div><div class="desc_box" style="margin-top:16px;"><span class="desc1" style="vertical-align:3px">Поделиться:&nbsp;&nbsp;&nbsp;</span><span><span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=facebook&objtype=1&objid=602889" title="Facebook" rel="nofollow" onclick="var count = $('#facebook1602889').html();count++;$('#facebook1602889').html(count);return true;" target="_blank"><img class="lazy" alt="Facebook" src="/img/blank.gif" data-src="/img/sharelink/facebook.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=facebook1602889>1</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;<span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=twitter&objtype=1&objid=602889" title="Twitter" rel="nofollow" onclick="var count = $('#twitter1602889').html();count++;$('#twitter1602889').html(count);return true;" target="_blank"><img class="lazy" alt="Twitter" src="/img/blank.gif" data-src="/img/sharelink/twitter.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=twitter1602889>1</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;<span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=vkontakte&objtype=1&objid=602889" title="В контакте" rel="nofollow" onclick="var count = $('#vkontakte1602889').html();count++;$('#vkontakte1602889').html(count);return true;" target="_blank"><img class="lazy" alt="В контакте" src="/img/blank.gif" data-src="/img/sharelink/vkontakte.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=vkontakte1602889>1</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;<span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=livejournal&objtype=1&objid=602889" title="Livejournal" rel="nofollow" onclick="var count = $('#livejournal1602889').html();count++;$('#livejournal1602889').html(count);return true;" target="_blank"><img class="lazy" alt="Livejournal" src="/img/blank.gif" data-src="/img/sharelink/livejournal.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=livejournal1602889>2</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;<span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=mail&objtype=1&objid=602889" title="Мой мир" rel="nofollow" onclick="var count = $('#mail1602889').html();count++;$('#mail1602889').html(count);return true;" target="_blank"><img class="lazy" alt="Мой мир" src="/img/blank.gif" data-src="/img/sharelink/mail.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=mail1602889>1</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;<span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=googleplus&objtype=1&objid=602889" title="Google+" rel="nofollow" onclick="var count = $('#googleplus1602889').html();count++;$('#googleplus1602889').html(count);return true;" target="_blank"><img class="lazy" alt="Google+" src="/img/blank.gif" data-src="/img/sharelink/googleplus.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=googleplus1602889>1</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;<span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=gmail&objtype=1&objid=602889" title="Gmail" rel="nofollow" onclick="var count = $('#gmail1602889').html();count++;$('#gmail1602889').html(count);return true;" target="_blank"><img class="lazy" alt="Gmail" src="/img/blank.gif" data-src="/img/sharelink/gmail.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=gmail1602889>1</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;<a href="" onclick="var html = '<div class=\'xs_er\'>Чтобы продолжить действие вы должны быть зарегистрированны. Пожалуйста, <a href=\'/SendInvite\'>зарегистрируйтесь</a> или зайдите на сайт под своим именем</div>';xsMessage(html);return false;" title="Email"><img class="lazy" alt="Email" src="/img/blank.gif" data-src="/img/sharelink/email.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=email1602889>0</span></span>&nbsp;&nbsp;<span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=download&objtype=1&objid=602889" title="Скачать" rel="nofollow" onclick="var count = $('#download1602889').html();count++;$('#download1602889').html(count);return true;"><img class="lazy" alt="Скачать" src="/img/blank.gif" data-src="/img/sharelink/download.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=download1602889>1</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;</span></div></div></div></td></tr></table><div style="display:none;" jq="GetParam">{"o":null}</div>
<table class="island" style="max-height:750px;"><tr><td class="lt22"><a href="/bd/?b=602772"><img jq="BookCover" class="lt32 lazy" width="250" height="188" alt="Цена свободы" src="/img/blank.gif" data-src="/data/Book/0/602000/602772/BC4_1515663154.jpg"></a></td><td class="item"><div itemscope="" itemtype="http://schema.org/Book"><div class="book_name"><a href="/bd/?b=602772"><span itemprop="name">Цена свободы</span></a></div><div class="description"><div style="float:left;"></div><div style="float:right;"><span class="desc1">Добавила:</span> <a class="lt98" href="/p/?u=715958"><span class="lt99">Proba Pera</span></a> <span class="desc3">11&nbsp;января&nbsp;2018,&nbsp;12:32</span></div><div class="desc_container"><div class="desc_box"><span class="desc1">Автор:</span><span itemprop="author" itemscope itemtype="http://schema.org/Person" class="desc2"> <meta itemprop="name" content="Pera Proba (?)"><a href="/a/?id=288556">Pera Proba</a> (?)</span></div><div class="desc_box"><span class="desc1">Жанр:</span><span itemprop="genre" class="desc2"> <a href="/bs/?g=sg44&hc=1&rs=5%7C1%7C0">Прочая старинная литература</a>, <a href="/bs/?g=sg99&hc=1&rs=5%7C1%7C0">Исторические любовные романы</a>, <a id="genres_more276" href="" onclick="$(this).hide();$('#genres_rest276').show();return false;">...</a><span id="genres_rest276" style="display:none"><a href="/bs/?g=sg276&hc=1&rs=5%7C1%7C0">Слеш</a>, <a href="/bs/?g=sg244&hc=1&rs=5%7C1%7C0">Фанфик</a></span></span></div><div class="desc_box"><span class="desc1">Язык книги:</span><span class="desc2"> Русский</span><span class="desc1">Страниц:</span><span class="desc2"> 26 </span></div><div class="desc_box"><span class="desc1" style="color:#32ae17;">Книга закончена</span></div></div></div><div class="lt25"><div style="float:left;"><div style="width:180px; padding-top: 10px; margin-bottom: 13px;"><a class="read" jq="needEmail" href="/br/?b=602772">Читать</a></div><div style="padding-top:13px; margin-bottom: 13px;"></div></div><div style="float:left;"><div style="margin-bottom: 13px;"><div class="desc_box2"><span class="desc1">Формат:</span><div id="download602772" class="download"><div style="float:left;"><input id="radio6027721" type="radio" name="format602772" value="/BookFileDownloadLink/?id=841751" checked><label for="radio6027721">fb2</label></div></div></div></div><div style="padding-top:26px; margin-bottom: 13px;"><img class="lazy" src="/img/blank.gif" data-src="/img/download.png">&nbsp;&nbsp;&nbsp;<a class="lt99" style="color:#16BAFF" href="" onclick="location.href=$('#download602772 input[type=radio]:checked').val();return false;">Скачать</a></div></div></div></td></tr><tr><td colspan="2" style="padding:10px;"><div class="item_description"><div class="lt37"><div itemprop="description" class="description"><div class="BBHtmlCode"><div class="BBHtmlCodeInner">Отношения между двумя юношами в крестьянской России	- Мефодий, это же я, Ланской! Ты что, не узнаешь меня?! Мы же с тобой в Санкт-Петербуржском пансионе вместе учились!	- Обознались, видать, барин, - не глядя тому в глаза процедил Трегубов, - я кузнец да конюх местный.	 </div></div></div></div><div class="desc_box" style="margin-top:16px;"><span class="desc1" style="vertical-align:3px">Поделиться:&nbsp;&nbsp;&nbsp;</span><span><span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=facebook&objtype=1&objid=602772" title="Facebook" rel="nofollow" onclick="var count = $('#facebook1602772').html();count++;$('#facebook1602772').html(count);return true;" target="_blank"><img class="lazy" alt="Facebook" src="/img/blank.gif" data-src="/img/sharelink/facebook.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=facebook1602772>0</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;<span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=twitter&objtype=1&objid=602772" title="Twitter" rel="nofollow" onclick="var count = $('#twitter1602772').html();count++;$('#twitter1602772').html(count);return true;" target="_blank"><img class="lazy" alt="Twitter" src="/img/blank.gif" data-src="/img/sharelink/twitter.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=twitter1602772>0</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;<span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=vkontakte&objtype=1&objid=602772" title="В контакте" rel="nofollow" onclick="var count = $('#vkontakte1602772').html();count++;$('#vkontakte1602772').html(count);return true;" target="_blank"><img class="lazy" alt="В контакте" src="/img/blank.gif" data-src="/img/sharelink/vkontakte.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=vkontakte1602772>0</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;<span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=livejournal&objtype=1&objid=602772" title="Livejournal" rel="nofollow" onclick="var count = $('#livejournal1602772').html();count++;$('#livejournal1602772').html(count);return true;" target="_blank"><img class="lazy" alt="Livejournal" src="/img/blank.gif" data-src="/img/sharelink/livejournal.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=livejournal1602772>0</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;<span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=mail&objtype=1&objid=602772" title="Мой мир" rel="nofollow" onclick="var count = $('#mail1602772').html();count++;$('#mail1602772').html(count);return true;" target="_blank"><img class="lazy" alt="Мой мир" src="/img/blank.gif" data-src="/img/sharelink/mail.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=mail1602772>0</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;<span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=googleplus&objtype=1&objid=602772" title="Google+" rel="nofollow" onclick="var count = $('#googleplus1602772').html();count++;$('#googleplus1602772').html(count);return true;" target="_blank"><img class="lazy" alt="Google+" src="/img/blank.gif" data-src="/img/sharelink/googleplus.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=googleplus1602772>0</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;<span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=gmail&objtype=1&objid=602772" title="Gmail" rel="nofollow" onclick="var count = $('#gmail1602772').html();count++;$('#gmail1602772').html(count);return true;" target="_blank"><img class="lazy" alt="Gmail" src="/img/blank.gif" data-src="/img/sharelink/gmail.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=gmail1602772>0</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;<a href="" onclick="var html = '<div class=\'xs_er\'>Чтобы продолжить действие вы должны быть зарегистрированны. Пожалуйста, <a href=\'/SendInvite\'>зарегистрируйтесь</a> или зайдите на сайт под своим именем</div>';xsMessage(html);return false;" title="Email"><img class="lazy" alt="Email" src="/img/blank.gif" data-src="/img/sharelink/email.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=email1602772>0</span></span>&nbsp;&nbsp;<span class="hide"><![CDATA[<noindex>]]></span><a href="/ShareLink/?key=download&objtype=1&objid=602772" title="Скачать" rel="nofollow" onclick="var count = $('#download1602772').html();count++;$('#download1602772').html(count);return true;"><img class="lazy" alt="Скачать" src="/img/blank.gif" data-src="/img/sharelink/download.png"></a><span style="vertical-align:3px;">&nbsp;:<span id=download1602772>0</span></span><span class="hide"><![CDATA[</noindex>]]></span>&nbsp;&nbsp;</span></div></div></div></td></tr></table><div style="display:none;" jq="GetParam">{"o":null}</div></div><div class="lt118"><table class="lt117" jq="go_to_page" Ajax=""><tr><td class="lt119"><form action="/bs?lang=RU&genre=276&hc=on&order=OnShow.Down" method="get"><input type="hidden" name="lang" value="RU"><input type="hidden" name="genre" value="276"><input type="hidden" name="hc" value="on"><input type="hidden" name="order" value="OnShow.Down"><input class="lt40" name="p" type="text" value="1"><input class="lt41" type="submit" value="OK"></form></td><td style="padding-right: 10px"></div><a class="ps" page="1"><div>1</div></a><a class="p" page="2" href="/bs?lang=RU&genre=276&hc=on&order=OnShow.Down&p=2"><div>2</div></a><a class="p" page="3" href="/bs?lang=RU&genre=276&hc=on&order=OnShow.Down&p=3"><div>3</div></a><a class="p"><div>...</div></a><a class="p" page="128" href="/bs?lang=RU&genre=276&hc=on&order=OnShow.Down&p=128"><div>128</div></a></div></td><td class="lt103"><form action="/bs?lang=RU&genre=276&hc=on&order=OnShow.Down" method="get"><input type="hidden" name="year_after" value=""><input type="hidden" name="year_before" value=""><input type="hidden" name="PagesCountMin" value=""><input type="hidden" name="PagesCountMax" value=""><input type="hidden" name="publish_city" value=""><input type="hidden" name="name" value=""><input type="hidden" name="genre" value="276"><input type="hidden" name="ExcludeGenresIds" value="0"><input type="hidden" name="lang" value="RU"><input type="hidden" name="src_lang" value=""><input type="hidden" name="kw" value=""><input type="hidden" name="rs" value="0"><input type="hidden" name="order" value="OnShow.Down"><input type="hidden" name="hc" value="on"><input type="hidden" name="p" value="1"><span style="font-size:18px; font-size:1.8rem;">На странице</span> <input name="o" class="lt40" type="text" value="25"><input class="lt41" type="submit" value="OK"></form></td></tr></table></div></div></td></tr></table><div style="display:none;" jq="GetParam">{"lang":"RU","genre":"276","hc":"on","order":"OnShow.Down","o":25}</div></div></td></tr></table></div></td></tr><tr><td><div class="lt20"></div></td></tr></table><div class="container" style="min-height:200px;"><div style="height:190px;"><div class="widget_tab" style="background:transparent;padding-bottom:0;text-align:left;padding-left:20px;"><span><span style="color:#000; font-size:14px;font-size:1.4rem;font-family:Roboto;">Лит</span><span style="color:#f05a29; font-size:14px;font-size:1.4rem;font-family:Roboto;">Рес</span></span><span style="color:#444;font-size:12px;font-size:1.2rem;font-family:Roboto;"> представляет: бестселлеры месяца</span></div><div class="art_main"><div class="art_td_c"><a href="https://www.litres.ru/n-a-budyanskaya/moy-neluchshiy-drug/?lfrom=241867185" target="_blank"><img class="art_c" height="165" border="0" style="min-height:165px;" alt="Мой нелучший друг" src="/data/Book/0/595000/595242/BC5_1509118442.jpg"></a></div><div class="art_td_c"><a href="https://www.litres.ru/tatyana-kozhevnikova-12503191/hr-kak-on-est/?lfrom=241867185" target="_blank"><img class="art_c" height="165" border="0" style="min-height:165px;" alt="HR как он есть" src="/data/Book/0/594000/594582/BC5_1508545817.jpg"></a></div><div class="art_td_c"><a href="https://www.litres.ru/dzhon-grishem/verdikt-25665558/?lfrom=241867185" target="_blank"><img class="art_c" height="165" border="0" style="min-height:165px;" alt="Вердикт" src="/data/Book/0/590000/590466/BC5_1505241023.jpg"></a></div><div class="art_td_c"><a href="https://www.litres.ru/persson-dzhiolito-malin/zybuchie-peski/?lfrom=241867185" target="_blank"><img class="art_c" height="165" border="0" style="min-height:165px;" alt="Зыбучие пески" src="/data/Book/0/593000/593242/BC5_1507552504.jpg"></a></div><div class="art_td_c"><a href="https://www.litres.ru/dmitriy-vidineev-9877872/zanaves-upal/?lfrom=241867185" target="_blank"><img class="art_c" height="165" border="0" style="min-height:165px;" alt="Занавес упал" src="/data/Book/0/592000/592996/BC5_1507293218.jpg"></a></div><div class="art_td_c"><a href="https://www.litres.ru/vanessa-van-edvards/nauka-obscheniya/?lfrom=241867185" target="_blank"><img class="art_c" height="165" border="0" style="min-height:165px;" alt="Наука общения. Как читать эмоции, понимать намерения и находить общий язык с людьми" src="/data/Book/0/599000/599036/BC5_1512045400.jpg"></a></div><div class="art_td_c"><a href="https://www.litres.ru/pavel-agalakov/shou-obrechennyh/?lfrom=241867185" target="_blank"><img class="art_c" height="165" border="0" style="min-height:165px;" alt="Шоу обреченных" src="/data/Book/0/590000/590155/BC5_1504960368.jpg"></a></div><div class="art_td_c"><a href="https://www.litres.ru/uriy-luzhkov/moskva-i-zhizn/?lfrom=241867185" target="_blank"><img class="art_c" height="165" border="0" style="min-height:165px;" alt="Москва и жизнь" src="/data/Book/0/598000/598148/BC5_1511537726.jpg"></a></div><div class="art_td_c"><a href="https://www.litres.ru/ellina-naumova/vse-nachalos-kogda-on-umer/?lfrom=241867185" target="_blank"><img class="art_c" height="165" border="0" style="min-height:165px;" alt="Всё началось, когда он умер" src="/data/Book/0/590000/590394/BC5_1505208755.jpg"></a></div></div></div><div style="height:35px;"></div></div><div class="lt8a"><div class="container"> <div style="border: 0px;">
</body>
</html>|;
}