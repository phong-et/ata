using ataweb.Models;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ataweb.Data
{
    public class AtaDbContext:DbContext
    {
        public AtaDbContext(DbContextOptions<AtaDbContext> options) : base(options) { }
        public DbSet<AttendanceRecord> AttendanceRecord { get; set; }
    }

}
