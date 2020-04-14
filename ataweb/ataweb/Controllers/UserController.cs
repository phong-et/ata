
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using ataweb.Data;
using ataweb.Models;

namespace ataweb.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController: Controller
    {
        private readonly AtaDbContext _context;

        public UserController(AtaDbContext context)
        {
            _context = context;
        }

        [HttpGet("checkin")]
        public async Task<string> test(string jsonCheckIn)
        {
            string result, msg = "";
            try
            {
                var record = new AttendanceRecord
                {
                    //Id = "asasas",
                    CheckInTime = DateTime.Now,
                    LocalId = "1234",
                    LateReason = "Late Reason"
                };
                if (ModelState.IsValid)
                {
                    _context.Add(record);
                    await _context.SaveChangesAsync();
                    result = "{\"success\":true, \"msg\":\"\"}";
                }
            }
            catch (DbUpdateException ex)
            {
                ModelState.AddModelError("", "Unable to save changes. " +
                    "Try again, and if the problem persists " +
                    "see your system administrator.");
                msg = ex.ToString();
            }
            result = $"{{\"success\":false, \"msg\":\"{msg}\"}}";
            return result;
        }
        [HttpGet("checkout")]
        string test1()
        {
            return "{\"test1\":4321}";
        }
    }
}
