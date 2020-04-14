using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ataweb.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController
    {
        [HttpGet("checkin")]
        public string test()
        {
            return "{\"test\":1234}";
        }
        [HttpGet("checkout")]
        public string test1()
        {
            return "{\"test1\":4321}";
        }
    }
}
