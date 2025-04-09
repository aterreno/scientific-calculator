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
       (double (/ (+ (* a-real b-real) (* a-imag b-imag)) denominator))
       (double (/ (- (* a-imag b-real) (* a-real b-imag)) denominator))))))

(defn magnitude-complex [a]
  (double (math/sqrt (+ (math/expt (:real a) 2) (math/expt (:imag a) 2)))))

(defn conjugate-complex [a]
  (complex-number (:real a) (- (:imag a))))

(defn log [operation a b result]
  (println (format "%s: (%.2f + %.2fi) %s (%.2f + %.2fi) = (%.2f + %.2fi)"
                   (name operation)
                   (double (:real a)) (double (:imag a))
                   (name operation)
                   (double (:real b)) (double (:imag b))
                   (double (:real result)) (double (:imag result)))))

(defn log-single [operation a result]
  (println (format "%s: %s(%.2f + %.2fi) = %s"
                   (name operation)
                   (name operation)
                   (double (:real a)) (double (:imag a))
                   (str result))))

(defn get-nested-params [params]
  (let [nested-params (get params :a params)]
    nested-params))

(defn add-handler [request]
  (let [params (:body-params request)
        nested-params (get-nested-params params)
        real-a (if (nil? (:real-a nested-params)) 0 (:real-a nested-params))
        imag-a (if (nil? (:imag-a nested-params)) 0 (:imag-a nested-params))
        real-b (if (nil? (:real-b nested-params)) 0 (:real-b nested-params))
        imag-b (if (nil? (:imag-b nested-params)) 0 (:imag-b nested-params))
        a (complex-number real-a imag-a)
        b (complex-number real-b imag-b)
        result (add-complex a b)]
    (log :add a b result)
    {:status 200
     :body {:result result}}))

(defn subtract-handler [request]
  (let [params (:body-params request)
        nested-params (get-nested-params params)
        real-a (if (nil? (:real-a nested-params)) 0 (:real-a nested-params))
        imag-a (if (nil? (:imag-a nested-params)) 0 (:imag-a nested-params))
        real-b (if (nil? (:real-b nested-params)) 0 (:real-b nested-params))
        imag-b (if (nil? (:imag-b nested-params)) 0 (:imag-b nested-params))
        a (complex-number real-a imag-a)
        b (complex-number real-b imag-b)
        result (subtract-complex a b)]
    (log :subtract a b result)
    {:status 200
     :body {:result result}}))

(defn multiply-handler [request]
  (let [params (:body-params request)
        nested-params (get-nested-params params)
        real-a (if (nil? (:real-a nested-params)) 0 (:real-a nested-params))
        imag-a (if (nil? (:imag-a nested-params)) 0 (:imag-a nested-params))
        real-b (if (nil? (:real-b nested-params)) 0 (:real-b nested-params))
        imag-b (if (nil? (:imag-b nested-params)) 0 (:imag-b nested-params))
        a (complex-number real-a imag-a)
        b (complex-number real-b imag-b)
        result (multiply-complex a b)]
    (log :multiply a b result)
    {:status 200
     :body {:result result}}))

(defn divide-handler [request]
  (try
    (let [params (:body-params request)
          nested-params (get-nested-params params)
          real-a (if (nil? (:real-a nested-params)) 0 (:real-a nested-params))
          imag-a (if (nil? (:imag-a nested-params)) 0 (:imag-a nested-params))
          real-b (if (nil? (:real-b nested-params)) 0 (:real-b nested-params))
          imag-b (if (nil? (:imag-b nested-params)) 0 (:imag-b nested-params))
          a (complex-number real-a imag-a)
          b (complex-number real-b imag-b)
          result (divide-complex a b)]
      (log :divide a b result)
      {:status 200
       :body {:result result}})
    (catch IllegalArgumentException e
      {:status 400
       :body {:error (.getMessage e)}})))

(defn magnitude-handler [request]
  (let [params (:body-params request)
        nested-params (get-nested-params params)
        real (if (nil? (:real nested-params)) 0 (:real nested-params))
        imag (if (nil? (:imag nested-params)) 0 (:imag nested-params))
        a (complex-number real imag)
        result (magnitude-complex a)]
    (log-single :magnitude a result)
    {:status 200
     :body {:result result}}))

(defn conjugate-handler [request]
  (let [params (:body-params request)
        nested-params (get-nested-params params)
        real (if (nil? (:real nested-params)) 0 (:real nested-params))
        imag (if (nil? (:imag nested-params)) 0 (:imag nested-params))
        a (complex-number real imag)
        result (conjugate-complex a)]
    (log-single :conjugate a result)
    {:status 200
     :body {:result result}}))
