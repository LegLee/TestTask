using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;

namespace TestTask.Models
{

    public class StudyGroupTeacher
    {
        [Key]
        public int id { get; set; }
        public string study_group_name { get; set; }
        public string teacher_name { get; set; }
    }
}
