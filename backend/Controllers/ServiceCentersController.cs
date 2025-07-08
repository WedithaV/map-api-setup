using Microsoft.AspNetCore.Mvc;
using backend.Data;
using backend.Models;

namespace backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ServiceCentersController : ControllerBase
{
    private readonly AppDbContext _db;

    public ServiceCentersController(AppDbContext db)
    {
        _db = db;
    }

    [HttpPost]
    public async Task<IActionResult> Create(ServiceCenter center)
    {
        _db.ServiceCenters.Add(center);
        await _db.SaveChangesAsync();
        return Ok(center);
    }
}
