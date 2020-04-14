using System;
using System.ComponentModel.DataAnnotations;
namespace ataweb.Models
{
    public class AttendanceRecord
    {
        [Key]
        public int Id { get; set; }
        [Required]
        [Display(Name = "User Id")]
        public string LocalId { get; set; }
        public DateTime CheckInTime { get; set; }
        public DateTime? CheckOutTime { get; set; }
        public string LateReason { get; set; }
        public string EarlyReason { get; set; }
    }
}
