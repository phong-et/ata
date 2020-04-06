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
        #pragma warning disable CS8618 // Non-nullable field is uninitialized. Consider declaring as nullable.
        public string localId { get; set; }
        #pragma warning restore CS8618 // Non-nullable field is uninitialized. Consider declaring as nullable.

        public DateTime checkInTime { get; set; }
        public DateTime? checkOutTime { get; set; }
        public string? lateReason { get; set; }
        public string? earlyReason { get; set; }
    }
}
