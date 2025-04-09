(ns build
  (:require [clojure.tools.build.api :as b]))

(def lib 'complex-service)
(def version "0.1.0")
(def class-dir "target/classes")
(def basis (b/create-basis {:project "deps.edn"}))
(def uber-file (format "target/%s-standalone.jar" (name lib)))

(defn clean [_]
  (b/delete {:path "target"}))

(defn uber [_]
  (clean nil)
  (b/copy-dir {:src-dirs ["src" "resources"]
                :target-dir class-dir})
  (b/compile-clj {:basis basis
                   :src-dirs ["src"]
                   :class-dir class-dir})
  (b/uber {:class-dir class-dir
           :uber-file uber-file
           :basis basis
           :main 'complex-service.core}))
