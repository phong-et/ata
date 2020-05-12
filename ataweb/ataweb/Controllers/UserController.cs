
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

        //[HttpPost("checkin")]
        //[HttpPost]
        public async Task<string> test1(
            //AttendanceRecord clientRecord
            string LateReason
            
            )
        {
            try
            {
                var serverRecord = new AttendanceRecord
                {
                    //Id = "asasas",
                    CheckInTime = DateTime.Now,
                    LocalId = "1234",
                    LateReason = LateReason
                    //LateReason = clientRecord.LateReason
                };
                if (ModelState.IsValid)
                {
                    _context.Add(serverRecord);
                    await _context.SaveChangesAsync();
                    return  "{\"success\":true, \"msg\":\"\"}";
                }
            }
            catch (DbUpdateException ex)
            {
                ModelState.AddModelError("", "Unable to save changes. " +
                    "Try again, and if the problem persists " +
                    "see your system administrator.");
                return $"{{\"success\":false, \"msg\":\"{ex.ToString()}\"}}";
            }
            return "{\"success\":false, \"msg\":\"unknown error\"}";
        }
        //[HttpGet("checkout")]
        //[HttpPost]
        //public string test2()
        //{
        //    return "{\"test2\":2222}";
        //}
        [HttpGet]
        public string test3() => "{\"test3\":3333}";
    }
}
