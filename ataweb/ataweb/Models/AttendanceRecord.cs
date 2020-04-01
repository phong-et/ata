using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace ataweb.Models
{
    public class AttendanceRecord
    {
        [Key]
        public int id { get; set; }
        [Required]
        [Display(Name = "User Id")]
        public String localId { get; set; }
        public DateTime checkInTime { get; set; }
        public DateTime? checkOutTime { get; set; }
        public String lateReason { get; set; }
        public String earlyReason { get; set; }
    }
}
