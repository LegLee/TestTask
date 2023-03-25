using Microsoft.EntityFrameworkCore;
using TestTask.Models;

namespace TestTask.Context
{
    public class AppDbContext: DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }
        public DbSet<StudyGroup> study_groups { get; set; }
        public DbSet<Teacher> teachers { get; set; }
        public DbSet<StudyGroupWorkers> study_group_worker { get; set; }
        public DbSet<StudyGroupTeacher> study_group_teacher { get; set; }   
        public DbSet<Organization> organizations { get; set; }
        public DbSet<Worker> workers { get; set; }

    }
}
