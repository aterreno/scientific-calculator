module SquareRootService

open System
open System.IO
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Cors.Infrastructure
open Microsoft.AspNetCore.Hosting
open Microsoft.Extensions.Hosting
open Microsoft.Extensions.Logging
open Microsoft.Extensions.DependencyInjection
open Giraffe
open FSharp.Control.Tasks
open System.Text.Json
open System.Text.Json.Serialization

// Types
type SquareRootRequest = {
    a: float
}

type SquareRootResponse = {
    result: float
}

type HealthResponse = {
    status: string
}

// Handlers
let healthCheckHandler =
    fun (next : HttpFunc) (ctx : Microsoft.AspNetCore.Http.HttpContext) ->
        let response = { status = "healthy" }
        json response next ctx

let squareRootHandler =
    fun (next : HttpFunc) (ctx : Microsoft.AspNetCore.Http.HttpContext) ->
        task {
            try
                let! request = ctx.BindJsonAsync<SquareRootRequest>()
                let result = Math.Sqrt(request.a)
                printfn "Square Root: sqrt(%f) = %f" request.a result
                
                let response = { result = result }
                return! json response next ctx
            with
            | ex ->
                printfn "Error processing request: %s" ex.Message
                return! RequestErrors.BAD_REQUEST "Invalid request" next ctx
        }

// Web app
let webApp =
    choose [
        GET >=> route "/health" >=> healthCheckHandler
        POST >=> route "/sqrt" >=> squareRootHandler
        RequestErrors.NOT_FOUND "Route not found"
    ]

// Configure services
let configureServices (services : IServiceCollection) =
    services.AddCors()
        .AddGiraffe() |> ignore

// Configure app
let configureApp (app : IApplicationBuilder) =
    let env = app.ApplicationServices.GetService<IWebHostEnvironment>()
    let corsConfig (builder : CorsPolicyBuilder) =
        builder
            .AllowAnyOrigin()
            .AllowAnyMethod()
            .AllowAnyHeader()
            |> ignore
    
    app.UseRouting()
       .UseCors(corsConfig)
       .UseGiraffe webApp

// Configure logging
let configureLogging (builder : ILoggingBuilder) =
    builder.AddConsole()
           .AddDebug() |> ignore

[<EntryPoint>]
let main _ =
    printfn "Square Root Service starting on port 8006"
    Host.CreateDefaultBuilder()
        .ConfigureWebHostDefaults(
            fun webHostBuilder ->
                webHostBuilder
                    .Configure(configureApp)
                    .ConfigureServices(configureServices)
                    .ConfigureLogging(configureLogging)
                    .UseUrls("http://0.0.0.0:8006")
                    |> ignore)
        .Build()
        .Run()
    0