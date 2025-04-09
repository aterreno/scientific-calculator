(ns complex-service.api.handlers-test
  (:require [clojure.test :refer :all]
            [complex-service.api.handlers :as handlers]))

(deftest test-complex-number-operations
  (testing "Adding complex numbers"
    (let [a {:real 3 :imag 4}
          b {:real 2 :imag -1}
          result (handlers/add-complex a b)]
      (is (= 5 (:real result)))
      (is (= 3 (:imag result)))))

  (testing "Subtracting complex numbers"
    (let [a {:real 3 :imag 4}
          b {:real 2 :imag -1}
          result (handlers/subtract-complex a b)]
      (is (= 1 (:real result)))
      (is (= 5 (:imag result)))))

  (testing "Multiplying complex numbers"
    (let [a {:real 3 :imag 4}
          b {:real 2 :imag -1}
          result (handlers/multiply-complex a b)]
      (is (= 10 (:real result)))
      (is (= 5 (:imag result)))))

  (testing "Dividing complex numbers"
    (let [a {:real 3 :imag 4}
          b {:real 2 :imag -1}
          result (handlers/divide-complex a b)]
      (is (= 0.4 (:real result)))
      (is (= 2.2 (:imag result)))))

  (testing "Division by zero"
    (let [a {:real 3 :imag 4}
          b {:real 0 :imag 0}]
      (is (thrown? IllegalArgumentException (handlers/divide-complex a b)))))

  (testing "Magnitude of complex number"
    (let [a {:real 3 :imag 4}
          result (handlers/magnitude-complex a)]
      (is (= 5.0 result))))

  (testing "Conjugate of complex number"
    (let [a {:real 3 :imag 4}
          result (handlers/conjugate-complex a)]
      (is (= 3 (:real result)))
      (is (= -4 (:imag result))))))

(deftest test-handlers
  (testing "Health handler"
    (let [response (handlers/health-handler {})]
      (is (= 200 (:status response)))
      (is (= {:status "healthy"} (:body response)))))

  (testing "Add handler"
    (let [request {:body-params {:a {:real-a 3 :imag-a 4 :real-b 2 :imag-b -1}}}
          response (handlers/add-handler request)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 5 :imag 3}} (:body response)))))
    
  (testing "Add handler with null values"
    (let [request {:body-params {:a {:real-a 3 :real-b 2}}}
          response (handlers/add-handler request)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 5 :imag 0}} (:body response)))))

  (testing "Add handler with completely null values"
    (let [request {:body-params {}}
          response (handlers/add-handler request)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 0 :imag 0}} (:body response)))))

  (testing "Subtract handler"
    (let [request {:body-params {:a {:real-a 3 :imag-a 4 :real-b 2 :imag-b -1}}}
          response (handlers/subtract-handler request)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 1 :imag 5}} (:body response)))))

  (testing "Multiply handler"
    (let [request {:body-params {:a {:real-a 3 :imag-a 4 :real-b 2 :imag-b -1}}}
          response (handlers/multiply-handler request)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 10 :imag 5}} (:body response)))))

  (testing "Divide handler success"
    (let [request {:body-params {:a {:real-a 3 :imag-a 4 :real-b 2 :imag-b -1}}}
          response (handlers/divide-handler request)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 0.4 :imag 2.2}} (:body response)))))
  
  (testing "Divide handler division by zero"
    (let [request {:body-params {:a {:real-a 3 :imag-a 4 :real-b 0 :imag-b 0}}}
          response (handlers/divide-handler request)]
      (is (= 400 (:status response)))
      (is (= {:error "Division by zero"} (:body response)))))

  (testing "Magnitude handler"
    (let [request {:body-params {:a {:real 3 :imag 4}}}
          response (handlers/magnitude-handler request)]
      (is (= 200 (:status response)))
      (is (= {:result 5.0} (:body response)))))
    
  (testing "Magnitude handler with null values"
    (let [request {:body-params {}}
          response (handlers/magnitude-handler request)]
      (is (= 200 (:status response)))
      (is (= {:result 0.0} (:body response)))))

  (testing "Conjugate handler"
    (let [request {:body-params {:a {:real 3 :imag 4}}}
          response (handlers/conjugate-handler request)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 3 :imag -4}} (:body response)))))
    
  (testing "Conjugate handler with null values"
    (let [request {:body-params {}}
          response (handlers/conjugate-handler request)]
      (is (= 200 (:status response)))
      (is (= {:result {:real 0 :imag 0}} (:body response))))))