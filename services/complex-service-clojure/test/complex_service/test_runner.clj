(ns complex-service.test-runner
  (:require [clojure.test :as test]
            [complex-service.api.handlers-test]
            [complex-service.core-test]))

(defn run-tests []
  (let [results (test/run-all-tests #"complex-service.*-test")]
    (System/exit (if (test/successful? results) 0 1))))

(defn -main [& args]
  (run-tests))