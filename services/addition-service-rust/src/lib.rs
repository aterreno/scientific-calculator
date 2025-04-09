use actix_web::{web, HttpResponse, Responder};
use serde::{Deserialize, Serialize};
use log::info;

#[derive(Deserialize, Serialize, Debug)]
pub struct AdditionParams {
    pub a: f64,
    pub b: f64,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AdditionResult {
    pub result: f64,
}

pub async fn add(params: web::Json<AdditionParams>) -> impl Responder {
    let result = params.a + params.b;
    info!("Addition: {} + {} = {}", params.a, params.b, result);
    HttpResponse::Ok().json(AdditionResult { result })
}

pub async fn health_check() -> impl Responder {
    HttpResponse::Ok().json(serde_json::json!({"status": "healthy"}))
}