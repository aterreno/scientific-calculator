namespace SquareRootApp.Tests

open System
open System.Net
open System.Net.Http
open System.Text
open System.Threading.Tasks
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Hosting
open Microsoft.AspNetCore.TestHost
open Microsoft.Extensions.DependencyInjection
open Xunit
open Newtonsoft.Json
open SquareRootApp

// Test data types for JSON serialization/deserialization
type TestSquareRootRequest = { a: float }
type TestSquareRootResponse = { result: float }
type TestHealthResponse = { status: string }

// Test fixture
type SquareRootServiceFixture() = 
    // Create a test server with the application
    let server = 
        WebHostBuilder()
            .UseStartup<TestStartup>()
            |> fun builder -> new TestServer(builder)
            
    member _.Server = server
    member _.CreateClient() = server.CreateClient()
    
    interface IDisposable with
        member _.Dispose() = server.Dispose()

and TestStartup() =
    member _.ConfigureServices(services: IServiceCollection) =
        App.configureServices services

    member _.Configure(app: IApplicationBuilder) =
        App.configureApp app

// Helper to convert objects to JSON string
let toJsonString obj =
    JsonConvert.SerializeObject(obj)

// Helper to deserialize JSON from string
let fromJsonString<'T> (json: string) =
    JsonConvert.DeserializeObject<'T>(json)

[<Fact>]
let ``Health endpoint returns healthy status`` () = async {
    use fixture = new SquareRootServiceFixture()
    use client = fixture.CreateClient()
    
    let! response = client.GetAsync("/health") |> Async.AwaitTask
    
    Assert.Equal(HttpStatusCode.OK, response.StatusCode)
    
    let! content = response.Content.ReadAsStringAsync() |> Async.AwaitTask
    let result = fromJsonString<TestHealthResponse>(content)
    
    Assert.Equal("healthy", result.status)
}

[<Theory>]
[<InlineData(4.0, 2.0)>]         // Perfect square
[<InlineData(9.0, 3.0)>]         // Perfect square
[<InlineData(2.0, 1.4142135)>]   // Irrational result
[<InlineData(0.0, 0.0)>]         // Zero
[<InlineData(0.25, 0.5)>]        // Fraction
[<InlineData(1000000.0, 1000.0)>] // Large number
let ``Square root calculation returns correct result`` (input: float, expected: float) = async {
    use fixture = new SquareRootServiceFixture()
    use client = fixture.CreateClient()
    
    let request = { a = input }
    let content = new StringContent(toJsonString request, Encoding.UTF8, "application/json")
    
    let! response = client.PostAsync("/sqrt", content) |> Async.AwaitTask
    
    Assert.Equal(HttpStatusCode.OK, response.StatusCode)
    
    let! responseContent = response.Content.ReadAsStringAsync() |> Async.AwaitTask
    let result = fromJsonString<TestSquareRootResponse>(responseContent)
    
    // Use epsilon for floating point comparison
    Assert.True(Math.Abs(expected - result.result) < 0.0001, 
                sprintf "Expected %f but got %f" expected result.result)
}

[<Fact>]
let ``Square root of negative number returns bad request`` () = async {
    use fixture = new SquareRootServiceFixture()
    use client = fixture.CreateClient()
    
    let request = { a = -1.0 }
    let content = new StringContent(toJsonString request, Encoding.UTF8, "application/json")
    
    let! response = client.PostAsync("/sqrt", content) |> Async.AwaitTask
    
    Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode)
}

[<Fact>]
let ``Invalid request returns bad request`` () = async {
    use fixture = new SquareRootServiceFixture()
    use client = fixture.CreateClient()
    
    // Send invalid JSON
    let content = new StringContent("{ invalid json }", Encoding.UTF8, "application/json")
    
    let! response = client.PostAsync("/sqrt", content) |> Async.AwaitTask
    
    Assert.Equal(HttpStatusCode.BadRequest, response.StatusCode)
}

[<Fact>]
let ``Non-existent route returns not found`` () = async {
    use fixture = new SquareRootServiceFixture()
    use client = fixture.CreateClient()
    
    let! response = client.GetAsync("/nonexistent") |> Async.AwaitTask
    
    Assert.Equal(HttpStatusCode.NotFound, response.StatusCode)
}