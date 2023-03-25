using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Primitives;
using Npgsql;
using System.Collections;
using System.Linq;
using System.Security.Cryptography;
using TestTask.Context;
using TestTask.Models;

namespace TestTask.Controllers
{
    public class StudyGroupController : Controller
    {
        private readonly AppDbContext _context;

        public StudyGroupController(AppDbContext context)
        {
            _context = context;
        }


        // GET: StudyGroupController
        public ActionResult Index()
        {

            
            return View(_context.study_groups.FromSqlRaw("select * from return_study_group()").ToList());
        }

        // GET: StudyGroupController/Details/5
        public ActionResult Details(int id)
        {
            return View();
        }

        // GET: StudyGroupController/Create
        public ActionResult Create()
        {
            var teachers = _context.teachers.ToList();
            ViewBag.teachers = new SelectList(teachers, "id", "name");
            return View();
        }

        // POST: StudyGroupController/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(IFormCollection collection)
        {
            try
            {
                var tmp = collection["teacherid"];
                NpgsqlParameter teacher = new("@id_teacher", Int32.Parse(collection["teacherid"].ToString()));
                NpgsqlParameter name = new("@name", collection["group_name"].ToString());
                _context.Database.ExecuteSqlRaw("call study_group_insert (@name, @id_teacher)", name, teacher);
                var last_id = Int32.Parse(_context.study_groups.Select(x => x.id).Max().ToString());
                return RedirectToAction("Edit", new {id=last_id});
            }
            catch
            {
                return RedirectToAction(nameof(Index));
            }
        }

        // GET: StudyGroupController/Edit/5
        public ActionResult Edit(int id)
        {
            var model = _context.study_group_teacher.FromSqlRaw($@"select * from return_study_group_teacher({id})").ToList();
            ViewBag.teacher = model[0].teacher_name;
            ViewBag.study_group = model[0].study_group_name;
            ViewBag.id_study_group = model[0].id;
            return View(_context.study_group_worker.FromSqlRaw($@"select * from return_study_group_workers({id})"));
        }

        // POST: StudyGroupController/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit(int id, IFormCollection collection)
        {
            try
            {
                NpgsqlParameter name = new("@name", collection["study_group_name"].ToString());
                NpgsqlParameter _id = new("@id", id);
                _context.Database.ExecuteSqlRaw("call update_study_group_name(@id, @name)", _id, name);
                return RedirectToAction("Edit", new {id=id});
            }
            catch
            {
                return RedirectToAction(nameof(Index));
            }
        }

        // GET: StudyGroupController/Delete/5
        public ActionResult Delete(int id)
        {
            var id_study_group = Int32.Parse(Request.Query["id_study_group"]);
            _context.Database.ExecuteSqlRaw($@"call delete_worker ({id}, {id_study_group})");
            return RedirectToAction("Edit", new { id = id_study_group });
        }

        // POST: StudyGroupController/Delete/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Delete(int id, IFormCollection collection)
        {
            try
            {
                return RedirectToAction(nameof(Index));
            }
            catch
            {
                return View();
            }
        }

        public ActionResult addWorker(int id)
        {
            var model = _context.study_group_teacher.FromSqlRaw($@"select * from return_study_group_teacher({id})").ToList();
            ViewBag.teacher = model[0].teacher_name;
            ViewBag.study_group = model[0].study_group_name;
            ViewBag.id_study_group = model[0].id;

            var tmp = _context.teachers.FromSqlRaw($@"select * from return_teacher({id})").ToList();
            var teacher_id = tmp[0].id;

            int selectedIndex = 0;
            SelectList organizations = new SelectList(_context.organizations.OrderBy(x=>x.id).Where(s=>s.id_teacher == teacher_id), "id", "name", selectedIndex);
            ViewBag.organizations = organizations;

            var toWorker = _context.organizations.OrderBy(x => x.id).Where(s => s.id_teacher == teacher_id).ToList();

            int orgs;
            try
            {
                orgs = toWorker[0].id;
            }
            catch
            {
                orgs = -1;
            }

            var mod = _context.workers.FromSqlRaw($@"select * from return_workers({id}, {orgs})").ToList();

            return View(mod);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult addWorker(int id, IFormCollection collection)
        {
            try
            {
                NpgsqlParameter id_work = new("@id_work", Int32.Parse(collection["workers"].ToString()));
                NpgsqlParameter _id = new("@id", id);
                _context.Database.ExecuteSqlRaw("call insert_worker(@id_work, @id)", id_work, _id);
                return RedirectToAction("Edit", new { id = id });
            }
            catch
            {
                return RedirectToAction(nameof(Index));
            }
        }

        public ActionResult getWorkers(int _id_org)
        {
            var _id_group = Int32.Parse(Request.Query["id_study_group"]);
            var id_org = Int32.Parse(Request.Query["id_org"]);
            var model = _context.workers.FromSqlRaw($@"select * from return_workers({_id_group}, {id_org})").ToList();
            return PartialView(model);
        }
    }
}
