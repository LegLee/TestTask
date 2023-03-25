

using System.ComponentModel.DataAnnotations;

namespace TestTask.Models
{
    public class Organization
    {
        [Key]
        public int id { get; set; }
        public string name { get; set; }
        public string tin { get; set; }
        public int id_teacher { get; set; }
    }
}
