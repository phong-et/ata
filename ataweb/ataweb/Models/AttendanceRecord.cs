using System;
using System.ComponentModel.DataAnnotations;
namespace ataweb.Models
{
    public class AttendanceRecord
    {
        [Key]
        public int id { get; set; }
        [Required]
        [Display(Name = "User Id")]
        public string localId { get; set; }
        public DateTime checkInTime { get; set; }
        public DateTime? checkOutTime { get; set; }
        public string lateReason { get; set; }
        public string earlyReason { get; set; }
    }
}
