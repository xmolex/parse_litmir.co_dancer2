use strict;
use utf8;
use warnings;
use lib "lib/";
use Test::Spec;
use Lib::Parseurl;

###################################################################################
#  SETTINGS
###################################################################################
my $url = 'http://www.litmir.co/bs?year_after=&year_before=&PagesCountMin=&PagesCountMax=&publish_city=&name=&genre=273&ExcludeGenresIds=0&lang=RU&src_lang=&kw=&rs=0&order=OnShow.Down&hc=on&p=1';
###################################################################################

my ($id, $title, $poster, $rating, $page, $writer, $genres, $lang, $year, $link);

# получаем данные с $url
my $data = parseurl($url);

# проходимся по всем данным и пытаемся собрать данные всех типов для сравнения
for ( my $i = 0; $i < scalar(@$data); $i = $i + 10 ) {
    if (!$id     && $$data[$i])   {$id     = $$data[$i];}
    if (!$title  && $$data[$i+1]) {$title  = $$data[$i+1];}
    if (!$poster && $$data[$i+2]) {$poster = $$data[$i+2];}
    if (!$rating && $$data[$i+3]) {$rating = $$data[$i+3];}
    if (!$page   && $$data[$i+4]) {$page   = $$data[$i+4];}
    if (!$writer && $$data[$i+5]) {$writer = $$data[$i+5];}
    if (!$genres && $$data[$i+6]) {$genres = $$data[$i+6];}
    if (!$lang   && $$data[$i+7]) {$lang   = $$data[$i+7];}
    if (!$year   && $$data[$i+8]) {$year   = $$data[$i+8];}
    if (!$link   && $$data[$i+9]) {$link   = $$data[$i+9];}
}

# проводим тест
describe "Parseurl" => sub {
    describe "got" => sub {
        it "ID" => sub {
            is _is_numeric($id), 1;
        };
        it "TITLE" => sub {
            is _is_string($title), 1;
        };
        it "POSTER" => sub {
            is _is_string($poster), 1;
        };
        # т.к. очень часто рейтинг пустой, то отключим его
        # it "RATING" => sub {
        #     is _is_numeric_include_real($rating), 1;
        # };
        it "PAGE" => sub {
            is _is_numeric($page), 1;
        };
        it "WRITER" => sub {
            is _is_string($writer), 1;
        };
        it "GENRES" => sub {
            is _is_string($genres), 1;
        };
        it "LANG" => sub {
            is _is_string($lang), 1;
        };
        it "YEAR" => sub {
            is _is_numeric($year), 1;
        };
        it "LINK" => sub {
            is _is_string($link), 1;
        };
    };
};

runtests unless caller;

sub _is_numeric {
    return 0 unless defined($_[0]);
    return 1 if $_[0] =~ m/^\d+$/;
    return 0;
}

sub _is_numeric_include_real {
    return 0 unless defined($_[0]);
    return 1 if $_[0] =~ m/^\d+$/;
    return 1 if $_[0] =~ m/^\d+\.\d+$/;
    return 0;
}

sub _is_string {
    return 0 unless defined($_[0]);
    return 1 if $_[0] =~ m/\w+/;
    return 0;
}


