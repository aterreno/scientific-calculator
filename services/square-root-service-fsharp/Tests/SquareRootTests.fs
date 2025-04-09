module SquareRootService.Tests

open System
open System.Net
open System.Net.Http
open System.Text
open Microsoft.AspNetCore.Hosting
open Microsoft.AspNetCore.TestHost
open Microsoft.Extensions.DependencyInjection
open Xunit
open Newtonsoft.Json
open SquareRootService
open System.Threading.Tasks
open Microsoft.AspNetCore.Builder

type TestHost() =
    let server = 
        WebHostBuilder()
            .ConfigureServices(fun services ->
                services.AddGiraffe() |> ignore)
            .Configure(fun app ->
                app.UseGiraffe(webApp))
            |> TestServer

    member __.Server = server
    member __.CreateClient() = server.CreateClient()
    
    interface IDisposable with
        member __.Dispose() = server.Dispose()

type HealthCheckResponse = { status: string }
type SquareRootRequest = { a: float }
type SquareRootResponse = { result: float }

[<Fact>]
let ``Health check returns healthy status`` () = async {
    use host = new TestHost()
    use client = host.CreateClient()
    let! response = client.GetAsync("/health") |> Async.AwaitTask
    Assert.Equal(HttpStatusCode.OK, response.StatusCode)
    
    let! content = response.Content.ReadAsStringAsync() |> Async.AwaitTask
    let result = JsonConvert.DeserializeObject<HealthResponse>(content)
    Assert.Equal("healthy", result.status)
}

[<Fact>]
let ``Square root calculation returns correct result for positive number`` () = async {
    use host = new TestHost()
    use client = host.CreateClient()
    let request = { a = 16.0 }
    let content = new StringContent(JsonConvert.SerializeObject(request), Encoding.UTF8, "application/json")
    
    let! response = client.PostAsync("/sqrt", content) |> Async.AwaitTask
    Assert.Equal(HttpStatusCode.OK, response.StatusCode)
    
    let! responseContent = response.Content.ReadAsStringAsync() |> Async.AwaitTask
    let result = JsonConvert.DeserializeObject<SquareRootResponse>(responseContent)
    Assert.Equal(4.0, result.result)
}

[<Fact>]
let ``Square root calculation returns correct result for decimal number`` () = async {
    use host = new TestHost()
    use client = host.CreateClient()
    let request = { a = 2.25 }
    let content = new StringContent(JsonConvert.SerializeObject(request), Encoding.UTF8, "application/json")
    
    let! response = client.PostAsync("/sqrt", content) |> Async.AwaitTask
    Assert.Equal(HttpStatusCode.OK, response.StatusCode)
    
    let! responseContent = response.Content.ReadAsStringAsync() |> Async.AwaitTask
    let result = JsonConvert.DeserializeObject<SquareRootResponse>(responseContent)
    Assert.Equal(1.5, result.result)
}

[<Fact>]
let ``Square root calculation handles zero correctly`` () = async {
    use host = new TestHost()
    use client = host.CreateClient()
    let request = { a = 0.0 }
    let content = new StringContent(JsonConvert.SerializeObject(request), Encoding.UTF8, "application/json")
    
    let! response = client.PostAsync("/sqrt", content) |> Async.AwaitTask
    Assert.Equal(HttpStatusCode.OK, response.StatusCode)
    
    let! responseContent = response.Content.ReadAsStringAsync() |> Async.AwaitTask
    let result = JsonConvert.DeserializeObject<SquareRootResponse>(responseContent)
    Assert.Equal(0.0, result.result)
}