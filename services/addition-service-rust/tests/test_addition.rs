use actix_web::{test, web, App};
use serde_json::json;

// Import the handlers from the main application
use addition_service::{add, health_check, AdditionParams, AdditionResult};

#[actix_rt::test]
async fn test_health_check() {
    let app = test::init_service(
        App::new().route("/health", web::get().to(health_check))
    ).await;
    
    let req = test::TestRequest::get().uri("/health").to_request();
    let resp = test::call_service(&app, req).await;
    
    assert!(resp.status().is_success());
    
    let body = test::read_body(resp).await;
    let json_body: serde_json::Value = serde_json::from_slice(&body).unwrap();
    
    assert_eq!(json_body, json!({"status": "healthy"}));
}

#[actix_rt::test]
async fn test_addition() {
    let app = test::init_service(
        App::new().route("/add", web::post().to(add))
    ).await;
    
    // Test case 1: Basic addition
    let params = AdditionParams { a: 5.0, b: 3.0 };
    let req = test::TestRequest::post()
        .uri("/add")
        .set_json(&params)
        .to_request();
    
    let resp = test::call_service(&app, req).await;
    assert!(resp.status().is_success());
    
    let body = test::read_body(resp).await;
    let result: AdditionResult = serde_json::from_slice(&body).unwrap();
    assert_eq!(result.result, 8.0);
    
    // Test case 2: Negative numbers
    let params = AdditionParams { a: -5.0, b: 3.0 };
    let req = test::TestRequest::post()
        .uri("/add")
        .set_json(&params)
        .to_request();
    
    let resp = test::call_service(&app, req).await;
    assert!(resp.status().is_success());
    
    let body = test::read_body(resp).await;
    let result: AdditionResult = serde_json::from_slice(&body).unwrap();
    assert_eq!(result.result, -2.0);
    
    // Test case 3: Decimal numbers
    let params = AdditionParams { a: 5.5, b: 3.3 };
    let req = test::TestRequest::post()
        .uri("/add")
        .set_json(&params)
        .to_request();
    
    let resp = test::call_service(&app, req).await;
    assert!(resp.status().is_success());
    
    let body = test::read_body(resp).await;
    let result: AdditionResult = serde_json::from_slice(&body).unwrap();
    assert_eq!(result.result, 8.8);
}