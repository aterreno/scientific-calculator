using Xunit;

namespace MemoryService.Services.Tests;

public class MemoryServiceTests
{
    private readonly IMemoryService _memoryService;

    public MemoryServiceTests()
    {
        _memoryService = new MemoryService();
    }

    [Fact]
    public void Add_ShouldAddValueToMemory()
    {
        // Arrange
        _memoryService.Clear();
        
        // Act
        _memoryService.Add(5.0);
        
        // Assert
        Assert.Equal(5.0, _memoryService.Recall());
        
        // Act again (cumulative)
        _memoryService.Add(3.0);
        
        // Assert
        Assert.Equal(8.0, _memoryService.Recall());
    }

    [Fact]
    public void Subtract_ShouldSubtractValueFromMemory()
    {
        // Arrange
        _memoryService.Clear();
        _memoryService.Add(10.0);
        
        // Act
        _memoryService.Subtract(3.0);
        
        // Assert
        Assert.Equal(7.0, _memoryService.Recall());
        
        // Act again
        _memoryService.Subtract(4.0);
        
        // Assert
        Assert.Equal(3.0, _memoryService.Recall());
    }

    [Fact]
    public void Recall_ShouldReturnCurrentMemoryValue()
    {
        // Arrange
        _memoryService.Clear();
        
        // Assert initial value
        Assert.Equal(0.0, _memoryService.Recall());
        
        // Arrange
        _memoryService.Add(12.5);
        
        // Assert
        Assert.Equal(12.5, _memoryService.Recall());
        
        // Multiple recalls should not change value
        Assert.Equal(12.5, _memoryService.Recall());
        Assert.Equal(12.5, _memoryService.Recall());
    }

    [Fact]
    public void Clear_ShouldResetMemoryToZero()
    {
        // Arrange
        _memoryService.Add(100.0);
        Assert.NotEqual(0.0, _memoryService.Recall());
        
        // Act
        _memoryService.Clear();
        
        // Assert
        Assert.Equal(0.0, _memoryService.Recall());
    }

    [Fact]
    public void Memory_ShouldHandleNegativeValues()
    {
        // Arrange
        _memoryService.Clear();
        
        // Act
        _memoryService.Add(-5.0);
        
        // Assert
        Assert.Equal(-5.0, _memoryService.Recall());
        
        // Act
        _memoryService.Subtract(-2.0);
        
        // Assert
        Assert.Equal(-3.0, _memoryService.Recall());
    }

    [Fact]
    public void Memory_ShouldHandleFloatingPointValues()
    {
        // Arrange
        _memoryService.Clear();
        
        // Act
        _memoryService.Add(5.75);
        
        // Assert
        Assert.Equal(5.75, _memoryService.Recall());
        
        // Act
        _memoryService.Subtract(2.25);
        
        // Assert
        Assert.Equal(3.5, _memoryService.Recall());
    }
}