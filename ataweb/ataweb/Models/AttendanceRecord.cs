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
        #pragma warning disable CS8618 // Non-nullable field is uninitialized. Consider declaring as nullable.
        public string LocalId { get; set; }
        #pragma warning restore CS8618 // Non-nullable field is uninitialized. Consider declaring as nullable.

        public DateTime CheckInTime { get; set; }
        public DateTime? CheckOutTime { get; set; }
        public string? LateReason { get; set; }
        public string? EarlyReason { get; set; }
    }
}
