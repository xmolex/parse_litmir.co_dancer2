package Parse;
use Dancer2;
use Modern::Perl;
use utf8;
use Lib::Vars;
use Lib::Db;
use Lib::Parseurl;

my $count_of_page = 10; # количество объектов на одной странице при выводе у нас

our $VERSION = '0.1';

# индексная страница
get '/' => sub {
    template 'index' => { 'title' => 'cat' };
};

# форма запроса url для парсинга
get '/parse' => sub {
    template 'parse' => { 'title' => 'Parse', 'url' => '' };
};

# запрос на удаление объекта в базе
post '/delete' => sub {
    # получаем идентификатор и проверяем его
    my $id = body_parameters->get('id');
    if ($id !~ m/^\d+$/) {
        return('wrong id');
    }
    
    # удаляем
    if ($id) {
        sql("DELETE FROM data WHERE id='$id';");
    }
    
    return();
};

# отдаем некоторое количество объектов в json для индексной страницы
# через post отдаем json для ajax, через get отдаем json в файл 
any '/getcat' => sub {
    my @result;

    # получаем страницу
    my $page = body_parameters->get('page') || 1;
    if ($page !~ m/^\d+$/) {$page = 1;}
    if ($page < 1) {$page = 1;}
    
    # получаем флаг вывода через файл полной базы
    my $file = query_parameters->get('file');
    
    # расчитываем смещение
    my $offset = ($page - 1) * $count_of_page;
    
    # запрос для отдачи постранично данных из базы
    my $sql = "SELECT id,title,poster,rating,page,writer,genres,lang,year,link FROM data ORDER BY id LIMIT $count_of_page OFFSET $offset;";
    
    if ($file) {
        # нужно отдать всю базу
        $sql = "SELECT id,title,poster,rating,page,writer,genres,lang,year,link FROM data ORDER BY id;";
    }
    
    # делаем запрос и создаем нужную нам структуру
    # разумеется, самый простой вариант через fetchrow_hashref, типа нижеуказанного кода, однако я оставил ручное указание ключей, чтобы с легкостью их изменить, если потребует frontend
    # my $conn = get_sql_object();
    # if (!$conn) {return("[]");}
    # my $strin = $conn->prepare("SELECT id,title,poster,rating,page,writer,genres,lang,year,link FROM data ORDER BY id;");
    # $strin->execute;
    # while (my $hash = $strin->fetchrow_hashref) {
    #    push @result, $hash;
    # }
    
    $sql = sql($sql);
    if ($$sql[0]) {
        for ( my $i = 0; $i < scalar(@$sql); $i = $i + 10) {
            my %data = (
                         'id'     => $$sql[$i],
                         'title'  => $$sql[$i+1],
                         'poster' => $$sql[$i+2],
                         'rating' => $$sql[$i+3] || '',
                         'page'   => $$sql[$i+4] || '',
                         'writer' => $$sql[$i+5],
                         'genres' => $$sql[$i+6],
                         'lang'   => $$sql[$i+7],
                         'year'   => $$sql[$i+8] || '',
                         'link'   => $$sql[$i+9]
            );
        
            push @result, \%data;
        }
    }
    
    # переводим структуру в json и указываем, что это utf8
    my $data = to_json \@result;
    on_utf8(\$data);
    
    # если отдаем файл, то нужны правильные заголовки
    if ($file) {
        # отдаем нужные заголовки
        response_header 'Accept-Ranges' => 'bytes';
        response_header 'Content-Disposition' => 'attachment; filename="file.js"';
        response_header 'Accept-Charset' => 'utf-8';
    }
    
    # отдаем json
    return($data);
};

# парсим
post '/parse' => sub {
    #response_header 'Content-Type' => 'application/json; charset=utf-8';
    
    my %result;
    
    my $url = body_parameters->get('url');
    
    if ($url !~ m!^http://www.litmir.co!) {
        $result{'error'} = 'введите верный url адрес';
        return to_json \%result;
    }
    
    my $count_object = 0; # счетчик добавленных
    
    my $browser = LWP::UserAgent->new;
    $browser->agent($AGENT_NAME);
    my $cookie_jar = HTTP::Cookies->new(file => $AGENT_COOKIE, autosave => 1);
    
    # делаем запросы по страницам, подставляя номер страницы в запрос
    for ( my $i = 1; $i < $COUNT_REPEAT_REQ + 1; $i++ ) {
        
        # получаем массив с данными id,title,poster,rating,page,writer,genres,lang,year,link
        my $data = parseurl( $url . "&p=$i" );
        
        # проходимся по массиву и заносим данные в базу
        for (my $j = 0; $j < scalar(@$data); $j = $j + 10 ) {
        
            # замещаем спецтеги в текстовых полях перед добавлением
            $$data[$j+1] = tr_html $$data[$j+1]; # title
            $$data[$j+2] = tr_html $$data[$j+2]; # poster
            $$data[$j+5] = tr_html $$data[$j+5]; # writer
            $$data[$j+6] = tr_html $$data[$j+6]; # genres
            $$data[$j+7] = tr_html $$data[$j+7]; # lang
          
            # экранируем тектовые поля от sql'inj
            $$data[$j+1] = tr_sql $$data[$j+1]; # title
            $$data[$j+2] = tr_sql $$data[$j+2]; # poster
            $$data[$j+5] = tr_sql $$data[$j+5]; # writer
            $$data[$j+6] = tr_sql $$data[$j+6]; # genres
            $$data[$j+7] = tr_sql $$data[$j+7]; # lang
            
            # удаляем из базы запись, если имеется
            sql( "DELETE FROM `data` WHERE id='$$data[$j]';", 1 );
            
            # добавляем в базу
            # я знаю, что предпочтительнее использовать placeholders, однако здесь я сознательно не стал этого делать, т.к.
            # 1) данный скрипт расчитан на администратора
            # 2) удобно сразу заметить ошибки парсинга, т.к. они сразу попадут в удобный лог
            if ( sql( qq|INSERT INTO data 
                           (`id`,`title`,`poster`,`rating`,`page`,`writer`,`genres`,`lang`,`year`,`link`)
                         VALUES 
                           ('$$data[$j]','$$data[$j+1]','$$data[$j+2]','$$data[$j+3]','$$data[$j+4]','$$data[$j+5]','$$data[$j+6]','$$data[$j+7]','$$data[$j+8]','$$data[$j+9]');
                        |, 1 ) ) {
                # успешно добавлено
                $count_object++;
            }
        }

    }
    
    $result{'result'} = "Find $count_object objects";
    return to_json \%result;
};



true;
