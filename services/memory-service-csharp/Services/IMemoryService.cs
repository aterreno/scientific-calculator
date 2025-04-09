namespace MemoryService.Services;

public interface IMemoryService
{
    void Add(double value);
    void Subtract(double value);
    double Recall();
    void Clear();
}