using Microsoft.AspNetCore.Mvc;
using MemoryService.Models;
using MemoryService.Services;

namespace MemoryService.Controllers;

[ApiController]
[Route("/")]
public class MemoryController : ControllerBase
{
    private readonly ILogger<MemoryController> _logger;
    private readonly IMemoryService _memoryService;

    public MemoryController(ILogger<MemoryController> logger, IMemoryService memoryService)
    {
        _logger = logger;
        _memoryService = memoryService;
    }

    [HttpGet("health")]
    public IActionResult Health()
    {
        return Ok(new { status = "healthy" });
    }

    [HttpPost("memory-add")]
    public IActionResult Add([FromBody] MemoryRequest request)
    {
        _memoryService.Add(request.A);
        _logger.LogInformation("Memory Add: Added {Value} to memory, new value: {MemoryValue}", request.A, _memoryService.Recall());
        return Ok(new MemoryResponse { Result = _memoryService.Recall() });
    }

    [HttpPost("memory-subtract")]
    public IActionResult Subtract([FromBody] MemoryRequest request)
    {
        _memoryService.Subtract(request.A);
        _logger.LogInformation("Memory Subtract: Subtracted {Value} from memory, new value: {MemoryValue}", request.A, _memoryService.Recall());
        return Ok(new MemoryResponse { Result = _memoryService.Recall() });
    }

    [HttpPost("memory-recall")]
    public IActionResult Recall()
    {
        double value = _memoryService.Recall();
        _logger.LogInformation("Memory Recall: Current memory value: {MemoryValue}", value);
        return Ok(new MemoryResponse { Result = value });
    }

    [HttpPost("memory-clear")]
    public IActionResult Clear()
    {
        _memoryService.Clear();
        _logger.LogInformation("Memory Clear: Memory value cleared");
        return Ok(new MemoryResponse { Result = 0 });
    }
}