################################################################################
# Модуль хранящий функцию для парсинга страницы
# функция вынесена отдельно только для реализации теста 003_attemp_parse_litmir.co.t, т.к. обрабатывается HTML на неподконтрольном ресурсе и функция будет переставать правильно работать при малейших изменениях верстки
################################################################################
package Lib::Parseurl;

use Modern::Perl;
use utf8;
use LWP 5.64;
use HTTP::Cookies;
use Lib::Vars;
use Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(&parseurl);

# инициализация агента с поддержкой cookie
my $browser = LWP::UserAgent->new;
$browser->agent($AGENT_NAME);
my $cookie_jar = HTTP::Cookies->new(file => $AGENT_COOKIE, autosave => 1);

# получаем url, парсим его и отдаем ссылку на массив c полями id,title,poster,rating,page,writer,genres,lang,year,link
sub parseurl {
    # получаем url запроса
    my ($url) = @_;
    
    # инициализация массива для хранения
    my @result;
    
    # получаем код страницы
    my $data = _get_data_from_url($url);
    # указываем явно, что это utf8
    on_utf8(\$data);
      
    # избавляемся от переносов строк
    $data =~ s/\n//g;
      
    # избавляемся от начальных данных, которые нам не нужны
    my $pos = index $data, '<table class="island"';
    if ($pos == -1) {
        # данные не нашлись, выходим
        return(\@result);
    }
    $data = substr $data, $pos;
      
    # парсим страницу, зная, что блок находится в <table class="island" style="max-height:750px;"> ... </table>
    while ( $data =~ s!<table class="island" style="max-height:750px;">(.+?)</table>!! ) {
        my $html_one = $1;
          
        my %data;
          
        #<div class="book_name"><a href="/bd/?b=594831"><span itemprop="name">Штурм дворца Амина: версия военного разведчика</span></a></div>
        # получаем идентификатор и ссылку
        if ( $html_one =~ m!<a href="/bd/\?b=(\d+)"! ) {
            $data{'id'}   = $1;
            $data{'link'} = 'http://www.litmir.me/bd/?b=' . $data{'id'};
        }
        else {
            # если не удалось извлечь, то дальше нет смысла, выходим
            return(\@result);
        }
          
        # получаем наименование
        if ( $html_one =~ m!<span itemprop="name">(.+?)</span>! ) {
            $data{'title'} = $1;
            $data{'title'} =~ s/^\s+//;
            $data{'title'} =~ s/\s+$//;
            on_utf8(\$data{'title'});
        }
        else {
            # если не удалось извлечь, то дальше также нет смысла, выходим
            return(\@result);
        }
          
        # получаем постер
        # <img jq="BookCover" class="lt32 lazy" width="250" height="345" alt="Штурм дворца Амина: версия военного разведчика" src="/img/blank.gif" data-src="/data/Book/0/594000/594831/BC4_1508849297.jpg">
        if ( $html_one =~ m!<img jq="BookCover".+?data-src="(.+?)">! ) {
            $data{'poster'} = 'http://www.litmir.me/' . $1;
            $data{'poster'} =~ s/^\s+//;
            $data{'poster'} =~ s/\s+$//;
        }
        else {
            $data{'poster'} = '';
        }
          
        # получаем рейтинг
        # <img class="lazy" src="/img/star.png" alt="Оценка" style="margin-bottom: -1px; display: inline;">&nbsp;&nbsp;&nbsp;<span class="orange_desc">1</span>
        # <img class="lazy" src="/img/star.png" alt="Оценка" style="margin-bottom: -1px; display: inline;">&nbsp;&nbsp;&nbsp;<span class="orange_desc">9.55</span>
        if ( $html_one =~ m!&nbsp;&nbsp;&nbsp;<span class="orange_desc">([\d\.]+)</span>! ) {
            $data{'rating'} = $1;
        }
        else {
            $data{'rating'} = 0;
        }
          
        # получаем автора
        # <span itemprop="author" itemscope="" itemtype="http://schema.org/Person" class="desc2"> <meta itemprop="name" content="Кошелев Владимир Алексеевич"><a href="/a/?id=32559">Кошелев Владимир Алексеевич</a></span>
        if ( $html_one =~ m!<meta itemprop="name" content="(.+?)">! ) {
            $data{'writer'} = $1;
            $data{'writer'} =~ s/^\s+//;
            $data{'writer'} =~ s/\s+$//;
            on_utf8(\$data{'writer'});
        }
        else {
            $data{'writer'} = '';
        }
          
        # <span class="desc1">Язык книги:</span><span class="desc2"> Русский</span><span class="desc1">Страниц:</span><span class="desc2"> 125 </span></div>
        # получаем язык
        if ( $html_one =~ m!<span class="desc1">Язык книги:</span><span class="desc2">(.+?)</span>! ) {
            $data{'lang'} = $1;
            $data{'lang'} =~ s/^\s+//;
            $data{'lang'} =~ s/\s+$//;
            on_utf8(\$data{'lang'});
        }
        else {
            $data{'lang'} = '';
        }
          
        # получаем количество страниц
        if ( $html_one =~ m!<span class="desc1">Страниц:</span><span class="desc2">(.+?)</span>! ) {
            $data{'pages'} = $1;
            $data{'pages'} =~ s/^\s+//;
            $data{'pages'} =~ s/\s+$//;
        }
        else {
            $data{'pages'} = 0;
        }
          
        # получаем год
        # <a href="/bs/?year_after=2007&amp;year_before=2007">2007</a>
        if ( $html_one =~ m!<a href="/bs/\?year.+?>(\d+)</a>! ) {
            $data{'year'} = $1;
        }
        else {
            $data{'year'} = 0;
        }
          
        # получаем жанры
        # <span itemprop="genre" class="desc2"> <a href="/bs/?g=sg273&amp;hc=1&amp;rs=5%7C1%7C0">Спецслужбы</a>, <a href="/bs/?g=sg52&amp;hc=1&amp;rs=5%7C1%7C0">Биографии и мемуары</a>, <a id="genres_more60" href="" onclick="$(this).hide();$('#genres_rest60').show();return false;">...</a><span id="genres_rest60" style="display:none"><a href="/bs/?g=sg60&amp;hc=1&amp;rs=5%7C1%7C0">Военная проза</a></span></span>
        if ( $html_one =~ m!<span itemprop="genre"(.+?)</span>! ) {
            my $tmp = $1;
            while ( $tmp =~ s!<a href="/bs/\?g=sg.+?>(.+?)</a>!! ) {
                $data{'genres'} .= $1 . ',';
            }
            # удаляем лишнюю запятую
            $data{'genres'} =~ s/,$//;
              
            $data{'genres'} =~ s/^\s+//;
            $data{'genres'} =~ s/\s+$//;
            on_utf8(\$data{'genres'});
        }
        else {
            $data{'genres'} = '';
        }
        
        # заносим данные в массив данных
        push @result, $data{'id'};
        push @result, $data{'title'};
        push @result, $data{'poster'};
        push @result, $data{'rating'};
        push @result, $data{'pages'};
        push @result, $data{'writer'};
        push @result, $data{'genres'};
        push @result, $data{'lang'};
        push @result, $data{'year'};
        push @result, $data{'link'};

    }
    
    # отдаем данные
    return(\@result);

}

# получаем url и возвращаем html
sub _get_data_from_url {
    my ($url) = @_;
    $browser->cookie_jar($cookie_jar);
    my $req = HTTP::Request->new( GET => $url );
    $req->header( Accept => "text/html, */*;q=0.1", referer => $AGENT_REFERER );
    my $response = $browser->request($req);
    my $data = $response->decoded_content;
    return $data;
}

1;
