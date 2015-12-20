(ns horus.core
  (:require [yesql.core :as sql]
            [clojure.java [jdbc :as jdbc]]
            [irclj.core :as irc]
            [irclj.connection :as irc-raw])
  (:gen-class))

(def postgres-db {:classname "org.postgresql.Driver"
                  :subprotocol "postgresql"
                  :subname "//localhost:5432/horus"
                  :user "nick"
                  :password ""})

(sql/defqueries "horus/query/update.sql"
  {:connection postgres-db})

(update-seen<!
 {:host "wefwe"})

(def conn
  (irc/connect
   "irc.freenode.net"
   6667
   "`"
   :pass ""
   :real-name ""
   :username "~"
   :callbacks {:join println}))

(irc/join conn "#clan-df")
(irc/message conn "han" "wefwef")
(irc-raw/write-irc-line conn "part #irclan")
(irc/kill conn)

(jdbc/query postgres-db
            ["select * from hosts"])
(jdbc/query postgres-db
            ["select * from nicks"])
(jdbc/query postgres-db
            ["select * from usernames"])
(jdbc/query postgres-db
            ["select * from realnames"])
(jdbc/query postgres-db
            ["select * from channels"])

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!"))
