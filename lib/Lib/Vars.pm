package Lib::Vars;
use utf8;
use Encode;
require Exporter;
@ISA = qw(Exporter);

#########################################################################################################
# НАСТРОЙКИ
#########################################################################################################
our $DB_HOST                   = '127.0.0.1';                 # mysql: server ip
our $DB_PORT                   = '3306';                      # mysql: server port
our $DB_NAME                   = 'parse';                     # mysql: database name
our $DB_USER                   = 'xmolex';                    # mysql: database user
our $DB_PASS                   = 'password';                  # mysql: database password
our $PATH_LOG_DB               = '/usr/home/http/Parse/db.log'; # путь к логу базы данных

our $AGENT_NAME    = 'Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET4.0C)'; # агент
our $AGENT_REFERER = 'http://www.litmir.me'; # сайт с которого якобы пришел агент
our $AGENT_COOKIE  = '/usr/home/http/Parse/cookie.txt'; # файл с cookie

our $COUNT_REPEAT_REQ = 10; # количество повторных запросов ( p=1 .. p=$COUNT_REPEAT_REQ ) 
#########################################################################################################

@EXPORT = qw(
              $DB_HOST
              $DB_PORT
              $DB_NAME
              $DB_USER
              $DB_PASS
              $PATH_LOG_DB
              $AGENT_NAME
              $AGENT_REFERER
              $AGENT_COOKIE
              $COUNT_REPEAT_REQ
              &tr_sql
              &tr_html
              &get_sql_time
              &on_utf8
            );

# получаем SQL команду и экранизируем опасности
sub tr_sql {
  $_[0] =~ s!'!\'!g;
  return($_[0]);
}

# производим замены для принятых значений, которые должны пойти на вывод в html
sub tr_html {
    $_[0] =~ s/&/&amp;/go;
    $_[0] =~ s/</&lt;/go;
    $_[0] =~ s/>/&gt;/go;
    $_[0] =~ s/'/&apos;/go;
    $_[0] =~ s/"/&quot;/go;
    return($_[0]);
}

# формируем дату и время для базы данных, либо только дату (флаг вторым параметром)
sub get_sql_time {
    my $time = shift || time();
    my( $sec, $min, $hour, $mday, $mon, $year ) = localtime($time);
    $year = $year + 1900;
    $mon++;
    if ($_[0]) {
        # запрос только на дату
        return("$year-$mon-$mday");
    }
    else {
        # запрос на дату и время
        return( "$year-$mon-$mday $hour:$min:$sec" );
    }
    
}

# функция выставляет флаг utf8 в on
# передаем ссылку на строку
sub on_utf8 {
    Encode::_utf8_on( ${$_[0]} );
}

1;