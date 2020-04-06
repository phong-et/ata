using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ataweb.Models
{
    public class ApplicationDbContext: DbContext
    {
        #pragma warning disable CS8618 // Non-nullable field is uninitialized. Consider declaring as nullable.
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options):base(options){}
        #pragma warning restore CS8618 // Non-nullable field is uninitialized. Consider declaring as nullable.
        public DbSet<AttendanceRecord> AttendanceRecord { get; set; }
    }
}
