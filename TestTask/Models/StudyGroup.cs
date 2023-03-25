using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.Numerics;

namespace TestTask.Models
{

    public class StudyGroup
    {
        [Key]
        public int id { get; set; }
        public string group_name { get; set; }
        public string teacher_name { get; set; }
        public int count_workers { get; set; } 
        
    }
}
