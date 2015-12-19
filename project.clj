(defproject horus "0.1.0-SNAPSHOT"
  :description "If you have to ask, you'll never know."
  :url "nil"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.7.0"]
                 [org.clojure/core.typed "0.3.18"]
                 [org.postgresql/postgresql "9.4-1201-jdbc41"]
                 [yesql "0.5.1"]]
  :main ^:skip-aot horus.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
