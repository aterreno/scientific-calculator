use actix_web::{web, App, HttpServer};
use log::info;

// Import handlers from lib.rs
use addition_service::{add, health_check};

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    env_logger::init_from_env(env_logger::Env::new().default_filter_or("info"));
    
    info!("Addition Service starting on port 8001");
    
    HttpServer::new(|| {
        App::new()
            .route("/health", web::get().to(health_check))
            .route("/add", web::post().to(add))
    })
    .bind("0.0.0.0:8001")?
    .run()
    .await
}