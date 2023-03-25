using Microsoft.Extensions.Primitives;
using System.ComponentModel.DataAnnotations;

namespace TestTask.Models
{
    public class Teacher
    {
        [Key]
        public int id { get; set; }
        public string name { get; set; }

    }
}
