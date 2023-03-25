using System.ComponentModel.DataAnnotations;

namespace TestTask.Models
{
    public class Worker
    {
        [Key]
        public int id_work { get; set; }
        public string name_work { get; set; }
    }
}
