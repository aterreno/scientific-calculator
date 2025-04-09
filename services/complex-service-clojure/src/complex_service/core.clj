(ns complex-service.core
  (:require [ring.adapter.jetty :as jetty]
            [reitit.ring :as ring]
            [muuntaja.core :as m]
            [reitit.ring.middleware.muuntaja :as muuntaja]
            [complex-service.api.handlers :as handlers])
  (:gen-class))

(def app
  (ring/ring-handler
   (ring/router
    [["/health" {:get handlers/health-handler}]
     ["/add" {:post handlers/add-handler}]
     ["/subtract" {:post handlers/subtract-handler}]
     ["/multiply" {:post handlers/multiply-handler}]
     ["/divide" {:post handlers/divide-handler}]
     ["/magnitude" {:post handlers/magnitude-handler}]
     ["/conjugate" {:post handlers/conjugate-handler}]]
    {:data {:muuntaja m/instance
            :middleware [muuntaja/format-middleware]}})))

(defn start-server [port]
  (println (str "Complex Number Service starting on port " port))
  (jetty/run-jetty app {:port port :join? false}))

(defn -main [& args]
  (let [port (Integer/parseInt (or (System/getenv "PORT") "8017"))]
    (start-server port)))
