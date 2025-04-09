(ns complex-service.api.handlers
  (:require [clojure.math.numeric-tower :as math]))

(defn health-handler [_]
  {:status 200
   :body {:status "healthy"}})

(defn- complex-number [real imag]
  {:real real :imag imag})

(defn add-complex [a b]
  (complex-number
   (+ (:real a) (:real b))
   (+ (:imag a) (:imag b))))

(defn subtract-complex [a b]
  (complex-number
   (- (:real a) (:real b))
   (- (:imag a) (:imag b))))

(defn multiply-complex [a b]
  (let [a-real (:real a)
        a-imag (:imag a)
        b-real (:real b)
        b-imag (:imag b)]
    (complex-number
     (- (* a-real b-real) (* a-imag b-imag))
     (+ (* a-real b-imag) (* a-imag b-real)))))

(defn divide-complex [a b]
  (let [a-real (:real a)
        a-imag (:imag a)
        b-real (:real b)
        b-imag (:imag b)
        denominator (+ (* b-real b-real) (* b-imag b-imag))]
    (if (zero? denominator)
      (throw (IllegalArgumentException. "Division by zero"))
      (complex-number
       (/ (+ (* a-real b-real) (* a-imag b-imag)) denominator)
       (/ (- (* a-imag b-real) (* a-real b-imag)) denominator)))))

(defn magnitude-complex [a]
  (math/sqrt (+ (math/expt (:real a) 2) (math/expt (:imag a) 2))))

(defn conjugate-complex [a]
  (complex-number (:real a) (- (:imag a))))

(defn log [operation a b result]
  (println (format "%s: (%f + %fi) %s (%f + %fi) = (%f + %fi)"
                   operation
                   (:real a) (:imag a)
                   (name operation)
                   (:real b) (:imag b)
                   (:real result) (:imag result))))

(defn log-single [operation a result]
  (println (format "%s: %s(%f + %fi) = %s"
                   operation
                   (name operation)
                   (:real a) (:imag a)
                   (str result))))

(defn add-handler [request]
  (let [params (:body-params request)
        a (complex-number (:real-a params) (:imag-a params))
        b (complex-number (:real-b params) (:imag-b params))
        result (add-complex a b)]
    (log :add a b result)
    {:status 200
     :body {:result result}}))

(defn subtract-handler [request]
  (let [params (:body-params request)
        a (complex-number (:real-a params) (:imag-a params))
        b (complex-number (:real-b params) (:imag-b params))
        result (subtract-complex a b)]
    (log :subtract a b result)
    {:status 200
     :body {:result result}}))

(defn multiply-handler [request]
  (let [params (:body-params request)
        a (complex-number (:real-a params) (:imag-a params))
        b (complex-number (:real-b params) (:imag-b params))
        result (multiply-complex a b)]
    (log :multiply a b result)
    {:status 200
     :body {:result result}}))

(defn divide-handler [request]
  (try
    (let [params (:body-params request)
          a (complex-number (:real-a params) (:imag-a params))
          b (complex-number (:real-b params) (:imag-b params))
          result (divide-complex a b)]
      (log :divide a b result)
      {:status 200
       :body {:result result}})
    (catch IllegalArgumentException e
      {:status 400
       :body {:error (.getMessage e)}})))

(defn magnitude-handler [request]
  (let [params (:body-params request)
        a (complex-number (:real params) (:imag params))
        result (magnitude-complex a)]
    (log-single :magnitude a result)
    {:status 200
     :body {:result result}}))

(defn conjugate-handler [request]
  (let [params (:body-params request)
        a (complex-number (:real params) (:imag params))
        result (conjugate-complex a)]
    (log-single :conjugate a result)
    {:status 200
     :body {:result result}}))
