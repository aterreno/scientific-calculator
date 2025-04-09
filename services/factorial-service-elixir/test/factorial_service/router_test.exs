defmodule FactorialService.RouterTest do
  use ExUnit.Case, async: true
  
  # Update to address deprecation warning
  import Plug.Test
  import Plug.Conn

  alias FactorialService.Router

  @opts Router.init([])

  describe "GET /health" do
    test "returns healthy status" do
      conn = conn(:get, "/health")
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      response = Jason.decode!(conn.resp_body)
      assert response == %{"status" => "healthy"}
    end
  end

  describe "POST /factorial" do
    test "calculates factorial of 0" do
      conn = conn(:post, "/factorial", Jason.encode!(%{a: 0}))
             |> put_req_header("content-type", "application/json")
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      response = Jason.decode!(conn.resp_body)
      assert response == %{"result" => 1}
    end

    test "calculates factorial of 1" do
      conn = conn(:post, "/factorial", Jason.encode!(%{a: 1}))
             |> put_req_header("content-type", "application/json")
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      response = Jason.decode!(conn.resp_body)
      assert response == %{"result" => 1}
    end

    test "calculates factorial of 5" do
      conn = conn(:post, "/factorial", Jason.encode!(%{a: 5}))
             |> put_req_header("content-type", "application/json")
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      response = Jason.decode!(conn.resp_body)
      assert response == %{"result" => 120}
    end

    test "handles float input by truncating to integer" do
      conn = conn(:post, "/factorial", Jason.encode!(%{a: 5.7}))
             |> put_req_header("content-type", "application/json")
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      response = Jason.decode!(conn.resp_body)
      assert response == %{"result" => 120}  # 5! = 120
    end
  end

  describe "POST /permutation" do
    test "calculates permutation P(5,2)" do
      conn = conn(:post, "/permutation", Jason.encode!(%{a: 5, b: 2}))
             |> put_req_header("content-type", "application/json")
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      response = Jason.decode!(conn.resp_body)
      assert response == %{"result" => 20}  # P(5,2) = 5!/(5-2)! = 5!/3! = 20
    end

    test "calculates permutation P(5,5)" do
      conn = conn(:post, "/permutation", Jason.encode!(%{a: 5, b: 5}))
             |> put_req_header("content-type", "application/json")
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      response = Jason.decode!(conn.resp_body)
      assert response == %{"result" => 120}  # P(5,5) = 5! = 120
    end

    test "calculates permutation P(5,0)" do
      conn = conn(:post, "/permutation", Jason.encode!(%{a: 5, b: 0}))
             |> put_req_header("content-type", "application/json")
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      response = Jason.decode!(conn.resp_body)
      assert response == %{"result" => 1}  # P(5,0) = 1
    end

    test "handles float inputs by truncating to integers" do
      conn = conn(:post, "/permutation", Jason.encode!(%{a: 5.7, b: 2.3}))
             |> put_req_header("content-type", "application/json")
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      response = Jason.decode!(conn.resp_body)
      assert response == %{"result" => 20}  # P(5,2) = 20
    end
  end

  describe "POST /combination" do
    test "calculates combination C(5,2)" do
      conn = conn(:post, "/combination", Jason.encode!(%{a: 5, b: 2}))
             |> put_req_header("content-type", "application/json")
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      response = Jason.decode!(conn.resp_body)
      assert response == %{"result" => 10}  # C(5,2) = 5!/(2!*3!) = 10
    end

    test "calculates combination C(5,5)" do
      conn = conn(:post, "/combination", Jason.encode!(%{a: 5, b: 5}))
             |> put_req_header("content-type", "application/json")
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      response = Jason.decode!(conn.resp_body)
      assert response == %{"result" => 1}  # C(5,5) = 1
    end

    test "calculates combination C(5,0)" do
      conn = conn(:post, "/combination", Jason.encode!(%{a: 5, b: 0}))
             |> put_req_header("content-type", "application/json")
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      response = Jason.decode!(conn.resp_body)
      assert response == %{"result" => 1}  # C(5,0) = 1
    end

    test "handles float inputs by truncating to integers" do
      conn = conn(:post, "/combination", Jason.encode!(%{a: 5.7, b: 2.3}))
             |> put_req_header("content-type", "application/json")
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 200

      response = Jason.decode!(conn.resp_body)
      assert response == %{"result" => 10}  # C(5,2) = 10
    end
  end

  describe "Not found route" do
    test "returns 404 for unmatched routes" do
      conn = conn(:get, "/not-found")
      conn = Router.call(conn, @opts)

      assert conn.state == :sent
      assert conn.status == 404

      response = Jason.decode!(conn.resp_body)
      assert response == %{"error" => "Not found"}
    end
  end
end