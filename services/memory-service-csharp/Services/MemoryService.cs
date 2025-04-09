namespace MemoryService.Services;

public class MemoryService : IMemoryService
{
    private double _memory = 0;

    public void Add(double value)
    {
        _memory += value;
    }

    public void Subtract(double value)
    {
        _memory -= value;
    }

    public double Recall()
    {
        return _memory;
    }

    public void Clear()
    {
        _memory = 0;
    }
}