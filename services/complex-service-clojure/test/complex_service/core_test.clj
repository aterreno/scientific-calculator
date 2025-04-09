(ns complex-service.core-test
  (:require [clojure.test :refer :all]
            [complex-service.core :as core]
            [ring.mock.request :as mock]
            [muuntaja.core :as m]))

(defn parse-json-body [response]
  (m/decode "application/json" (:body response)))

(deftest test-app-routes
  (testing "Health endpoint"
    (let [response (core/app (mock/request :get "/health"))
          body (parse-json-body response)]
      (is (= 200 (:status response)))
      (is (= {:status "healthy"} body))))

  (testing "Add endpoint"
    (let [response (core/app (-> (mock/request :post "/add")
                                 (mock/json-body {:real-a 3 :imag-a 4
                                                  :real-b 2 :imag-b -1})))
          body (parse-json-body response)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 5 :imag 3}} body))))
    
  (testing "Add endpoint with null values"
    (let [response (core/app (-> (mock/request :post "/add")
                                 (mock/json-body {:real-a 3 :real-b 2})))
          body (parse-json-body response)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 5 :imag 0}} body))))
    
  (testing "Add endpoint with empty request"
    (let [response (core/app (-> (mock/request :post "/add")
                                 (mock/json-body {})))
          body (parse-json-body response)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 0 :imag 0}} body))))

  (testing "Subtract endpoint"
    (let [response (core/app (-> (mock/request :post "/subtract")
                                 (mock/json-body {:real-a 3 :imag-a 4
                                                  :real-b 2 :imag-b -1})))
          body (parse-json-body response)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 1 :imag 5}} body))))

  (testing "Multiply endpoint"
    (let [response (core/app (-> (mock/request :post "/multiply")
                                 (mock/json-body {:real-a 3 :imag-a 4
                                                  :real-b 2 :imag-b -1})))
          body (parse-json-body response)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 10 :imag 5}} body))))

  (testing "Divide endpoint"
    (let [response (core/app (-> (mock/request :post "/divide")
                                 (mock/json-body {:real-a 3 :imag-a 4
                                                  :real-b 2 :imag-b -1})))
          body (parse-json-body response)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 0.4 :imag 2.2}} body))))

  (testing "Magnitude endpoint"
    (let [response (core/app (-> (mock/request :post "/magnitude")
                                 (mock/json-body {:real 3 :imag 4})))
          body (parse-json-body response)]
      (is (= 200 (:status response)))
      (is (= {:result 5.0} body))))

  (testing "Conjugate endpoint"
    (let [response (core/app (-> (mock/request :post "/conjugate")
                                 (mock/json-body {:real 3 :imag 4})))
          body (parse-json-body response)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 3 :imag -4}} body)))))