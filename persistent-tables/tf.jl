#! /bin/env julia


## usage
#
#   PGHOST=localhost PGUSER=postgres PGPASSWORD=1234 ./tf.jl ../pride-and-prejudice.txt


function extract_words(path_to_file)
    str_data = open(path_to_file) do f
        read(f, String)
    end
    words = replace(str_data, r"[\W_]+" => " ") |> lowercase |> split
    stop_words = open("../stop_words.txt") do f
        split(read(f, String), ",")
    end
    ascii_lowercase = map(string, 'a':'z')
    stop = vcat(stop_words, ascii_lowercase)
    [w for w in words if !(w in stop)]
end


using LibPQ

function create_schema(connection)
    execute(connection, """
        DROP TABLE IF EXISTS words;
        CREATE TABLE words (
            id      INTEGER,
            value   VARCHAR(50)
        );
    """)
end

function load_file_into_database(path_to_file, connection)
    word_list = extract_words(path_to_file)
    execute(connection, "BEGIN;")
    LibPQ.load!(
                (id = Vector(1:length(word_list)), value = word_list), 
                connection,
                "insert into words (id, value) values (\$1, \$2);"
               )
    execute(connection, "COMMIT;")
end


# main program

connection = LibPQ.Connection("dbname=postgres user=postgres", throw_error = true)

create_schema(connection)

load_file_into_database(ARGS[1], connection)

for r in execute(connection, "select value as w, count(*) as c from words group by value order by c desc fetch first 25 rows only;")
    println(r[1], " - ", r[2])
end


### end
