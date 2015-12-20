(ns horus.core
  (:require [yesql.core :as sql]
            [irclj.core :as irc]
            [irclj.connection :as raw-irc])
  (:gen-class))

(def postgres-db {:classname "org.postgresql.Driver"
                  :subprotocol "postgresql"
                  :subname "//localhost:5432/horus"
                  :user "nick"
                  :password ""})

(sql/defqueries "horus/query/update.sql"
  {:connection postgres-db})

(sql/defqueries "horus/query/insert.sql"
  {:connection postgres-db})

(sql/defqueries "horus/query/select.sql"
  {:connection postgres-db})

(def ^:dynamic *state*
  (ref {:whois {}}))

(defn- transact [entry]
  (let [host (:host entry)
        nick (:nick entry)
        username (:username entry)
        realname (:realname entry)
        channels (or (:channels entry) [])
        registeredp (or (:registeredp entry) false)
        tlsp (or (:tlsp entry) false)

        h-get (select-host {:host host})
        n-get (select-nick {:host host :nick nick})]
    ;; Create a new host entry if doesn't exit
    (if (empty? h-get)
      (insert-host<!
       {:host host
        :tlsp tlsp})

      (do
        (when (and tlsp (not (:tlsp h-get)))
          (update-tlsp<!
           {:host host})

        (update-seen<! {:host host}))))

    ;; Create a new (host, nick) pair if doesn't exist
    ;; Nicks are case sensitive
    (if (empty? n-get)
      (insert-nick<!
       {:host host
        :nick nick
        :registeredp registeredp})

      (when (and registeredp (not (:registeredp n-get)))
        (update-registeredp<!
         {:host host
          :nick nick})))

    ;; Create a new (host, nick, username) triple if doesn't exist
    (when (and username
               (empty? (select-username
                        {:host host
                         :nick nick
                         :username username})))
      (insert-username<!
       {:host host
        :nick nick
        :username username}))

    ;; Create a new (host, nick, realname) triple if doesn't exist
    (when (and realname
               (empty? (select-realname
                        {:host host
                         :nick nick
                         :realname realname})))
      (insert-realname<!
       {:host host
        :nick nick
        :realname realname}))

    ;; Insert all channels
    (doseq [c channels]
      (when (empty? (select-channel
                     {:host host
                      :nick nick
                      :channel c}))
        (insert-channel<!
         {:host host
          :nick nick
          :channel c})))))

(defn- print-raw [irc a1 a2]
  (println a2))

(defn- whois-hook [irc args]
  (let [command (:command args)
        nick (second (:params args))
        nkey (.toUpperCase nick)]
    (when (= command "318")
      (transact (get (:whois @*state*) nkey)))

    (dosync (alter *state* update-in [:whois]
                   (fn [old]
                     (case command
                       "311" (assoc old nkey {:nick nick
                                              :username (nth (:params args) 2)
                                              :host (nth (clojure.string/split (:raw args) #" " 8) 5)
                                              :realname (subs (nth (clojure.string/split (:raw args) #" " 8) 7) 1)})
                       "319" (let [chans (nth (:params args) 2)]
                               (assoc-in old [nkey :channels]
                                         (-> chans
                                             (.replace "&" "")
                                             (.replace "@" "")
                                             (.replace "%" "")
                                             (.replace "+" "")
                                             (.split " ")
                                             vec)))
                       "307" (assoc-in old [nkey :registeredp] true)
                       "671" (assoc-in old [nkey :tlsp] true)
                       "318" (dissoc old nkey)))))))

(defn- join-hook [irc args]
  (raw-irc/write-irc-line irc (str "WHOIS " (:nick args))))

(defn- nick-hook [irc args]
  (raw-irc/write-irc-line irc (str "WHOIS " (first (:params args)))))

(defn- quit-hook [irc args]
  (transact {:host (:host args)
             :nick (:nick args)
             :username (:user args)}))

(defn- privmsg-hook [irc args])

(defn- whois-channel [irc channel]
  (doseq [nick (-> @irc
                   :channels
                   (get channel)
                   :users
                   keys)]
    (raw-irc/write-irc-line irc (str "WHOIS " nick))))

(def conn
  (irc/connect
   ""
   6667
   ""
   :pass ""
   :real-name ""
   :username ""
   :callbacks {:raw-log print-raw
               :311 whois-hook
               :319 whois-hook
               :307 whois-hook
               :671 whois-hook
               :318 whois-hook
               :join join-hook
               :nick nick-hook
               :quit quit-hook
               :privmsg privmsg-hook}))

(irc/join conn "#")
(whois-channel conn "#")
(irc/quit conn)

(defn -main
  "I don't do a whole lot ... yet."
  [& args]
  (println "Hello, World!"))
