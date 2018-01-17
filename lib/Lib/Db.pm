################################################################################
# Модуль работы с базой данных
################################################################################
package Lib::Db;

use Modern::Perl;
use utf8;
use DBI;
use Lib::Vars;
use Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(&sql &get_sql_object);

my $conn;

# подключаемся к базе mysql
sub _toconnect {
    $conn = DBI->connect("dbi:mysql:$DB_NAME:$DB_HOST:$DB_PORT", "$DB_USER", "$DB_PASS", {AutoCommit => 1});
    if ($conn) {
        $conn->{'mysql_enable_utf8'} = 1;
        $conn->do("SET NAMES `utf8`;");
        $conn->do("SET CHARACTER SET `utf8`;");
        return(1);
    }
    else {
        warn "Don't connect database: \'\"dbi:mysql:$DB_NAME:$DB_HOST:$DB_PORT\", \"$DB_USER\", \"$DB_PASS\"'\n";
        return();
    }
}


# выполняем sql запрос
# вторым параметром передают флаг, когда не ожидают ответа
sub sql {
    my ( $command, $do ) = @_;
    my @result = ();
    
    # если команды нет, отдаем пустой массив
    if (!$command) { return (\@result); }
  
    # если не подключены, то пробуем подключиться
    if (!$conn) {
        if ( ! _toconnect() ) {
            open(ERR, ">>$PATH_LOG_DB");
            print ERR "| " . get_sql_time() . " | Don't connect database server\n";
            close(ERR);
            $conn = 0;
            return (\@result);
        }
    }
    
    if ($do) {
        # запрос на выполнение без ответа
        unless ( $conn->do("$command") ) {
            # ошибка выполнения
            my $err_msg = $conn->errstr();
            on_utf8(\$err_msg);
            my ( $package, $filename, $line ) = caller;
            open(ERR, ">>$PATH_LOG_DB");
            print ERR "| " . get_sql_time() . " | "."$package:$line | $err_msg: '$command'\n";
            close(ERR);
            return(0);
        } else {
            # выполнить удалось
            return(1);
        }
    }
    else {
        # запрос на выполнение с получением данных
        my $strin = $conn->prepare($command);
        if ($strin->execute) {
            # запрос выполнен
            while (my @value = $strin->fetchrow_array) {
                # заполняем массив данными для вывода
                foreach (@value) {
                     push( @result, $_ );
                }
            }
            $strin->finish;
            return (\@result);
        } else {
            # ошибка выполнения
            my $err_msg = $conn->errstr();
            on_utf8(\$err_msg);
            my ( $package, $filename, $line ) = caller;
            open(ERR, ">>$PATH_LOG_DB");
            print ERR "| " . get_sql_time() . " | "."$package:$line | $err_msg: '$command'\n";
            close(ERR);
        }
    }
    return (\@result);
}

# возвращаем актуальный объект соединения с базой
sub get_sql_object {
    # если не подключены, то пробуем подключиться
    if (!$conn) {
        if ( ! _toconnect() ) {
            open(ERR, ">>$PATH_LOG_DB");
            print ERR "| " . get_sql_time() . " | Don't connect database server\n";
            close(ERR);
            $conn = 0;
        }
    }
    # отдаем объект или ложь
    return($conn);
}

1;
