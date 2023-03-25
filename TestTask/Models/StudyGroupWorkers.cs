using System.ComponentModel.DataAnnotations;

namespace TestTask.Models
{
    public class StudyGroupWorkers
    {
        [Key]
        public int id { get; set; }
        public string worker_name { get; set; }
        public string organization_name { get; set; }
    }
}
