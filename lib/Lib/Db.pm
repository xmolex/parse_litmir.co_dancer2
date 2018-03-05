################################################################################
# Модуль работы с базой данных
################################################################################
package Lib::Db;

use Modern::Perl;
use utf8;
use DBI;
use Lib::Vars;
use Exporter 'import';
our @EXPORT = qw(&sql &get_sql_object);

my $conn;

# функция подключения к базе mysql
sub _toconnect {
    $conn = DBI->connect("dbi:mysql:$DB_NAME:$DB_HOST:$DB_PORT", "$DB_USER", "$DB_PASS", {AutoCommit => 1});
    if ($conn) {
        $conn->{'mysql_enable_utf8'} = 1;
        $conn->do("SET NAMES `utf8`;");
        $conn->do("SET CHARACTER SET `utf8`;");
        return 1;
    }
    else {
        warn "Don't connect database: \'\"dbi:mysql:$DB_NAME:$DB_HOST:$DB_PORT\", \"$DB_USER\", \"$DB_PASS\"'\n";
        return;
    }
}


# выполняем sql запрос
# вторым параметром передают флаг, когда не ожидают ответа
sub sql {
    my ( $command, $silence ) = @_;
    my @result;
    
    # если команды нет, отдаем пустой массив
    return (\@result) unless $command;
  
    # если не подключены, то пробуем подключиться
    if (!$conn) {
        if ( ! _toconnect() ) {
            _to_log("Don't connect database server");
            $conn = 0;
            return (\@result);
        }
    }
    
    if ($silence) {
        # запрос на выполнение без ответа
        return 1 if $conn->do($command);
        
        # ошибка выполнения
        my $err_msg = $conn->errstr();
        on_utf8(\$err_msg);
        my ( $package, $filename, $line ) = caller;
        _to_log("$package:$line | $err_msg: '$command'");
        return;

    }
    else {
        # запрос на выполнение с получением данных
        my $strin = $conn->prepare($command);
        if ($strin->execute) {
            # запрос выполнен
            while (my @value = $strin->fetchrow_array) {
                # заполняем массив данными для вывода
                push @result, $_ for @value;
            }
            $strin->finish;
            return (\@result);
        } else {
            # ошибка выполнения
            my $err_msg = $conn->errstr();
            on_utf8(\$err_msg);
            my ( $package, $filename, $line ) = caller;
            _to_log("$package:$line | $err_msg: '$command'");
        }
    }
    return (\@result);
}

# возвращаем актуальный объект соединения с базой
sub get_sql_object {
    # если не подключены, то пробуем подключиться
    if (!$conn) {
        if ( ! _toconnect() ) {
            _to_log("Don't connect database server");
            $conn = 0;
        }
    }
    # отдаем объект или ложь
    return($conn);
}

# функция записи в лог файл
sub _to_log {
    my ($txt) = @_;
    open my $fh, ">>:utf8", $PATH_LOG_DB;
    return unless $fh;
    say $fh "| " . get_sql_time() . " | " . $txt;
    close $fh;
}

1;
