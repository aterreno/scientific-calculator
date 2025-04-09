using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Moq;
using Xunit;
using MemoryService.Controllers;
using MemoryService.Models;
using MemoryService.Services;

namespace MemoryService.Controllers.Tests;

public class MemoryControllerTests
{
    private readonly Mock<ILogger<MemoryController>> _loggerMock;
    private readonly Mock<IMemoryService> _memoryServiceMock;
    private readonly MemoryController _controller;

    public MemoryControllerTests()
    {
        _loggerMock = new Mock<ILogger<MemoryController>>();
        _memoryServiceMock = new Mock<IMemoryService>();
        _controller = new MemoryController(_loggerMock.Object, _memoryServiceMock.Object);
    }

    [Fact]
    public void Health_ShouldReturnHealthyStatus()
    {
        // Act
        var result = _controller.Health() as ObjectResult;
        
        // Assert
        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);
        
        dynamic value = result.Value;
        Assert.Equal("healthy", value.status);
    }

    [Fact]
    public void Add_ShouldAddValueAndReturnResult()
    {
        // Arrange
        var request = new MemoryRequest { A = 5.0 };
        _memoryServiceMock.Setup(m => m.Recall()).Returns(5.0);
        
        // Act
        var result = _controller.Add(request) as ObjectResult;
        
        // Assert
        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);
        
        _memoryServiceMock.Verify(m => m.Add(5.0), Times.Once);
        
        var response = result.Value as MemoryResponse;
        Assert.NotNull(response);
        Assert.Equal(5.0, response.Result);
    }

    [Fact]
    public void Subtract_ShouldSubtractValueAndReturnResult()
    {
        // Arrange
        var request = new MemoryRequest { A = 3.0 };
        _memoryServiceMock.Setup(m => m.Recall()).Returns(7.0);
        
        // Act
        var result = _controller.Subtract(request) as ObjectResult;
        
        // Assert
        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);
        
        _memoryServiceMock.Verify(m => m.Subtract(3.0), Times.Once);
        
        var response = result.Value as MemoryResponse;
        Assert.NotNull(response);
        Assert.Equal(7.0, response.Result);
    }

    [Fact]
    public void Recall_ShouldReturnCurrentMemoryValue()
    {
        // Arrange
        _memoryServiceMock.Setup(m => m.Recall()).Returns(10.0);
        
        // Act
        var result = _controller.Recall() as ObjectResult;
        
        // Assert
        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);
        
        _memoryServiceMock.Verify(m => m.Recall(), Times.AtLeastOnce);
        
        var response = result.Value as MemoryResponse;
        Assert.NotNull(response);
        Assert.Equal(10.0, response.Result);
    }

    [Fact]
    public void Clear_ShouldClearMemoryAndReturnZero()
    {
        // Arrange
        _memoryServiceMock.Setup(m => m.Clear());
        
        // Act
        var result = _controller.Clear() as ObjectResult;
        
        // Assert
        Assert.NotNull(result);
        Assert.Equal(200, result.StatusCode);
        
        _memoryServiceMock.Verify(m => m.Clear(), Times.Once);
        
        var response = result.Value as MemoryResponse;
        Assert.NotNull(response);
        Assert.Equal(0.0, response.Result);
    }
}